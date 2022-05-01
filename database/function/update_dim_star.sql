CREATE OR REPLACE FUNCTION exoplanet.update_dim_star(
	)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
WITH inserts AS (
	SELECT DISTINCT
		star_name
		,star_detected_disc
		,star_age
		,star_metallicity
		,star_sp_type
		,star_teff
		,star_magnetic_field
		,COALESCE(star_alternate_names,'None')
		AS star_alternate_names
		,'t'::BOOLEAN AS row_current
		,NOW()::DATE AS current_as_of
	FROM
		exoplanet.exoplanet_data
	WHERE
		star_name IS NOT NULL
		AND updated = (SELECT MAX(updated)
					   FROM exoplanet.exoplanet_data)
)
, updates AS (
	-- Expire old rows
	UPDATE exoplanet.dim_star
	SET row_current='f',row_expired_date=NOW()::DATE
	FROM inserts
	WHERE dim_star.star_name=inserts.star_name
)
INSERT INTO exoplanet.dim_star(
	star_name, star_detected_disc, star_age, 
	star_metallicity, star_sp_type, star_teff, 
	star_magnetic_field, star_alternate_names, 
	row_current, current_as_of
)
SELECT *
FROM inserts
$BODY$;