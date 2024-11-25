-- 1.

CREATE EXTENSION postgis;

CREATE TABLE public.obiekty
(
    id serial NOT NULL,
    nazwa character varying(10),
	geometria geometry,
    PRIMARY KEY (id)
);

INSERT INTO obiekty(nazwa, geometria) 
VALUES
('obiekt1', 
	ST_CollectionExtract(
		ST_CurveToLine(
			ST_GeomFromEWKT(
	 			'SRID=0;GEOMETRYCOLLECTION(
					 LINESTRING(0 1, 1 1),
				 	 CIRCULARSTRING(1 1, 2 0, 3 1),
				 	 CIRCULARSTRING(3 1, 4 2, 5 1),
				 	 LINESTRING(5 1, 6 1)
	 			)'
 			)
		)
	)
),
('obiekt2', 
	ST_SetSRID(
		ST_BuildArea(
			ST_Collect(
				ARRAY[
					'LINESTRING(10 6, 14 6)',
					'CIRCULARSTRING(14 6, 16 4, 14 2)',
					'CIRCULARSTRING(14 2, 12 0, 10 2)',
					'LINESTRING(10 2, 10 6)',
					ST_Buffer(ST_POINT(12, 2), 1, 6000)
				]
			)
		), 0
	)
),
('obiekt3', 
	ST_GeomFromEWKT(
		'SRID=0;POLYGON((10 17, 12 13, 7 15, 10 17))'
	)
),
('obiekt4', 
	ST_GeomFromEWKT(
		'SRID=0;LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'
	)
),
('obiekt5', 
	ST_GeomFromEWKT(
		'SRID=0;MULTIPOINT((30 50 59), (38 32 234))'
	)
),
('obiekt6', 
	ST_SetSRID(
		ST_Collect(
			'LINESTRING(1 1, 3 2)',
			'POINT(4 2)'
		), 0
	)
);

-- 2. bufor 5
WITH shortest_line AS (
  SELECT ST_ShortestLine(
           (SELECT geometria FROM obiekty WHERE id = 3),
           (SELECT geometria FROM obiekty WHERE id = 4)
         ) AS geom
),
buffer AS (
  SELECT ST_Buffer(geom, 5) AS buffer_geom
  FROM shortest_line
)
SELECT ST_Area(buffer_geom) AS buffer_area
FROM buffer;

-- 3. 
-- warunki: zamknięta geometria, min. 4 punkty

WITH closed_geom AS (
  SELECT ST_MakePolygon(ST_AddPoint(geometria, ST_StartPoint(geometria))) AS polygon_geom
  FROM obiekty
  WHERE id = 4
)
SELECT polygon_geom
FROM closed_geom;

UPDATE obiekty
SET geometria = ST_MakePolygon(ST_AddPoint(geometria, ST_StartPoint(geometria)))
WHERE id = 4;

-- 4. połaczenie 3 i 4
INSERT INTO obiekty (nazwa, geometria)
SELECT 
    'obiekt7' AS nazwa,
    ST_Union(
        (SELECT geometria FROM obiekty WHERE id = 3),
        (SELECT geometria FROM obiekty WHERE id = 4)
    ) AS geometria;

-- 5. bufor, bez łuków
WITH no_arcs AS (
  SELECT nazwa, geometria
  FROM obiekty
  WHERE NOT ST_GeometryType(geometria) LIKE '%CIRCULAR%' -- Wyklucz geometrie zawierające łuki
),
buffered_geometries AS (
  SELECT nazwa, ST_Buffer(geometria, 5) AS buffer_geom
  FROM no_arcs
),
areas AS (
  SELECT nazwa, ST_Area(buffer_geom) AS area
  FROM buffered_geometries
)
SELECT SUM(area) AS total_buffer_area
FROM areas;
