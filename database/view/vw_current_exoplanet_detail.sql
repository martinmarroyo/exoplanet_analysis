CREATE MATERIALIZED VIEW exoplanet.vw_current_exoplanet_detail AS
SELECT 
	dim_planet.planet_key
	,dim_planet.planet_name
	,dim_star.star_name
	AS host_star
	,dim_planet.planet_status
	,dim_planet.discovered
	,dim_planet.publication
	,dim_planet.detection_type
	,dim_planet.mass_detection_type
	,dim_planet.radius_detection_type
	,dim_planet.molecules
	,fact_planet_star.planet_mass
	,fact_planet_star.planet_mass_error_min
	,fact_planet_star.planet_mass_sini
	,fact_planet_star.planet_mass_sini_error_min
	,fact_planet_star.planet_mass_sini_error_max
	,fact_planet_star.planet_radius
	,fact_planet_star.planet_radius_error_min
	,fact_planet_star.planet_orbital_period
	,fact_planet_star.planet_orbital_period_error_min
	,fact_planet_star.planet_orbital_period_error_max
	,fact_planet_star.planet_semi_major_axis
	,fact_planet_star.planet_semi_major_axis_error_min
	,fact_planet_star.planet_semi_major_axis_error_max
	,fact_planet_star.planet_eccentricity
	,fact_planet_star.planet_eccentricity_error_min
	,fact_planet_star.planet_eccentricity_error_max
	,fact_planet_star.planet_inclination
	,fact_planet_star.planet_inclination_error_min
	,fact_planet_star.planet_inclination_error_max
	,fact_planet_star.planet_angular_distance
	,fact_planet_star.planet_omega
	,fact_planet_star.planet_omega_error_min
	,fact_planet_star.planet_omega_error_max
	,fact_planet_star.planet_tperi
	,fact_planet_star.planet_tperi_error_min
	,fact_planet_star.planet_tperi_error_max
	,fact_planet_star.planet_tconj
	,fact_planet_star.planet_tconj_error_min
	,fact_planet_star.planet_tconj_error_max
	,fact_planet_star.planet_tzero_tr
	,fact_planet_star.planet_tzero_tr_error_min
	,fact_planet_star.planet_tzero_tr_error_max
	,fact_planet_star.planet_tzero_tr_sec
	,fact_planet_star.planet_tzero_tr_sec_error_min
	,fact_planet_star.planet_tzero_tr_sec_error_max
	,fact_planet_star.planet_lambda_angle
	,fact_planet_star.planet_lambda_angle_error_min
	,fact_planet_star.planet_lambda_angle_error_max
	,fact_planet_star.planet_impact_parameter
	,fact_planet_star.planet_impact_parameter_error_min
	,fact_planet_star.planet_impact_parameter_error_max
	,fact_planet_star.planet_tzero_vr
	,fact_planet_star.planet_tzero_vr_error_min
	,fact_planet_star.planet_tzero_vr_error_max
	,fact_planet_star.planet_k
	,fact_planet_star.planet_k_error_min
	,fact_planet_star.planet_k_error_max
	,fact_planet_star.planet_temp_calculated
	,fact_planet_star.planet_temp_calculated_error_min
	,fact_planet_star.planet_temp_calculated_error_max
	,fact_planet_star.planet_temp_measured
	,fact_planet_star.planet_hot_point_lon
	,fact_planet_star.planet_geometric_albedo
	,fact_planet_star.planet_geometric_albedo_error_min
	,fact_planet_star.planet_geometric_albedo_error_max
	,fact_planet_star.planet_log_g
	,dim_planet.alternate_names
FROM 
	exoplanet.fact_planet_star
-- Filter for only most recent facts
INNER JOIN (
	SELECT 
		planet_key
		,star_key
		,MAX(date_key) 
		AS date_key
		,MAX(row_entry_date) 
		AS row_entry_date
	FROM 
		exoplanet.fact_planet_star
	GROUP BY 
		planet_key
		,star_key
)recent
ON fact_planet_star.planet_key=recent.planet_key
	AND fact_planet_star.star_key=recent.star_key
	AND fact_planet_star.date_key=recent.date_key
	AND fact_planet_star.row_entry_date=recent.row_entry_date
INNER JOIN 
	exoplanet.dim_planet
	ON fact_planet_star.planet_key=dim_planet.planet_key
		AND dim_planet.row_current
INNER JOIN
	exoplanet.dim_star
	ON fact_planet_star.star_key=dim_star.star_key
ORDER BY
	dim_planet.planet_key;
	
CREATE INDEX idx_exoplanet_status ON exoplanet.vw_current_exoplanet_detail(planet_status,discovered,host_star);
CREATE INDEX idx_exoplanet_name ON exoplanet.vw_current_exoplanet_detail(planet_name);
CREATE INDEX idx_exoplanet_star ON exoplanet.vw_current_exoplanet_detail(host_star);