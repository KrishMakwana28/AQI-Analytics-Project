create database AirQualityProject;
use AirQualityProject;
CREATE TABLE aqi_raw (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    City          VARCHAR(100),
    Date          VARCHAR(20),          -- Keep as string to preserve raw format
    PM2_5         VARCHAR(20),          -- Use VARCHAR to catch bad entries
    PM10          VARCHAR(20),
    NO            VARCHAR(20),
    NO2           VARCHAR(20),
    NOx           VARCHAR(20),
    NH3           VARCHAR(20),
    CO            VARCHAR(20),
    SO2           VARCHAR(20),
    O3            VARCHAR(20),
    Benzene       VARCHAR(20),
    Toluene       VARCHAR(20),
    Xylene        VARCHAR(20),
    AQI           VARCHAR(20),
    AQI_Bucket    VARCHAR(50)
);

select count(*) from aqi_raw;
select * from aqi_raw;
describe aqi_raw;

set sql_safe_updates=False;


update aqi_raw
set 
    PM2_5 = NULLIF(TRIM(PM2_5), ''),
    PM10  = NULLIF(TRIM(PM10), ''),
    NO    = NULLIF(TRIM(NO), ''),
    NO2   = NULLIF(TRIM(NO2), ''),
    NOx   = NULLIF(TRIM(NOx), ''),
    NH3   = NULLIF(TRIM(NH3), ''),
    CO    = NULLIF(TRIM(CO), ''),
    SO2   = NULLIF(TRIM(SO2), ''),
    O3    = NULLIF(TRIM(O3), ''),
    Benzene = NULLIF(TRIM(Benzene), ''),
    Toluene = NULLIF(TRIM(Toluene), ''),
    Xylene  = NULLIF(TRIM(Xylene), ''),
    AQI     = NULLIF(TRIM(AQI), ''),
    AQI_Bucket = NULLIF(TRIM(AQI_Bucket), '');
    
select * from aqi_raw;

alter table aqi_raw
modify Date date,
modify PM2_5   decimal(10,2),
modify PM10    decimal(10,2),
modify NO      decimal(10,2),
modify NO2     decimal(10,2),
modify NOx     decimal(10,2),
modify NH3     decimal(10,2),
modify CO      decimal(10,2),
modify SO2     decimal(10,2),
modify O3      decimal(10,2),
modify Benzene decimal(10,2),
modify Toluene decimal(10,2),
modify Xylene  decimal(10,2),
modify AQI     decimal(10,2);

describe aqi_raw;	
select * from aqi_raw;

# select * from aqi_raw where pm2_5 < 0 or aqi < 0;

# Check for duplicates:
select city,date,count(*) from aqi_raw group by city,date having count(*) >1;

# Check row count
SELECT COUNT(*) AS total_rows FROM aqi_raw;

# Check nulls per column
SELECT 
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS City_nulls,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Date_nulls,
    SUM(CASE WHEN PM2_5 IS NULL THEN 1 ELSE 0 END) AS pm25_nulls,
    SUM(CASE WHEN PM10 IS NULL THEN 1 ELSE 0 END) AS pm10_nulls,
    SUM(CASE WHEN AQI IS NULL THEN 1 ELSE 0 END) AS aqi_nulls,
    SUM(CASE WHEN NO IS NULL THEN 1 ELSE 0 END) AS no_nulls,
    SUM(CASE WHEN NO2 IS NULL THEN 1 ELSE 0 END) AS no2_nulls,
    SUM(CASE WHEN NOx IS NULL THEN 1 ELSE 0 END) AS nox_nulls,
    SUM(CASE WHEN NH3 IS NULL THEN 1 ELSE 0 END) AS nh3_nulls,
    SUM(CASE WHEN CO IS NULL THEN 1 ELSE 0 END) AS co_nulls,
    SUM(CASE WHEN SO2 IS NULL THEN 1 ELSE 0 END) AS so2_nulls,
    SUM(CASE WHEN O3 IS NULL THEN 1 ELSE 0 END) AS o3_nulls,
    SUM(CASE WHEN Benzene IS NULL THEN 1 ELSE 0 END) AS benzene_nulls,
    SUM(CASE WHEN Toluene IS NULL THEN 1 ELSE 0 END) AS toluene_nulls,
    SUM(CASE WHEN Xylene IS NULL THEN 1 ELSE 0 END) AS xylene_nulls,
    SUM(CASE WHEN AQI_Bucket IS NULL THEN 1 ELSE 0 END) AS bucket_nulls
