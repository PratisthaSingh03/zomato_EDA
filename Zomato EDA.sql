--                                   ------ Selecting database -----                                --
USE zomato_eda;
SELECT * 
FROM `zomato data`;
#                                     -----STAGING OF THE TABLE -----

CREATE TABLE zomato_data_staging
LIKE `zomato data`;
SELECT * FROM zomato_data_staging;

INSERT zomato_data_staging
SELECT * FROM `zomato data`;

#                     -----REMOVING DUPLICATES -----
SELECT *, ROW_NUMBER() OVER(PARTITION BY `name`, online_order, book_table, rate,votes,
 `approx_cost(for two people)`, `listed_in(type)`) AS row_num
 FROM zomato_data_staging;
 
 WITH duplicate_CTE AS
 (
 SELECT *, ROW_NUMBER() OVER(PARTITION BY `name`, online_order, book_table, rate,votes,
 `approx_cost(for two people)`, `listed_in(type)`)
 FROM zomato_data_staging
 )
 SELECT * FROM duplicate_CTE 
 WHERE row_num > 1;
 
#                            ----------- STANDARDIZING -----------
 SELECT DISTINCT `name`
 FROM zomato_data_staging;
 SELECT * FROM zomato_data_staging;
 
#                           -----------NULL & BLANK VALUES ---------------
SELECT *
FROM zomato_data_staging 
WHERE votes IS NULL 
OR votes = ' ';

SELECT *
FROM zomato_data_staging 
WHERE rate IS NULL 
OR  rate = ' ';

SELECT *
FROM zomato_data_staging 
WHERE `approx_cost(for two people)` IS NULL 
OR votes = ' ';
 # no null or blank values 

#   --------- EXPLORATORY DATA ANALYSIS----------

SELECT * FROM zomato_data_staging;

SELECT MAX(`approx_cost(for two people)`)
FROM zomato_data_staging;

--  ANALYSING APPROXIMATE COST FOR TWO PEOPLE AT EACH RESTAURANT--
SELECT `name`, SUM(`approx_cost(for two people)`) AS approx_costForTwo
FROM zomato_data_staging
GROUP BY `name`
ORDER BY 1 ASC;

 -- BEST RESTAURANTS THAT HAVE ONLINE ORDER FACILITY ANALYSIS ON BASIS OF RATING---
SELECT `name`, rate 
FROM zomato_data_staging
WHERE online_order = 'Yes'
ORDER BY rate DESC;
 
 
 -- BUDGET FRIENDLY RESTAURANTS AND THEIR TYPE -- 
 SELECT *
FROM zomato_data_staging
WHERE online_order = 'Yes' AND `approx_cost(for two people)` <500
ORDER BY `approx_cost(for two people)` ASC;

-- BUDGET FRIENDLY BUFFET SYSTEM --
SELECT `name`, book_table, rate, `Listed_in(type)`, `approx_cost(for two people)`
FROM zomato_data_staging
WHERE `approx_cost(for two people)` <500 AND `Listed_in(type)` = 'Buffet';

--- END ---
