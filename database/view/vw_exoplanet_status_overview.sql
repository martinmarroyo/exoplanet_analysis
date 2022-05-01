CREATE VIEW exoplanet.vw_exoplanet_status_overview AS
SELECT planet_status,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND planet_status IS NOT NULL
GROUP BY planet_status
ORDER BY total_planets DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_exoplanet_status_overview
    IS 'A summary view of exoplanet counts by planet status.';