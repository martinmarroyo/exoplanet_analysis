CREATE TABLE IF NOT EXISTS exoplanet.dim_star (
	star_key SERIAL
	,star_name TEXT
	,star_detected_disc TEXT
	,star_age DOUBLE PRECISION
	,star_metallicity DOUBLE PRECISION
	,star_sp_type TEXT
	,star_teff DOUBLE PRECISION
	,star_magnetic_field TEXT
	,star_alternate_names TEXT
	,row_current BOOLEAN
	,current_as_of DATE
	,row_expired_date DATE
	,PRIMARY KEY(star_key)
);

INSERT INTO exoplanet.dim_star(
	star_name, star_detected_disc, star_age, 
	star_metallicity, star_sp_type, star_teff, 
	star_magnetic_field, star_alternate_names, 
	row_current, current_as_of, row_expired_date
) VALUES(
	'No Value',NULL,9999,9999,NULL,9999,NULL
	,NULL,'f'::BOOLEAN,NULL::DATE,NULL::DATE
);