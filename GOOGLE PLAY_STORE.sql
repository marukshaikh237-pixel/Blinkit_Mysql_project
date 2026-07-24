CREATE DATABASE GOOGLE_PLAYSTORE;
USE GOOGLE_PLAYSTORE;

SELECT * FROM PLAYSTORE;

-- Display all apps with a rating greater than 4.5. 
SELECT APP FROM PLAYSTORE
WHERE RATING > 4.5;

-- Find all paid apps.
SELECT app FROM PlaYSTORE
WHERE TYPE = 'Free';

-- Count the total number of apps.
SELECT COUNT(APP) AS TOTAL_APP
FROM PLAYSTORE;

-- Count the number of apps in each category.
SELECT CATEGORY,COUNT(APP) AS NO_APP
FROM PLAYSTORE
GROUP BY CATEGORY;

-- Count the number of apps in each category.
SELECT AVG(RATING)AS AVG_RATING
FROM PLAYSTORE;

-- Display the top 10 most reviewed apps. 
SELECT APP,REVIEWS
FROM PLAYSTORE
ORDER BY REVIEWS DESC
LIMIT 10;

-- Find apps whose installs are greater than 1,000,000 
SELECT * FROM PLAYSTORE
WHERE INSTALLS > 10000;

-- Find apps updated in 2018.
SELECT App, Category, `Last_Updated`
FROM playstore
WHERE YEAR(STR_TO_DATE(`Last_Updated`, '%e-%b-%y')) = 2018;

-- List all unique content ratings.
SELECT distinct(CONTENT_RATING)
FROM PLAYSTORE;

-- Find the highest-rated app
SELECT RATING ,APP
FROM PLAYSTORE
ORDER BY RATING DESC
LIMIT 1;
-- Find the average rating for each category
SELECT ROUND(avg(RATING)) AS AVG_RATING,CATEGORY
FROM PLAYSTORE
GROUP BY CATEGORY;

-- Which category has the highest average rating?
SELECT CATEGORY,AVG(RATING) AS AVG_RATING 
FROM PLAYSTORE
group by CATEGORY
ORDER BY AVG_RATING DESC
LIMIT 1;

-- Display the top 5 categories by total installs
SELECT CATEGORY,SUM(INSTALLS) AS TOTAL_INSTALLS
FROM PLAYSTORE
GROUP BY CATEGORY
ORDER BY TOTAL_INSTALLS DESC
LIMIT 5;

-- Count how many apps belong to each content rating

SELECT CONTENT_RATING,count(APP) AS TOTAL_APP
FROM PLAYSTORE
GROUP BY CONTENT_RATING;

-- Find apps with above-average ratings.
SELECT APP,RATING,
(SELECT ROUND(AVG(RATING),2) FROM PLAYSTORE) AS OVER_ALL_RATING
FROM PLAYSTORE
WHERE RATING > (SELECT AVG(RATING) FROM PLAYSTORE)
ORDER BY RATING DESC;

-- Find the percentage of Free vs Paid apps.
WITH total_apps AS (
    SELECT COUNT(*) AS total
    FROM playstore
)
SELECT
    Type,
    COUNT(*) AS Total_Apps,
    ROUND(COUNT(*) * 100.0 / total_apps.total, 2) AS Percentage
FROM playstore
CROSS JOIN total_apps
GROUP BY Type, total_apps.total;

-- Which category gives the highest average rating while also having more than 100 apps?
SELECT CATEGORY,COUNT(*) AS TOTAL_APPS,
round(AVG(RATING),2) AS AVG_RATING
FROM PLAYSTORE
GROUP BY CATEGORY
HAVING COUNT(*) > 100
ORDER BY AVG_RATING DESC
;

-- Which content rating has the highest average installs?
SELECT CONTENT_RATING,AVG(INSTALLS) AS AVG_INSTALLS 
FROM PLAYSTORE
GROUP BY CONTENT_RATING
ORDER BY AVG_INSTALLS DESC
LIMIT 1;


SELECT
    Category,
    COUNT(*) AS Total_Apps,
    SUM(Reviews) AS Total_Reviews,
    ROUND(AVG(Rating), 2) AS Avg_Rating,
    SUM(Installs) AS Total_Installs,
RANK() OVER (ORDER BY
    SUM(REVIEWS) DESC,
    Avg(Rating) DESC,
    SUM(Installs) DESC) AS LEADERBOARD_RANK
FROM PLAYSTORE
GROUP BY CATEGORY;
