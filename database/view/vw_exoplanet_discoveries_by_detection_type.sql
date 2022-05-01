CREATE VIEW exoplanet.vw_exoplanet_discoveries_by_detection_type AS
SELECT detection_type,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND detection_type IS NOT NULL
GROUP BY detection_type
ORDER BY total_planets DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_exoplanet_discoveries_by_detection_type
    IS 'Exoplanet discoveries by detection type.';