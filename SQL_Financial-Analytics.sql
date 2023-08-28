use sql_project;
select * from company_detail;
select * from promoter_detail;
select * from revenue_detail;

-- TASK 1


-- company_detail:


alter table company_detail
rename column `Market Cap` to `market_cap`,
rename column `Sub-Sector` to `sub_sector`,
rename column `ï»¿Name` to `name`,
rename column `Ticker` to `ticker`,
rename column `Close Price` to `close_price`,
rename column `PE Ratio` to `pe_ratio`;

-- market_cap:
update company_detail
set market_cap = 0
where market_cap is null;

-- close_price:
update company_detail
set close_price = 0
where close_price is null;


-- promotor_detail


select * from promotor_detail;

alter table promotor_detail
rename column `DII Holding ChangeÃ‚Â Ã¢â‚¬â€œÃ‚Â 3M` to `dii_change`,
rename column `ï»¿Ticker` to `ticker`,
rename column `FII Holding ChangeÃ‚Â Ã¢â‚¬â€œÃ‚Â 3M` to `fii_change`,
rename column `MF Holding ChangeÃ‚Â Ã¢â‚¬â€œÃ‚Â 3M` to `mf_holing`,
rename column `Promoter Holding ChangeÃ‚Â Ã¢â‚¬â€œÃ‚Â 3M` to `promoter_change`,
rename column `Percentage Buy RecoÃ¢â‚¬â„¢s` to `percentage_buy`
rename column `No. of analysts with buy reco` to `analyst_buy`,
rename column `Percentage Upside` to `percentage_upside`;

alter table promotor_detail
rename column `mf_holing` to `mf_change`;

-- ticker
select count(*) from promotor_detail where ticker is null;

-- dii_change:
update promotor_detail
set dii_change = 0
where dii_change is null;

-- fii_change
update promotor_detail
set fii_change = 0
where fii_change is null;

-- mf_change
update promotor_detail
set mf_change = 0
where mf_change is null;

-- promoter_change
update promotor_detail
set promoter_change = 0
where promoter_change is null;

-- analyst_buy
update promotor_detail
set analyst_buy = 0
where analyst_buy is null;

-- percentage_upside
update promotor_detail
set percentage_upside = 0
where percentage_upside is null;

-- percentage_buy
update promotor_detail
set percentage_buy = 0
where percentage_buy is null;

-- revenue_detail

select * from revenue_detail;

alter table revenue_detail
rename column `ï»¿Ticker` to `ticker`,
rename column `5Y Historical Revenue Growth` to `5_yr_change`,
rename column `1Y Forward Revenue Growth` to `1_yr_change`,
rename column `Total Revenue` to `total_revenue`,
rename column `PBT` to `pbt`,
rename column `Taxes & Other Items` to `taxes_and_other`;

-- 5_yr_change
update revenue_detail
set 5_yr_change = 0
where 5_yr_change is null;

-- 1_yr_change
update revenue_detail
set 1_yr_change = 0
where 1_yr_change is null;

-- total_revenue
update revenue_detail
set total_revenue = 0
where total_revenue is null;

-- pbt
with my_cte1 as(
select count(*) as null_count from revenue_detail where pbt is null),
my_cte2 as(
select count(*) as total_count from revenue_detail)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;
-- No nulls in pbt

-- taxes_and_other
with my_cte1 as(
select count(*) as null_count from revenue_detail where taxes_and_other is null),
my_cte2 as(
select count(*) as total_count from revenue_detail)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;
-- No nulls in taxes_and_other

-- TASK 2 (BASIC QUERIES)

-- Q1: Calculate the average PE ratio and market cap for all companies
select avg(pe_ratio) from company_detail;
select avg(market_cap) from company_detail;

-- Q2: Find the top 5 companies with the highest market Cap.
select max(market_cap), name from company_detail
group by name order by 1 desc limit 5;

