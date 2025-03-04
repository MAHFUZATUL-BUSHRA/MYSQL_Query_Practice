SELECT * FROM world.country;

SELECT * FROM world.city;

USE WORLD;

SELECT 
    CITY.*, COUNTRY.NAME, COUNTRY.CONTINENT, COUNTRY.REGION
FROM
    CITY
        INNER JOIN
    COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE;


SELECT 
	CONTINENT,
	ROUND(SUM(SURFACEAREA),0) AS TOTAL_SURFACE_AREA_OF_CONTINENT
FROM COUNTRY
GROUP BY CONTINENT
ORDER BY ROUND(SUM(SURFACEAREA),0) DESC
LIMIT 1;

SELECT 
    CONTINENT, 
    ROUND(SUM(SURFACEAREA),0) AS TOTAL_SURFACE_AREA_OF_CONTINENT
FROM
    COUNTRY
GROUP BY CONTINENT
ORDER BY 2 DESC
LIMIT 1;

-- USE SAKILA;

SELECT 
	TITLE AS "MOVIE TITLE", 
    RELEASE_YEAR AS "MOVIE RELEASE YEAR", 
    LENGTH, 
    RATING
FROM SAKILA.FILM;

SELECT 
	COUNT(*)
FROM SAKILA.FILM; -- 1000 Movies

USE WORLD;

SELECT
 COUNT(NAME) AS COUNT_OF_COUNTRY,
 COUNT(distinct NAME) AS UNIQUE_COUNT_OF_COUNTRY, -- 239
 COUNT(distinct CONTINENT) AS UNIQUE_COUNT_OF_CONTINENT, -- 7
 COUNT(distinct REGION) AS UNIQUE_COUNT_OF_REGION -- 25
FROM COUNTRY;

SELECT 
*
FROM COUNTRY
WHERE NAME = "Egypt";


SELECT 
*
FROM COUNTRY
WHERE NAME LIKE "EGYPT";


SELECT 
*
FROM COUNTRY
WHERE CONTINENT LIKE "AFRICA";





