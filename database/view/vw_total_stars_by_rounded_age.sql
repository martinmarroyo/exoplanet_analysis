CREATE VIEW exoplanet.vw_total_stars_by_rounded_age AS
SELECT ROUND(star_age) AS star_age_est,count(star_age) AS total_stars
FROM exoplanet.dim_star
WHERE row_current AND COALESCE(star_age,9999)<>9999
GROUP BY ROUND(star_age)
ORDER BY star_age_est;

-- Comments
COMMENT ON VIEW exoplanet.vw_total_stars_by_rounded_age
    IS 'Total stars grouped by rounded age (in billions of years).';