-- Q3: Identify companies with a PE ratio greater than 20 and a percentage upside above 15%.
select cd.name, cd.pe_ratio, pd.percentage_upside
from company_detail cd join promotor_detail pd
on cd.ticker = pd.ticker
where cd.pe_ratio > 20 and pd.percentage_upside > 15;
-- Joined tables company_detail and promotor_detail to find companies with pe_ratio over 20 and percentage_upside over 15.

-- Q4: Fetches the unique values of the Sub-Sector from the Company detail table and prints its length. 
select distinct(sub_sector), length(sub_sector) from company_detail;

-- Q5: Create a new column name Retail holding change by adding all the holding columns in the table.
select * from promotor_detail;
with my_cte1 as(
select dii_change + fii_change + mf_change + promoter_change as retail_holding_change from promotor_detail)
select round(retail_holding_change,2) from my_cte1;

alter table promotor_detail add retail_holding decimal(5,2);
update promotor_detail set retail_holding = `dii_change` + `fii_change` + `promoter_change` + `mf_change`;
alter table promotor_detail rename column retail_holding to retail_holding_change;
-- Used common table expression along with 'with' clause to calculate retail_holding-change and saved as a new column.


-- TASK 2 (JOINS)
-- Q1: Retrieve the names, Market Cap, and sub-sectors of companies along with their DII holding change in the last 3 months.
select * from promotor_detail;
select cd.name,
cd.market_cap,
cd.sub_sector,
pd.dii_change
from company_detail cd
join promotor_detail pd on cd.ticker = pd.ticker;


-- Q2: List companies and their corresponding sub-sectors where FII holding change is greater than MF holding change.
select cd.name, cd.sub_sector, pd.fii_change, pd.mf_change
from company_detail cd join promotor_detail pd
on cd.ticker = pd.ticker 
where pd.fii_change > pd.mf_change;
-- Joined company_detail and promoter_detail used where clause to filter columns where fii_change > mf_change

-- Q3: Combine all 3 tables into 1 table with these columns:
-- (contd) (company name, Sub-sector, Market price, PE ratio, Total Revenue, Percentage upside, promotor holding) 
-- (contd) and the name of the merge table is Stock market.
create table Stock(
company_name varchar(70),
sub_sector varchar(70),
market_price decimal(20,2),
pe_ratio decimal(50,2),
total_revenue decimal(50,2),
percentage_upside decimal(50,2),
promotor_holding decimal(50,2));

insert into Stock
select cd.name, cd.sub_sector, cd.close_price, cd.pe_ratio, rd.total_revenue, pd.percentage_upside, pd.promoter_change
from company_detail cd inner join revenue_detail rd
on cd.ticker = rd.ticker
inner join promotor_detail pd
on cd.ticker = pd.ticker;

select * from Stock;
-- Created a new table Stock with specified data types. Joined cd, rd, pd, and insert the joined tables into Stock.


-- TASK 3 (ADVANCED QUERIES WITH WINDOW FUNCTIONS)


-- Q1: Determine the percentage of companies with 1-year forward revenue growth above 10% and a PE ratio below 15.
with my_cte1 as(
select count(name) as pe_below_15 from company_detail where pe_ratio < 15),
my_cte2 as(
select count(ticker) as yr1_above_10 from revenue_detail where 1_yr_change > 10),
my_cte3 as(
select count(*) as total_count from company_detail)
select (my_cte1.pe_below_15 + my_cte2.yr1_above_10) / my_cte3.total_count * 100 as result
from my_cte1, my_cte2, my_cte3;
-- Created common table expressions (CTEs) to calculate companies with pe < 15 and 1_yr_change > 10. Then calculated their sum of percentage to total number of companies.

