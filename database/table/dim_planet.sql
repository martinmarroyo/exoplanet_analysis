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

-- Comments
COMMENT ON TABLE exoplanet.dim_planet
    IS 'Planet data are the latest data known. They are taken from:
Latest published papers or professional preprints and conferences
First-hand updated data on professional websites. These presently are:
- Anglo-Australian Planet Search
- California & Carnegie Planet Search
- Geneva Extrasolar Planet Search Programmes
- Transatlantic Exoplanet Survey
- University of Texas - Dept. of Astronomy
- HAT and HATS
- WASP
- NASA Exoplanet Archive
- Kepler';

COMMENT ON COLUMN exoplanet.dim_planet.planet_name
    IS 'The name of the exoplanet. For single planetary companions to a host star, the name is generally NNN b where NNN is the parent star name. When NNN is not taken from a standard star catalog (e.g. HD, HIP, 2MASS, …), NNN is the name given by the discoverers (e.g. CoRoT, Kepler, …).
For multi-planet systems, the planet names are NNN x where x = b, c, d, etc refers to the chronological order of discovery of the planet.
Exceptions are possible, like TrES-1 or planets detected by microlensing.
For "free floating" planets, the name is the name given by the discoverers.';

COMMENT ON COLUMN exoplanet.dim_planet.planet_status
    IS 'There are 4 categories of planets, Confirmed, Candidate, Retracted and Controversial. A planet is considered as Confirmed if it is claimed unambiguously in an accepted paper or a professional conference.';

COMMENT ON COLUMN exoplanet.dim_planet.discovered
    IS 'Year of discovery at the time of acceptance of a paper.';

COMMENT ON COLUMN exoplanet.dim_planet.publication
    IS 'Describes the type of publication the exoplanet was confirmed in. Can be one of the following: Submitted to a professional journal, Announced on a professional conference, Announced on a website,
or Published in a refereed paper.';

COMMENT ON COLUMN exoplanet.dim_planet.detection_type
    IS 'Methods of discovery/detection of the planet (RV, transit, TTV, lensing, astrometry, imaging. The first method is the discovery one.';

COMMENT ON COLUMN exoplanet.dim_planet.mass_detection_type
    IS 'Method of measurement of the planet mass (RV, astrometry, planet model for direct imaging).';

COMMENT ON COLUMN exoplanet.dim_planet.radius_detection_type
    IS ' Method of measurement of the planet radius (transit, planet model for direct imaging).';

COMMENT ON COLUMN exoplanet.dim_planet.molecules
    IS 'Species detected in the planet.';

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