FROM aqi_raw;

select * from aqi_cleaned;
SELECT 
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS City_nulls,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS Date_nulls,
    SUM(CASE WHEN PM2_5 IS NULL THEN 1 ELSE 0 END) AS pm25_nulls,
    SUM(CASE WHEN PM10 IS NULL THEN 1 ELSE 0 END) AS pm10_nulls,
    SUM(CASE WHEN AQI IS NULL THEN 1 ELSE 0 END) AS aqi_nulls,
    SUM(CASE WHEN NO IS NULL THEN 1 ELSE 0 END) AS no_nulls,
    SUM(CASE WHEN NO2 IS NULL THEN 1 ELSE 0 END) AS no2_nulls,
    SUM(CASE WHEN NOx IS NULL THEN 1 ELSE 0 END) AS nox_nulls,
    SUM(CASE WHEN NH3 IS NULL THEN 1 ELSE 0 END) AS nh3_nulls,
    SUM(CASE WHEN CO IS NULL THEN 1 ELSE 0 END) AS co_nulls,
    SUM(CASE WHEN SO2 IS NULL THEN 1 ELSE 0 END) AS so2_nulls,
    SUM(CASE WHEN O3 IS NULL THEN 1 ELSE 0 END) AS o3_nulls,
    SUM(CASE WHEN Benzene IS NULL THEN 1 ELSE 0 END) AS benzene_nulls,
    SUM(CASE WHEN Toluene IS NULL THEN 1 ELSE 0 END) AS toluene_nulls,
    SUM(CASE WHEN Xylene IS NULL THEN 1 ELSE 0 END) AS xylene_nulls,
    SUM(CASE WHEN AQI_Bucket IS NULL THEN 1 ELSE 0 END) AS bucket_nulls
FROM aqi_cleaned;


update aqi_cleaned set 
    PM_Ratio = ROUND(PM_Ratio, 4),
    NO2_NOx_Ratio = ROUND(NO2_NOx_Ratio, 4),
    CO_O3_Ratio = ROUND(CO_O3_Ratio, 4),
    SO2_NO2_Ratio = ROUND(SO2_NO2_Ratio, 4);
    

-- Problem Statement 5: Advanced SQL Analytics on Cleaned Data
-- Objective: Generate insights using SQL-only analysis.
-- Use cleaned tables to perform:
-- •	Joins:
-- o	Join AQI data with derived city/month tables


SELECT City,Year,Month,ROUND(AVG(AQI),2) AS Monthly_AQI FROM aqi_cleaned GROUP BY City, Year, Month;

-- •	Subqueries:
-- o	Identify cities with AQI above national average
SELECT City, ROUND(AVG(AQI),2) AS Avg_AQI
FROM aqi_cleaned
GROUP BY City
HAVING Avg_AQI > (
    SELECT AVG(AQI) FROM aqi_cleaned
);

-- •	Window Functions:
-- o	Rank cities by AQI within each year
SELECT 
    City,
    YEAR(Date) AS Year,
    ROUND(AVG(AQI),2) AS Avg_AQI,
    RANK() OVER (PARTITION BY YEAR(Date) ORDER BY AVG(AQI) DESC) AS Rank_in_Year
FROM aqi_cleaned
GROUP BY City, YEAR(Date);

-- o	Compute moving average AQI per city
SELECT City,AQI,
ROUND (AVG(AQI) OVER (PARTITION BY City ORDER BY Date ),2) as moving_avg
FROM aqi_cleaned;

-- •	DQL & DML:
-- o	Maintain summary tables

CREATE TABLE IF NOT EXISTS aqi_city_summary (
    City           VARCHAR(100) PRIMARY KEY,
    Avg_AQI        FLOAT,
    Max_AQI        FLOAT,
    Min_AQI        FLOAT,
    Dominant_Bucket VARCHAR(50),
    Total_Days     INT
);

INSERT INTO aqi_city_summary
SELECT
    City,
    ROUND(AVG(AQI), 2),
    MAX(AQI),
    MIN(AQI),
    -- Most frequent AQI bucket
    (SELECT AQI_Bucket
     FROM aqi_cleaned c2
     WHERE c2.City = c1.City AND AQI_Bucket IS NOT NULL
     GROUP BY AQI_Bucket ORDER BY COUNT(*) DESC LIMIT 1),
    COUNT(DISTINCT Date)
FROM aqi_cleaned c1
GROUP BY City;
    
    
    
select * from aqi_city_summary;