CREATE VIEW exoplanet.vw_exoplanet_discovery_by_year AS
SELECT discovered,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND discovered<>9999
GROUP BY discovered
ORDER BY discovered;

-- Comments
COMMENT ON VIEW exoplanet.vw_exoplanet_discovery_by_year
    IS 'Exoplanet discoveries by year.';