CREATE TABLE IF NOT EXISTS exoplanet.dim_planet(
	planet_key SERIAL
	,planet_name TEXT
	,planet_status TEXT
	,discovered DOUBLE PRECISION
	,publication TEXT
	,detection_type TEXT
	,mass_detection_type TEXT
	,radius_detection_type TEXT
	,molecules TEXT
	,alternate_names TEXT
	,row_current BOOLEAN
	,current_as_of DATE
	,row_expired_date DATE
	,PRIMARY KEY(planet_key)
);

-- Insert initial row
INSERT INTO exoplanet.dim_planet(
	planet_name, planet_status, discovered, 
	publication, detection_type, mass_detection_type, 
	radius_detection_type, molecules, alternate_names, 
	row_current, current_as_of, row_expired_date
) VALUES(
	'No Value',NULL,9999,NULL
	,NULL,NULL,NULL,NULL,NULL
	,'f'::BOOLEAN,NULL::DATE
	,NULL::DATE
);