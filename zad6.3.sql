SELECT proname, proargtypes, prosrc
FROM pg_catalog.pg_proc
WHERE pronamespace = 'public'::regnamespace;

SELECT proname, proargtypes, pg_catalog.pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND proname = 'st_tpi';

SELECT pg_catalog.pg_get_functiondef('public._st_tpi4ma'::regproc);

SELECT ST_AsTiff(ST_Union(rast))
FROM schema_stec.porto_ndvi;

SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM schema_stec.porto_ndvi;

CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM schema_stec.porto_ndvi;
----------------------------------------------
SELECT lo_export(loid, 'C:\Users\Public\Documents\myraster.tiff') --> Save the file in a place where the user postgres have access. In windows a flash drive usualy works fine.
FROM tmp_out;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out; --> Delete the large object.


