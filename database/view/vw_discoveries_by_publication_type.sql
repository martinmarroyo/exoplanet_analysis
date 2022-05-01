CREATE VIEW exoplanet.vw_discoveries_by_publication_type AS
SELECT publication,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND publication IS NOT NULL
GROUP BY publication
ORDER BY total_planets DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_discoveries_by_publication_type
    IS 'Exoplanet discoveries by publication type.';