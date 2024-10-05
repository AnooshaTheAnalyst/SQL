SELECT * FROM SQL_BASIC.layoffs;

/* STEPS:
1- Remove duplicates
2- Standardization of data
3- Remove NULLs or BLANK
4- Remove unnecessary rows and columns
*/

-- REMOVE DUPLICATES --

DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging
AS
SELECT *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`
,stage,funds_raised_millions)
 as row_num FROM layoffs;

SELECT * FROM layoffs_staging;

DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE layoffs_staging2 like layoffs_staging;
SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * FROM layoffs_staging
WHERE row_num=1;

-- STANDARDIZATION OF DATA --

SELECT distinct country FROM layoffs_staging2 order by country;
SELECT * FROM layoffs_staging2 WHERE industry like "%crypto%";

UPDATE layoffs_staging2
SET company=TRIM(company);

UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry='CryptoCurrency';

UPDATE layoffs_staging2
SET country='United States'
WHERE country='United States.';

UPDATE layoffs_staging2
SET `date`=str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2 where industry is NULL or industry='';
SELECT * FROM layoffs_staging where company="Bally's Interactive";

UPDATE layoffs_staging2 
SET industry=TRIM(industry);

-- REMOVE NULLs OR BLANKS --

UPDATE layoffs_staging2
SET industry=NULL
where industry='' or industry=' ' ;

UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company and t1.location=t2.location
set t2.industry=t1.industry 
where (t2.industry is null or t2.industry='')
and t1.industry is not null;

SELECT * FROM layoffs_staging2;


-- REMOVE ANY ROWS/COLUMNS -- 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


DELETE FROM layoffs_staging2
where total_laid_off is NULL and percentage_laid_off is NULL;



