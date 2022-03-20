CREATE OR REPLACE FUNCTION exoplanet_stage.update_exoplanets_data()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
/*
    Takes new data and inserts into production
    table
*/
INSERT INTO exoplanet.exoplanet_data (
	SELECT
        index,
        "# name" AS
        planet_name,
        planet_status,
        mass::double precision,
        mass_error_min::double precision,
        mass_error_max::double precision,
        mass_sini::double precision,
        mass_sini_error_min::double precision,
        mass_sini_error_max::double precision,
        radius::double precision,
        radius_error_min::double precision,
        radius_error_max::double precision,
        orbital_period::double precision,
        orbital_period_error_min::double precision,
        orbital_period_error_max::double precision,
        semi_major_axis::double precision,
        semi_major_axis_error_min::double precision,
        semi_major_axis_error_max::double precision,
        eccentricity::double precision,
        eccentricity_error_min::double precision,
        eccentricity_error_max::double precision,
        inclination::double precision,
        inclination_error_min::double precision,
        inclination_error_max::double precision,
        angular_distance::double precision,
        discovered::double precision,
        updated::DATE,
        omega::double precision,
        omega_error_min::double precision,
        omega_error_max::double precision,
        tperi::double precision,
        tperi_error_min::double precision,
        tperi_error_max::double precision,
        tconj::double precision,
        tconj_error_min::double precision,
        tconj_error_max::double precision,
        tzero_tr::double precision,
        tzero_tr_error_min::double precision,
        tzero_tr_error_max::double precision,
        tzero_tr_sec::double precision,
        tzero_tr_sec_error_min::double precision,
        tzero_tr_sec_error_max::double precision,
        lambda_angle::double precision,
        lambda_angle_error_min::double precision,
        lambda_angle_error_max::double precision,
        impact_parameter::double precision,
        impact_parameter_error_min::double precision,
        impact_parameter_error_max::double precision,
        tzero_vr::double precision,
        tzero_vr_error_min::double precision,
        tzero_vr_error_max::double precision,
        k::double precision,
        k_error_min::double precision,
        k_error_max::double precision,
        temp_calculated::double precision,
        temp_calculated_error_min::double precision,
        temp_calculated_error_max::double precision,
        temp_measured::double precision,
        hot_point_lon::double precision,
        geometric_albedo::double precision,
        geometric_albedo_error_min::double precision,
        geometric_albedo_error_max::double precision,
        log_g::double precision,
        publication::text,
        detection_type::text,
        mass_detection_type::text,
        radius_detection_type::text,
        alternate_names::text,
        molecules::text,
        star_name::text,
        ra::double precision AS right_ascension,
        dec::double precision AS declination,
        mag_v::double precision,
        mag_i::double precision,
        mag_j::double precision,
        mag_h::double precision,
        mag_k::double precision,
        star_distance::double precision,
        star_distance_error_min::double precision,
        star_distance_error_max::double precision,
        star_metallicity::double precision,
        star_metallicity_error_min::double precision,
        star_metallicity_error_max::double precision,
        star_mass::double precision,
        star_mass_error_min::double precision,
        star_mass_error_max::double precision,
        star_radius::double precision,
        star_radius_error_min::double precision,
        star_radius_error_max::double precision,
        star_sp_type::text,
        star_age::double precision,
        star_age_error_min::double precision,
        star_age_error_max::double precision,
        star_teff::double precision,
        star_teff_error_min::double precision,
        star_teff_error_max::double precision,
        star_detected_disc::text,
        star_magnetic_field::text,
        star_alternate_names::text
	FROM 
		exoplanet_stage.exoplanets
	WHERE
		updated::DATE = (
			SELECT MAX(updated::DATE)
			FROM exoplanet_stage.exoplanets
		)
)
ON CONFLICT DO NOTHING;

END;
$BODY$;