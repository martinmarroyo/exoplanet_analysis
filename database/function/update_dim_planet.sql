CREATE OR REPLACE FUNCTION exoplanet.update_dim_planet(
	)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
-- Update dim_planet
WITH inserts AS (
	SELECT
		planet_name
		,planet_status
		,discovered
		,publication
		,detection_type
		,mass_detection_type
		,radius_detection_type
		,molecules
		,COALESCE(alternate_names,'None')
		AS alternate_names
		,'t'::BOOLEAN AS row_current
		,NOW()::DATE AS current_as_of
	FROM 
		exoplanet.exoplanet_data
	WHERE 
		updated = (SELECT MAX(updated::DATE)
				   FROM exoplanet.exoplanet_data)
)
, updates AS (
	-- Expire old rows
	UPDATE exoplanet.dim_planet
	SET row_current='f',row_expired_date=NOW()::DATE
	FROM inserts
	WHERE dim_planet.planet_name=inserts.planet_name
)
INSERT INTO exoplanet.dim_planet(
	planet_name, planet_status, discovered, 
	publication, detection_type, mass_detection_type, 
	radius_detection_type, molecules, alternate_names, 
	row_current, current_as_of
)
SELECT *
FROM inserts;
$BODY$;
