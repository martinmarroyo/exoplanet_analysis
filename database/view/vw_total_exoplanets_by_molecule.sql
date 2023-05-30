CREATE OR REPLACE VIEW exoplanet.vw_total_exoplanets_by_molecule AS
SELECT 
	UNNEST(STRING_TO_ARRAY(TRIM(molecules),', '))
	AS molecule
	,COUNT(planet_name) AS total_planets
FROM exoplanet.dim_planet
WHERE row_current AND molecules IS NOT NULL
GROUP BY UNNEST(STRING_TO_ARRAY(TRIM(molecules),', '))
ORDER BY total_planets DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_total_exoplanets_by_molecule
    IS 'Total planets by individual molecules identified.';