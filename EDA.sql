-- EXPLORATORY DATA ANALYSIS --

SELECT * FROM layoffs_staging2;
SELECT max(total_laid_off), max(percentage_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

SELECT company,sum(total_laid_off) FROM layoffs_staging2
group by company order by 2 desc;

SELECT min(`date`),max(`date`) FROM layoffs_staging2;

SELECT industry,sum(total_laid_off) FROM layoffs_staging2
group by 1 order by 2 desc;

SELECT * FROM layoffs_staging2;

SELECT country,sum(total_laid_off) FROM layoffs_staging2
group by 1 order by 2 desc;

SELECT year(`date`),sum(total_laid_off) FROM layoffs_staging2
group by 1 order by 1 desc;

SELECT stage,sum(total_laid_off) FROM layoffs_staging2
group by 1 order by 2 desc;

SELECT company,avg(percentage_laid_off) FROM layoffs_staging2
group by 1 order by 2 desc;

SELECT *,
sum(total_laid_off) over(partition by industry order by total_laid_off desc)
FROM layoffs_staging2;
 
SELECT month(`date`),sum(total_laid_off)
FROM layoffs_staging2
group by month(`date`)
order by month(`date`);

with cte as(
SELECT YEAR(`date`) as `year`,month(`date`) as `month`,sum(total_laid_off) as total_laid_off
FROM layoffs_staging2
where YEAR(`date`) is not null and month(`date`) is not null
group by YEAR(`date`),month(`date`)
order by YEAR(`date`),month(`date`))
SELECT `year`,`month`,total_laid_off,sum(total_laid_off) over(order by `year`,`month`) as total FROM cte;


with laid_off_by_year as(
SELECT company,year(`date`) as `YEAR`,sum(total_laid_off) as laid_off
FROM layoffs_staging2
where year(`date`) is not NULL
group by 1,2 order by 1),
top_5_laid_off as(
SELECT *,dense_rank() over(partition by `YEAR` order by laid_off desc) as `Ranking` FROM laid_off_by_year
order by Ranking)
SELECT company,`YEAR`,laid_off,Ranking FROM top_5_laid_off where Ranking<=5 order by `YEAR`,Ranking;



