-- Exploratory Data Analysis

-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!

SELECT *
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Which companies had 1 which is basically 100 percent of the company laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 AND country = 'India';

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY total_laid_off DESC;

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY laid_off DESC;

-- industries with the most Total Layoffs
SELECT industry, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY laid_off DESC;

-- Countries with the most Total Layoffs
SELECT country, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY laid_off DESC;

-- At what Stage were the most Total Layoffs
SELECT stage, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- looking the duration of Layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT `date`, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY `date`
ORDER BY `date` DESC;

SELECT YEAR(`date`) AS year, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY year
HAVING year IS NOT NULL
ORDER BY year;

SELECT SUBSTRING(`date`,6,2) Month, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY Month
HAVING Month IS NOT NULL
ORDER BY Month;

SELECT SUBSTRING(`date`,1,7) Month, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY Month
HAVING Month IS NOT NULL
ORDER BY Month;

WITH Rolling_Total AS
(SELECT SUBSTRING(`date`,1,7) Month, SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY Month
HAVING Month IS NOT NULL
ORDER BY Month
)
SELECT * ,SUM(laid_off) OVER(ORDER BY Month) Rolling_laid_off
FROM Rolling_Total;


SELECT company, YEAR(`date`),SUM(total_laid_off) laid_off
FROM layoffs_staging2
GROUP BY 1,2
ORDER BY 3 DESC;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year.
WITH Company_Year(Company,Years,Laid_Off) AS
(SELECT company, YEAR(`date`),SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY 1,2
),
Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Laid_Off DESC) Ranking
FROM Company_Year
WHERE Years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

-- Same for Industry wise
WITH Industry_Year(Industry,Years,Laid_Off) AS
(SELECT industry, YEAR(`date`),SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY 1,2
),
Industry_Year_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Laid_Off DESC) Ranking
FROM Industry_Year
WHERE Years IS NOT NULL)
SELECT *
FROM Industry_Year_Rank
WHERE Ranking <= 5;