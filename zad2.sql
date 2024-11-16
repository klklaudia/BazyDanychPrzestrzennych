-- 3. dodanie funkcjonalnosci

CREATE EXTENSION postgis;

-- 4. tworzenie tabel

CREATE TABLE buildings (
    building_id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

CREATE TABLE roads (
    road_id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

CREATE TABLE points (
    point_id SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name VARCHAR(100)
);

-- 5. wypełnianie tabel
-- WKT: Geometria w formacie tekstowym - (extented) well known text
-- SRID: układ odniesienia (0 niezindentyfikowany)

INSERT INTO points (name, geometry)
VALUES
	('G', ST_GeomFromEWKT('SRID=0; POINT(1 3.5)')),
	('H', ST_GeomFromEWKT('SRID=0; POINT(5.5 1.5)')),
	('I', ST_GeomFromEWKT('SRID=0; POINT(9.5 6)')),
	('J', ST_GeomFromEWKT('SRID=0; POINT(6.5 6)')),
	('K', ST_GeomFromEWKT('SRID=0; POINT(6 9.5)'));
	-- ('K', ST_GeomFrom('POINT(6 9.5), 0'));

INSERT INTO roads(name, geometry)
VALUES
	('RoadX', ST_GeomFromEWKT('SRID=0; LINESTRING(0 4.5, 12 4.5)')),
	('RoadY', ST_GeomFromEWKT('SRID=0; LINESTRING(7.5 10.5, 7.5 0)'));

-- musi się skończyć na początkowym punkcie
INSERT INTO buildings(name, geometry) 
VALUES
	('BuildingA', ST_GeomFromEWKT('SRID=0;POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))')),
	('BuildingB', ST_GeomFromEWKT('SRID=0;POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))')),
	('BuildingC', ST_GeomFromEWKT('SRID=0;POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))')),
	('BuildingD', ST_GeomFromEWKT('SRID=0;POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))')),
	('BuildingF', ST_GeomFromEWKT('SRID=0;POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'));

-- 6.

-- a. całkowita długość dróg
SELECT SUM(ST_LENGTH(geometry)) AS total_roads_length 
FROM roads;

-- b. wtk, obwód i pole
SELECT ST_AsEWKT(geometry) AS ewkt_geometry, ST_Area(geometry) AS area, ST_Perimeter(geometry) AS perimeter 
FROM buildings
WHERE name = 'BuildingA';

-- c. pola budynków alfabetycznie
SELECT name, ST_Area(geometry) AS area
FROM buildings
ORDER BY name ASC;

-- d. dwa o największej powierzchni
SELECT name, ST_Perimeter(geometry) AS perimeter
FROM buildings
ORDER BY perimeter DESC
LIMIT 2;

-- e. najmniejsza ogległość między pkt K a bud. C
-- najbliższy pkt na obwodzie
SELECT 
    ST_Distance(b.geometry, p.geometry) AS min_distance
FROM 
    buildings b,
    points p
WHERE 
    b.name = 'BuildingC'
    AND p.name = 'K';

-- f. pole powirzchni, która znajduje się w odległości większej niż 0.5
-- ST_Difference część geometrii która się nie pokrywa
SELECT 
    ST_Area(
        ST_Difference(
            b1.geometry,
            ST_Buffer(b2.geometry, 0.5)
        )
    ) AS area
FROM 
    buildings b1,
    buildings b2
WHERE 
    b1.name = 'BuildingC' AND b2.name = 'BuildingB';

-- g. budynki o centroidach powyżej drogi x
-- droga jest pozioma
SELECT b.name
FROM buildings b
JOIN roads r ON r.name = 'RoadX'
WHERE ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_StartPoint(r.geometry));

-- h. niewspólna pwierzchnia dla c i nowego poligony
SELECT 
    ST_Area(
        ST_SymDifference(
            b.geometry,
            ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0)
        )
    ) AS area
FROM 
    buildings b
WHERE 
    b.name = 'BuildingC';