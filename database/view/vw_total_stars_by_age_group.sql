CREATE OR REPLACE VIEW exoplanet.vw_total_stars_by_age_group AS
WITH star_age AS (
	SELECT ROUND(star_age) AS star_age_est,count(star_age)
	FROM exoplanet.dim_star
	WHERE row_current AND COALESCE(star_age,9999)<>9999
	GROUP BY ROUND(star_age)
)
SELECT star_age_years,SUM(total_stars) AS total_stars
FROM (
	SELECT
		CASE 
			WHEN star_age_est=0
			THEN 'Less than 1 Billion'
			WHEN star_age_est BETWEEN 1 AND 5
			THEN 'Between 1 & 5 Billion'
			WHEN star_age_est BETWEEN 6 AND 10
			THEN 'Between 6 & 10 Billion'
			ELSE 'More than 10 Billion'
		END AS star_age_years
		,count AS total_stars
	FROM star_age
) star_age
GROUP BY star_age_years
ORDER BY total_stars DESC;

-- Comments
COMMENT ON VIEW exoplanet.vw_total_stars_by_age_group
    IS 'Total number of stars by age group. Ages are measured in billions of years. Groups are: Less than 1 Billion, Between 1 and 5 Billion, Between 6 and 10 Billion, and More than 10 Billion years, respectively.';