-- Q2: Calculate the average taxes and other items as a percentage of total revenue for each sub-sector.
select * from revenue_detail;
with my_cte1 as(
select cd.sub_sector, round(sum(rd.total_revenue),2) as total_revenue, round(avg(rd.taxes_and_other),2) as avg_taxes
from company_detail cd join revenue_detail rd 
on cd.ticker = rd.ticker group by cd.sub_sector)
select my_cte1.sub_sector, my_cte1.total_revenue, my_cte1.avg_taxes, round(((my_cte1.avg_taxes / my_cte1.total_revenue ) * 100), 2) as avg_tax_pact_revenue
from my_cte1;
-- my_cte1 brings sub_sector, total_revenue, taxes_and_others together where result is grouped by sub_sector, total revenue, and average taxes of each sub sector.
-- Final select statement calculates average taxes as percentage of total revenue of each sub sector.

-- Q3: Find the companies with the highest percentage of buy recommendations and their respective sub-sectors.
select * from promotor_detail;
select cd.name, max(pd.analyst_buy) over (partition by cd.sub_sector) as highest_recommendation
from company_detail cd join promotor_detail pd on cd.ticker = pd.ticker 
order by highest_recommendation desc;
-- Partition is used in window function to show results (max buy reco) by creating partitions (company name). 

-- Q4: Calculate the top 5 sub-sectors with the highest profit margin by computing the profit margin using the formula:
-- (contd) ((Profit Before Taxes - Taxes - Other Items) / Total Revenue) * 100, derived from the company detail table."
select * from revenue_detail;
select cd.sub_sector, max((pbt - taxes_and_other) / total_revenue *100) as profit_margin
from company_detail cd join revenue_detail rd
on cd.ticker = rd.ticker
group by cd.sub_sector order by profit_margin desc limit 5;

-- Q5: Write a query to display the company name, sub-sector, market cap, and the market cap column with a modified title large-cap 
-- (contd) for those whose market cap is greater than 50000 Cr., mid-cap for those whose market cap is between 20000 and 50000 Cr, and small-cap for whose market cap Is less than 20000 Cr.
alter table company_detail add column cap_type varchar(50);
update company_detail
set cap_type = 
case when market_cap < 5000 then 'small cap'
when market_cap > 50000 and market_cap < 20000 then 'mid cap'
else 'large cap'
end;
select * from company_detail;

-- Q6: Rank companies based on their 1-year forward revenue growth within each sub-sector.
select * from revenue_detail;
with my_cte1 as(
select cd.name, cd.sub_sector, rd.1_yr_change
from company_detail cd join revenue_detail rd
on cd.ticker = rd.ticker)
select name, sub_sector,
rank() over(partition by sub_sector order by 1_yr_change desc) as rank_in_subsector
from my_cte1;
-- my_cte1 joins both the tables on ticker and my_cte 2 finds rank of company within their sub_sectors based on 1 yr growth.

-- Q7: Calculate the average market cap for the top 3 companies with the highest close prices in each sub-sector.
with my_cte1 as(
select name, sub_sector, close_price, market_cap,
row_number() over(partition by sub_sector order by close_price desc) as row_num from company_detail),
my_cte2 as(select * from my_cte1 where row_num <= 3)
select name, sub_sector, close_price, avg(market_cap) as avg_market_cap, row_num from my_cte2 group by sub_sector, name, close_price;
-- my_cte1 issues row number to companies within each sub_sector on basis of close price. my_cte2 shows the top 3 companies of my_cte1. 
-- (contd) select statement shows average market cap of each company.

-- Q8: Find the percentage difference in total revenue between each company and the average total revenue of its sub-sector.
With my_cte1 as(select cd.name,rd.total_revenue/(select sum(total_revenue) from revenue_detail)*100 as pct_total_revenue
from company_detail cd
join revenue_detail rd
on rd.Ticker=cd.ticker 
order by 2 desc)
select * from my_cte1;
with my_cte2 as (select cd.sub_sector,avg(rd.total_revenue) as sub_sector_revenue
from company_detail cd
join revenue_detail rd
on rd.Ticker=cd.ticker 
group by 1
order by 2 desc)
select * from my_cte2;