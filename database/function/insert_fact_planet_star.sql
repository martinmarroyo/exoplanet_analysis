CREATE OR REPLACE FUNCTION exoplanet.insert_fact_planet_star(
	)
    RETURNS void
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
WITH facts AS (
	SELECT
		dim_planet.planet_key
		,dim_star.star_key
		,dim_day.date_key
		,fact_planet_star.mass
		AS planet_mass
		,fact_planet_star.mass_error_min
		AS planet_mass_error_min
		,fact_planet_star.mass_error_max
		AS planet_mass_error_max
		,fact_planet_star.mass_sini
		AS planet_mass_sini
		,fact_planet_star.mass_sini_error_min
		AS planet_mass_sini_error_min
		,fact_planet_star.mass_sini_error_max
		AS planet_mass_sini_error_max
		,fact_planet_star.radius
		AS planet_radius
		,fact_planet_star.radius_error_min
		AS planet_radius_error_min
		,fact_planet_star.radius_error_max
		AS planet_radius_error_max
		,fact_planet_star.orbital_period
		AS planet_orbital_period
		,fact_planet_star.orbital_period_error_min
		AS planet_orbital_period_error_min
		,fact_planet_star.orbital_period_error_max
		AS planet_orbital_period_error_max
		,fact_planet_star.semi_major_axis
		AS planet_semi_major_axis
		,fact_planet_star.semi_major_axis_error_min
		AS planet_semi_major_axis_error_min
		,fact_planet_star.semi_major_axis_error_max
		AS planet_semi_major_axis_error_max
		,fact_planet_star.eccentricity
		AS planet_eccentricity
		,fact_planet_star.eccentricity_error_min
		AS planet_eccentricity_error_min
		,fact_planet_star.eccentricity_error_max
		AS planet_eccentricity_error_max
		,fact_planet_star.inclination
		AS planet_inclination
		,fact_planet_star.inclination_error_min
		AS planet_inclination_error_min
		,fact_planet_star.inclination_error_max
		AS planet_inclination_error_max
		,fact_planet_star.angular_distance
		AS planet_angular_distance
		,fact_planet_star.omega
		AS planet_omega
		,fact_planet_star.omega_error_min
		AS planet_omega_error_min
		,fact_planet_star.omega_error_max
		AS planet_omega_error_max
		,fact_planet_star.tperi
		AS planet_tperi
		,fact_planet_star.tperi_error_min
		AS planet_tperi_error_min
		,fact_planet_star.tperi_error_max
		AS planet_tperi_error_max
		,fact_planet_star.tconj
		AS planet_tconj
		,fact_planet_star.tconj_error_min
		AS planet_tconj_error_min
		,fact_planet_star.tconj_error_max
		AS planet_tconj_error_max
		,fact_planet_star.tzero_tr
		AS planet_tzero_tr
		,fact_planet_star.tzero_tr_error_min
		AS planet_tzero_tr_error_min
		,fact_planet_star.tzero_tr_error_max
		AS planet_tzero_tr_error_max
		,fact_planet_star.tzero_tr_sec
		AS planet_tzero_tr_sec
		,fact_planet_star.tzero_tr_sec_error_min
		AS planet_tzero_tr_sec_error_min
		,fact_planet_star.tzero_tr_sec_error_max
		AS planet_tzero_tr_sec_error_max
		,fact_planet_star.lambda_angle
		AS planet_lambda_angle
		,fact_planet_star.lambda_angle_error_min
		AS planet_lambda_angle_error_min
		,fact_planet_star.lambda_angle_error_max
		AS planet_lambda_angle_error_max
		,fact_planet_star.impact_parameter
		AS planet_impact_parameter
		,fact_planet_star.impact_parameter_error_min
		AS planet_impact_parameter_error_min
		,fact_planet_star.impact_parameter_error_max
		AS planet_impact_parameter_error_max
		,fact_planet_star.tzero_vr
		AS planet_tzero_vr
		,fact_planet_star.tzero_vr_error_min
		AS planet_tzero_vr_error_min
		,fact_planet_star.tzero_vr_error_max
		AS planet_tzero_vr_error_max
		,fact_planet_star.k
		AS planet_k
		,fact_planet_star.k_error_min
		AS planet_k_error_min
		,fact_planet_star.k_error_max
		AS planet_k_error_max
		,fact_planet_star.temp_calculated
		AS planet_temp_calculated
		,fact_planet_star.temp_calculated_error_min
		AS planet_temp_calculated_error_min
		,fact_planet_star.temp_calculated_error_max
		AS planet_temp_calculated_error_max
		,fact_planet_star.temp_measured
		AS planet_temp_measured
		,fact_planet_star.hot_point_lon
		AS planet_hot_point_lon
		,fact_planet_star.geometric_albedo
		AS planet_geometric_albedo
		,fact_planet_star.geometric_albedo_error_min
		AS planet_geometric_albedo_error_min
		,fact_planet_star.geometric_albedo_error_max
		AS planet_geometric_albedo_error_max
		,fact_planet_star.log_g
		AS planet_log_g
		--## Star facts
		,fact_planet_star.ra
		AS star_ra
		,fact_planet_star.dec
		AS star_dec
		,fact_planet_star.mag_v
		AS star_mag_v
		,fact_planet_star.mag_i
		AS star_mag_i
		,fact_planet_star.mag_j
		AS star_mag_j
		,fact_planet_star.mag_h
		AS star_mag_h
		,fact_planet_star.mag_k
		AS star_mag_k
		,fact_planet_star.star_distance
		,fact_planet_star.star_distance_error_min
		,fact_planet_star.star_distance_error_max
		,fact_planet_star.star_metallicity_error_min
		,fact_planet_star.star_metallicity_error_max
		,fact_planet_star.star_mass
		,fact_planet_star.star_mass_error_min
		,fact_planet_star.star_mass_error_max
		,fact_planet_star.star_radius
		,fact_planet_star.star_radius_error_min
		,fact_planet_star.star_radius_error_max
		,fact_planet_star.star_age_error_min
		,fact_planet_star.star_age_error_max
		,fact_planet_star.star_teff_error_min
		,fact_planet_star.star_teff_error_max
		,NOW()::DATE AS row_entry_date
	FROM
		exoplanet.exoplanet_data fact_planet_star
	INNER JOIN (
		SELECT planet_name,planet_key
		FROM exoplanet.dim_planet
		WHERE row_current
	) dim_planet
	ON COALESCE(fact_planet_star.planet_name,'No Value')=dim_planet.planet_name
	INNER JOIN (
		SELECT star_name,star_key
		FROM exoplanet.dim_star
		WHERE row_current
	) dim_star
	ON COALESCE(fact_planet_star.star_name,'No Value')=dim_star.star_name
	INNER JOIN (
		SELECT date,date_key
		FROM exoplanet.dim_day
	)dim_day
	ON COALESCE(fact_planet_star.updated,'1000-12-31')=dim_day.date
	-- Only get the current data load
	WHERE
		fact_planet_star.updated = (SELECT MAX(updated::DATE)
								    FROM exoplanet.exoplanet_data)
)
INSERT INTO exoplanet.fact_planet_star(
	planet_key, star_key, date_key, planet_mass, 
	planet_mass_error_min, planet_mass_error_max, 
	planet_mass_sini, planet_mass_sini_error_min, 
	planet_mass_sini_error_max, planet_radius, 
	planet_radius_error_min, planet_radius_error_max, 
	planet_orbital_period, planet_orbital_period_error_min, 
	planet_orbital_period_error_max, planet_semi_major_axis, 
	planet_semi_major_axis_error_min, 
	planet_semi_major_axis_error_max, planet_eccentricity, 
	planet_eccentricity_error_min, planet_eccentricity_error_max, 
	planet_inclination, planet_inclination_error_min, 
	planet_inclination_error_max, planet_angular_distance, 
	planet_omega, planet_omega_error_min, planet_omega_error_max, 
	planet_tperi, planet_tperi_error_min, planet_tperi_error_max, 
	planet_tconj, planet_tconj_error_min, planet_tconj_error_max, 
	planet_tzero_tr, planet_tzero_tr_error_min, planet_tzero_tr_error_max, 
	planet_tzero_tr_sec, planet_tzero_tr_sec_error_min, 
	planet_tzero_tr_sec_error_max, planet_lambda_angle, 
	planet_lambda_angle_error_min, planet_lambda_angle_error_max, 
	planet_impact_parameter, planet_impact_parameter_error_min, 
	planet_impact_parameter_error_max, planet_tzero_vr, 
	planet_tzero_vr_error_min, planet_tzero_vr_error_max, planet_k, 
	planet_k_error_min, planet_k_error_max, planet_temp_calculated, 
	planet_temp_calculated_error_min, planet_temp_calculated_error_max, 
	planet_temp_measured, planet_hot_point_lon, planet_geometric_albedo, 
	planet_geometric_albedo_error_min, planet_geometric_albedo_error_max, 
	planet_log_g, star_ra, star_dec, star_mag_v, star_mag_i, star_mag_j, 
	star_mag_h, star_mag_k, star_distance, star_distance_error_min, 
	star_distance_error_max, star_metallicity_error_min, 
	star_metallicity_error_max, star_mass, star_mass_error_min, 
	star_mass_error_max, star_radius, star_radius_error_min, 
	star_radius_error_max, star_age_error_min, star_age_error_max, 
	star_teff_error_min, star_teff_error_max, row_entry_date
)
SELECT *
FROM facts;
$BODY$;
