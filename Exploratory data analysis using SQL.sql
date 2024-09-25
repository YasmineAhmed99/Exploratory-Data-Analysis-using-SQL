
-- exploring the data to find trends or patterns.


SELECT * 
FROM layoffs;


-- get maximum total laid off

SELECT MAX(total_laid_off)
FROM layoffs



-- Looking at the maximum and minimum Percentage to see how big these layoffs were

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs
WHERE  percentage_laid_off IS NOT NULL;


-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT *
FROM layoffs
WHERE  percentage_laid_off = 1;


-- if we order by 'funds_raised_millions' we can see how big some of these companies were


SELECT *
FROM layoffs
WHERE  percentage_laid_off = 1
ORDER BY funds_raised DESC;


-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs
ORDER BY 2 DESC
LIMIT 5;


-- Companies with the highest total laysoffs

SELECT company, SUM(total_laid_off)
FROM layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- Location of the highest total laysoffs

SELECT location, SUM(total_laid_off)
FROM layoffs
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


-- Countries with the highest total laysoffs

SELECT country, SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 DESC;



-- Total layoffs of each year

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs
GROUP BY YEAR(date)
ORDER BY 1 ASC;



-- Industries with the highest total laysoffs


SELECT industry, SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 DESC;




-- Companies with the highest layoffs per year

WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
