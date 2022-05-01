CREATE TABLE IF NOT EXISTS exoplanet.dim_day
(
    date_key SERIAL,
    date date,
    day_of_month integer,
    month_num integer,
    quarter integer,
    year integer,
    month text COLLATE pg_catalog."default",
    day_of_week text COLLATE pg_catalog."default",
    day_of_year integer,
    week_of_year integer,
    month_start_day text COLLATE pg_catalog."default",
    month_end_day text COLLATE pg_catalog."default",
    last_day_of_month integer,
    total_days_in_year integer,
    CONSTRAINT dim_day_pkey PRIMARY KEY (date_key)
);

-- Insert initial null row
INSERT INTO exoplanet.dim_day(
	date, day_of_month, month_num, quarter, 
    year, month, day_of_week, day_of_year, 
    week_of_year, month_start_day, month_end_day, 
	last_day_of_month, total_days_in_year
)
VALUES ('1000-12-31', NULL, NULL, NULL, NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, NULL, NULL
);

-- Insert dim_day
INSERT INTO exoplanet.dim_day(
	date, day_of_month, month_num, 
	year, month, day_of_week, day_of_year, week_of_year, 
	month_start_day, month_end_day, last_day_of_month, 
	total_days_in_year)
WITH dim_day AS (
SELECT
	ROW_NUMBER() OVER
	(ORDER BY
		series.day)
	AS date_key
	,series.day::DATE
	AS date
	,EXTRACT(DAY FROM series.day::DATE)
	AS day_of_month
	,EXTRACT(MONTH FROM series.day::DATE)
	AS month_num
	,EXTRACT(YEAR FROM series.day::DATE)
	AS year
	,TO_CHAR(series.day::DATE,'Month')
	AS month
	,TO_CHAR(series.day::DATE,'Day')
	AS day_of_week
	,EXTRACT(DOY FROM series.day::DATE)
	AS day_of_year
	,EXTRACT(WEEK FROM series.day::DATE)
	AS week_of_year
FROM
	GENERATE_SERIES
		('1900-01-01'::DATE
		,'2050-01-01'::DATE,'1 Day')
	AS series(day)
)
SELECT
	date
	,day_of_month
	,month_num
	,year
	,month
	,day_of_week
	,day_of_year
	,week_of_year
	,TO_CHAR((MAKE_DATE(year::INT,month_num::INT,1))::DATE
			,'Day')
	AS month_start_day
	,TO_CHAR((MAKE_DATE(year::INT,month_num::INT,1)
			  + '1 Month'::INTERVAL 
			  - '1 Day'::INTERVAL)::DATE
			,'Day')
	AS month_end_day
    ,EXTRACT(DAY FROM 
			 (MAKE_DATE(year::INT,month_num::INT,1)
			  + '1 Month'::INTERVAL 
			  - '1 Day'::INTERVAL)::DATE)
	AS last_day_of_month
    ,EXTRACT(DOY FROM MAKE_DATE(year::INT,12,31))
    AS total_days_in_year
FROM
	dim_day
ORDER BY
	date_key;