CREATE OR REPLACE VIEW exoplanet.vw_total_exoplanets_by_identified_molecules AS
SELECT molecules,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND molecules IS NOT NULL
GROUP BY molecules
ORDER BY total_planets DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_total_exoplanets_by_identified_molecules
    IS 'Total planets by group of molecules identified.';