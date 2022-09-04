/*
Product Carbon Footprint Data Exploration 

Skills used: Creation of table, Aggregate Functions, Windows Functions, Creating Views
*/


USE Carbon_dt;
-- creation of a table to store our data 
CREATE TABLE product_level_data(ID  char(13),
				year int(4),
                                product_name varchar(872),
                                company_name varchar(44),
                                country varchar(14),
                                industry_group varchar(68),
                                company_sector varchar(36),
                                weight_kg numeric(18,2),
                                carbon_footprint_pcf numeric(11,4),
                                upstream_percent_total_pcf varchar(10),
                                operations_percent_total_pcf varchar(10),
                                downstream_percent_total_pcf varchar(10));
/* checking that the table is correctly created*/
SELECT * FROM product_level_data;

/* I inserted the data through the Table Data Import Wizard*/

 /* checking the trend of PCF by sector per year*/
 SELECT id, year, product_name, country, industry_group, carbon_footprint_pcf
 FROM product_level_data
 WHERE year='2013' 
 ORDER BY industry_group;

/* creating View to store data for later storage visualisations 
  Table with the total amount of pcf per industry sector and country of 2013*/
Create View pcf_2013 as 
SELECT product_name, country, year, industry_group, carbon_footprint_pcf
FROM  product_level_data
WHERE year='2013'
ORDER BY country, industry_group,  year; 


 /* creating View to store data for later storage visualisations 
  Table with the sum of pcf per industry sector and country of 2013*/
Create View sum_pcf_industry_country_2013 as 
SELECT industry_group, country, SUM(carbon_footprint_pcf) AS total_PCF_year
FROM pcf_2013
GROUP BY industry_group, country
ORDER BY industry_group;

/* Industry sector with the highest emissions in 2013*/
SELECT industry_group, ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint
FROM product_level_data
GROUP BY industry_group, year
HAVING year = 2013
ORDER BY total_industry_footprint DESC;

/* max upstream pcf per industry_group and year */
Create View max_upstream_pcf as 
SELECT product_name, country, year, industry_group,
	MAX(upstream_percent_total_pcf*100) OVER (PARTITION BY year,industry_group, country) AS upstream_percentage_PCF
FROM  product_level_data
GROUP BY product_name, country, year, upstream_percent_total_pcf,industry_group
HAVING MAX(upstream_percent_total_pcf*100)>=50;  

/* max operations_percent_total_pcf per industry_group and year*/
Create View max_operations_pcf as 
SELECT product_name, country, year, industry_group,
	MAX(operations_percent_total_pcf*100) OVER (PARTITION BY year,industry_group, country) AS operation_percentage_PCF
FROM  product_level_data
GROUP BY  year, industry_group,  country, operations_percent_total_pcf, product_name
HAVING MAX(operations_percent_total_pcf*100)>=50; 

/* max downstream pcf per industry_group and year */
Create View max_downstream_pcf as 
SELECT product_name, country, year, industry_group,
	MAX(downstream_percent_total_pcf*100) OVER (PARTITION BY year,industry_group, country) AS downstream_percentage_PCF
FROM  product_level_data
GROUP BY  year, industry_group, downstream_percent_total_pcf, product_name, country
HAVING MAX(downstream_percent_total_pcf*100)>=50;  
                               
/* All the views were exported into excel to be used in Tableau */






                                
