CREATE MATERIALIZED VIEW IF NOT EXISTS exoplanet.vw_current_star_detail AS 
SELECT DISTINCT
	dim_star.star_key
	,dim_star.star_name
	,dim_day.date AS star_date
	,dim_star.star_detected_disc
	,dim_star.star_age
	,dim_star.star_metallicity
	,dim_star.star_sp_type
	,dim_star.star_teff
	,dim_star.star_magnetic_field
	,fact_planet_star.star_ra
	,fact_planet_star.star_dec
	,fact_planet_star.star_mag_v
	,fact_planet_star.star_mag_i
	,fact_planet_star.star_mag_j
	,fact_planet_star.star_mag_h
	,fact_planet_star.star_mag_k
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
	,dim_star.star_alternate_names
	,COUNT(DISTINCT fact_planet_star.planet_key)
	AS planets_in_star_sys
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
	exoplanet.dim_star
	ON fact_planet_star.star_key=dim_star.star_key
		AND dim_star.star_key<>1 -- Remove null star names
		AND dim_star.row_current
INNER JOIN
	exoplanet.dim_day
	ON fact_planet_star.date_key=dim_day.date_key
GROUP BY
	dim_star.star_key
	,dim_star.star_name
	,dim_day.date
	,dim_star.star_detected_disc
	,dim_star.star_age
	,dim_star.star_metallicity
	,dim_star.star_sp_type
	,dim_star.star_teff
	,dim_star.star_magnetic_field
	,fact_planet_star.star_ra
	,fact_planet_star.star_dec
	,fact_planet_star.star_mag_v
	,fact_planet_star.star_mag_i
	,fact_planet_star.star_mag_j
	,fact_planet_star.star_mag_h
	,fact_planet_star.star_mag_k
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
	,dim_star.star_alternate_names
ORDER BY 
	star_key;

CREATE INDEX idx_star_detail_name ON exoplanet.vw_current_star_detail(star_name);
CREATE INDEX idx_star_detail_planets ON exoplanet.vw_current_star_detail(planets_in_star_sys);
CREATE INDEX idx_star_detail_age_planets ON exoplanet.vw_current_star_detail(star_age,planets_in_star_sys);