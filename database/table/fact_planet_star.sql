CREATE TABLE IF NOT EXISTS exoplanet.fact_planet_star (
	planet_key INT
	,star_key INT
	,date_key INT
	,planet_mass DOUBLE PRECISION
	,planet_mass_error_min DOUBLE PRECISION
	,planet_mass_error_max DOUBLE PRECISION
	,planet_mass_sini DOUBLE PRECISION
	,planet_mass_sini_error_min DOUBLE PRECISION
	,planet_mass_sini_error_max DOUBLE PRECISION
	,planet_radius DOUBLE PRECISION
	,planet_radius_error_min DOUBLE PRECISION
	,planet_radius_error_max DOUBLE PRECISION
	,planet_orbital_period DOUBLE PRECISION
	,planet_orbital_period_error_min DOUBLE PRECISION
	,planet_orbital_period_error_max DOUBLE PRECISION
	,planet_semi_major_axis DOUBLE PRECISION
	,planet_semi_major_axis_error_min DOUBLE PRECISION
	,planet_semi_major_axis_error_max DOUBLE PRECISION
	,planet_eccentricity DOUBLE PRECISION
	,planet_eccentricity_error_min DOUBLE PRECISION
	,planet_eccentricity_error_max DOUBLE PRECISION
	,planet_inclination DOUBLE PRECISION
	,planet_inclination_error_min DOUBLE PRECISION
	,planet_inclination_error_max DOUBLE PRECISION
	,planet_angular_distance DOUBLE PRECISION
	,planet_omega DOUBLE PRECISION
	,planet_omega_error_min DOUBLE PRECISION
	,planet_omega_error_max DOUBLE PRECISION
	,planet_tperi DOUBLE PRECISION
	,planet_tperi_error_min DOUBLE PRECISION
	,planet_tperi_error_max DOUBLE PRECISION
	,planet_tconj DOUBLE PRECISION
	,planet_tconj_error_min DOUBLE PRECISION
	,planet_tconj_error_max DOUBLE PRECISION
	,planet_tzero_tr DOUBLE PRECISION
	,planet_tzero_tr_error_min DOUBLE PRECISION
	,planet_tzero_tr_error_max DOUBLE PRECISION
	,planet_tzero_tr_sec DOUBLE PRECISION
	,planet_tzero_tr_sec_error_min DOUBLE PRECISION
	,planet_tzero_tr_sec_error_max DOUBLE PRECISION
	,planet_lambda_angle DOUBLE PRECISION
	,planet_lambda_angle_error_min DOUBLE PRECISION
	,planet_lambda_angle_error_max DOUBLE PRECISION
	,planet_impact_parameter DOUBLE PRECISION
	,planet_impact_parameter_error_min DOUBLE PRECISION
	,planet_impact_parameter_error_max DOUBLE PRECISION
	,planet_tzero_vr DOUBLE PRECISION
	,planet_tzero_vr_error_min DOUBLE PRECISION
	,planet_tzero_vr_error_max DOUBLE PRECISION
	,planet_k DOUBLE PRECISION
	,planet_k_error_min DOUBLE PRECISION
	,planet_k_error_max DOUBLE PRECISION
	,planet_temp_calculated DOUBLE PRECISION
	,planet_temp_calculated_error_min DOUBLE PRECISION
	,planet_temp_calculated_error_max DOUBLE PRECISION
	,planet_temp_measured DOUBLE PRECISION
	,planet_hot_point_lon DOUBLE PRECISION
	,planet_geometric_albedo DOUBLE PRECISION
	,planet_geometric_albedo_error_min DOUBLE PRECISION
	,planet_geometric_albedo_error_max DOUBLE PRECISION
	,planet_log_g DOUBLE PRECISION
	,star_ra DOUBLE PRECISION
	,star_dec DOUBLE PRECISION
	,star_mag_v DOUBLE PRECISION
	,star_mag_i DOUBLE PRECISION
	,star_mag_j DOUBLE PRECISION
	,star_mag_h DOUBLE PRECISION
	,star_mag_k DOUBLE PRECISION
	,star_distance DOUBLE PRECISION
	,star_distance_error_min DOUBLE PRECISION
	,star_distance_error_max DOUBLE PRECISION
	,star_metallicity_error_min DOUBLE PRECISION
	,star_metallicity_error_max DOUBLE PRECISION
	,star_mass DOUBLE PRECISION
	,star_mass_error_min DOUBLE PRECISION
	,star_mass_error_max DOUBLE PRECISION
	,star_radius DOUBLE PRECISION
	,star_radius_error_min DOUBLE PRECISION
	,star_radius_error_max DOUBLE PRECISION
	,star_age_error_min DOUBLE PRECISION
	,star_age_error_max DOUBLE PRECISION
	,star_teff_error_min DOUBLE PRECISION
	,star_teff_error_max DOUBLE PRECISION
	,row_entry_date DATE
);

-- Comments
COMMENT ON COLUMN exoplanet.fact_planet_star.planet_mass
    IS 'Mass of the planet.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_mass_sini
    IS 'Minimum mass of the planet due to inclination effect.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_radius
    IS 'Radius of the planet.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_orbital_period
    IS 'Orbital period of the planet.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_semi_major_axis
    IS 'Semi-major axis of the planet orbit.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_eccentricity
    IS 'Eccentrity of the planet orbit from 0, circular orbit, to almost 1, very elongated orbit.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_inclination
    IS 'Inclination of planet orbit, angle between the planet orbit and the sky plane. Measured in degrees.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_angular_distance
    IS 'Formal star-planet angular separation given by a/Distance. Measured in arc seconds.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_omega
    IS 'Periapse longitude : angle between the periapse and the line nodes in the orbit plane.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_tperi
    IS 'Time of passage at the periapse for eccentric orbits.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_tconj
    IS 'Time of the star-planet upper conjunction.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_tzero_tr
    IS 'Time of passage at the center of the transit light curve for the primary transit.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_tzero_tr_sec
    IS 'Time of passage at the center of the transit light curve for the secondary transit.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_lambda_angle
    IS 'Sky-projected angle between the planetary orbital spin and the stellar rotational spin (Rossiter-McLaughlin anomaly).';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_impact_parameter
    IS 'Minimum, in stellar radius units, of distance of the planet to the stellar center for transiting planets.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_tzero_vr
    IS 'Time of zero, increasing, radial velocity (i.e. when the planet moves toward the observer) for circular orbits.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_k
    IS 'Semi-amplitude of the radial velocity curve. Measured in m/s.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_temp_calculated
    IS 'Planet temperature as calculated by authors, based on a planet model.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_temp_measured
    IS 'Planet temperature as measured by authors.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_hot_point_lon
    IS 'Longitude of the planet hottest point.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_geometric_albedo
    IS 'Albedo.';

COMMENT ON COLUMN exoplanet.fact_planet_star.planet_log_g
    IS 'Surface gravity of the planet.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_ra
    IS 'Right Ascension (hh :mm :ss).';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_dec
    IS 'Declination (hh :mm :ss).';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mag_v
    IS 'Apparent magnitude in the V band.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mag_i
    IS 'Apparent magnitude in the I band.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mag_j
    IS 'Apparent magnitude in the J band.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mag_h
    IS 'Apparent magnitude in the H band.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mag_k
    IS 'Apparent magnitude in the K band.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_distance
    IS 'Distance of the star to the observer. Measured in parsecs (pc).';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_mass
    IS 'Star mas in solar units.';

COMMENT ON COLUMN exoplanet.fact_planet_star.star_radius
    IS 'Star radius in solar units.';