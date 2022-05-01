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

-- Comments
COMMENT ON TABLE exoplanet.dim_star
    IS 'Stellar data (positions, distances, V mag, mass, metallicities etc) are taken from Simbad or from professional papers on exoplanets.';

COMMENT ON COLUMN exoplanet.dim_star.star_name
    IS 'The name of the star.';

COMMENT ON COLUMN exoplanet.dim_star.star_detected_disc
    IS 'Direct imaging or IR excess disc detected.';

COMMENT ON COLUMN exoplanet.dim_star.star_age
    IS 'The stellar age in billions of years (GY or giga-annum).';

COMMENT ON COLUMN exoplanet.dim_star.star_metallicity
    IS 'Decimal logarithm of the massive elements (« metals ») to hydrogen ratio in solar units  (i.e. Log [(metals/H)star/(metals/H)Sun] ).';

COMMENT ON COLUMN exoplanet.dim_star.star_sp_type
    IS 'Stellar spectral type.';

COMMENT ON COLUMN exoplanet.dim_star.star_teff
    IS 'Effective stellar temperature.';

COMMENT ON COLUMN exoplanet.dim_star.star_magnetic_field
    IS 'Whether a stellar magnetic field is detected or not.';

COMMENT ON COLUMN exoplanet.dim_star.star_alternate_names
    IS 'Alternative names for the given star.';
    
-- Insert initial row
INSERT INTO exoplanet.dim_star(
	star_name, star_detected_disc, star_age, 
	star_metallicity, star_sp_type, star_teff, 
	star_magnetic_field, star_alternate_names, 
	row_current, current_as_of, row_expired_date
) VALUES(
	'No Value',NULL,9999,9999,NULL,9999,NULL
	,NULL,'f'::BOOLEAN,NULL::DATE,NULL::DATE
);