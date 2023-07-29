use gm100;
select * from stock_market;

-- Rename Columns:
alter table stock_market
rename column `ticker` to `ticker`,
rename column `sub-sector` to `sub_sector`,
rename column `market cap` to `market_cap`,
rename column `close price` to `close_price`,
rename column `pe ratio` to `pe_ratio`,
rename column `5y historical revenue growth` to `5_yr_growth`,
rename column `1y forward revenue growth` to `1_yr_growth`,
rename column `total revenue` to `total_revenue`,
rename column `pbt` to `pbt`,
rename column `taxes & other items` to `taxes_and_other`,
rename column `dii holding change` to `dii_change`,
rename column `mf holding change` to `mf_change`,
rename column `promoter holding change` to `promoter_change`,
rename column `percentage buy record` to `percentage_buy`,
rename column `no. of analysts with buy reco` to `analyst_buy`,
rename column `percentage upside` to `percentage_upside`;
-- Note: Because of special characters like hyphens, SQL cannot interpret column names. To tackle this, use backticks (`) or double quotes(").

-- Fistly lets see our data:
describe stock_market;

-- > As the sub_sector assigned to me is 'IT Services & Consulting', I'll first convert null values of IT to averages of IT in order to avoid poor data quality since 
-- (contd from above) replacing IT nulls by avg of entire dataset won't give accurate results during analysis.

-- Change NULL values to Avg:

-- close_price:
select avg(close_price) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set close_price = (
case when close_price is NULL then 304.55
else close_price
end
) where sub_sector like 'IT Services & Consulting';

-- Market Cap: 2431.02
select avg(market_cap) from stock_market where sub_sector like "IT Services & Consulting";

update stock_market 
set market_cap = (
case when market_cap is NULL then 2431.02
else market_cap
end )
where sub_sector like 'IT Services & Consulting';

-- pe_ratio:
select avg(pe_ratio) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set pe_ratio = (
case when pe_ratio is NULL then 95.37
else pe_ratio
end ) where sub_sector like 'IT Services & Consulting';

select * from stock_market;

-- 5_yr_growth:
select avg(5_yr_growth) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set 5_yr_growth = (
case when 5_yr_growth is NULL then 8.66
else 5_yr_growth
end ) where sub_sector like 'IT Services & Consulting';

-- 1_yr_growth:
select avg(1_yr_growth) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set 1_yr_growth = (
case when 1_yr_growth is NULL then 19.28
else 1_yr_growth
end ) where sub_sector like 'IT Services & Consulting';

-- total_revenue:
select avg(total_revenue) from stock_market  where sub_sector like 'IT Services & Consulting';
update stock_market
set total_revenue = (
case when total_revenue is NULL then 5191.92
else total_revenue 
end ) where  sub_sector like 'IT Services & Consulting';

-- pbt:
select avg(pbt) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set pbt = (
case when pbt is NULL then 1112
else pbt
end ) where sub_sector like 'IT Services & Consulting';

-- taxes_and_other:
select avg(taxes_and_other) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set taxes_and_other = (
case when taxes_and_other is NULL then 274.52
else taxes_and_other
end ) where sub_sector like 'IT Services & Consulting';

-- dii_change:
select avg(dii_change) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set dii_change = (
case when dii_change is NULL then 0.10
else dii_change
end ) where sub_sector like 'IT Services & Consulting';

-- fii_change:
alter table stock_market rename column `FII Holding Change` to `fii_change`;
select avg(fii_change) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market 
set fii_change = (
case when fii_change is NULL then -0.01
else fii_change
end ) where sub_sector like 'IT Services & Consulting';

select * from stock_market;

-- mf_change:
select avg(mf_change) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set mf_change = (
case when mf_change is null then -0.03
else mf_change
end ) where sub_sector like 'IT Services & Consulting';

-- promoter_change:
select avg(promoter_change) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set promoter_change = (
case when promoter_change is null then -0.48
else promoter_change
end ) where sub_sector like 'IT Services & Consulting';

-- percentage_buy:
select avg(percentage_buy) from stock_market where sub_sector like 'IT Services & Consulting';
update stock_market
set percentage_buy = (
case when percentage_buy is null then 69.60
else percentage_buy
end ) where sub_sector like 'it services & consulting';

-- analyst_buy:
select avg(analyst_buy) from stock_market where sub_sector like 'it services & consulting';
update stock_market
set analyst_buy = (
case when analyst_buy is null then 1.61
else analyst_buy
end ) where sub_sector like 'it services & consulting';

-- percentage_upside:
select avg(percentage_upside) from stock_market where sub_sector like 'it services & consulting';
update stock_market
set percentage_upside = (
case when percentage_upside is null then 13.68
else percentage_upside
end ) where sub_sector like 'it services & consulting';

select * from stock_market where sub_sector like 'it services & consulting';

-- Exported CSV doesn't export rows where sub_sector has a comma (,). So we will update those as well:
update stock_market
set sub_sector = 'Precious Metals and Jewellery'
where sub_sector = 'Precious Metals, Jewellery & Watches';

update stock_market
set sub_sector = 'Hotels and Cruise'
where sub_sector = 'Hotels, Resorts & Cruise Lines';

-- Let's clean other sub_sector names as well to improve data quality - 
select distinct(sub_sector) from stock_market;

update stock_market
set sub_sector = 'FMCG'
where sub_sector in ('FMCG - Household Products', 'FMCG - Tobacco', 'FMCG - Foods', 'FMCG - Personal Products');

update stock_market
set sub_sector = 'FMCG'
where sub_sector = 'FMCG - Household Products';

update stock_market
set sub_sector = 'Oil & Gas'
where sub_sector = 'Oil & Gas - Refining & Marketing';

update stock_market
set sub_sector = 'Oil & Gas'
where sub_sector in ('Oil & Gas - Exploration & Production', 'Oil & Gas - Storage & Transportation', 'Oil & Gas - Equipment & Services');

update stock_market
set sub_sector = 'Building Products' 
where sub_sector in ('Building Products - Pipes', 'Building Products - Ceramics', 'Building Products - Laminates', 'Building Products - Granite', 'Building Products - Prefab Structures', 'Building Products - Glass');

update stock_market
set sub_sector = 'Mining'
where sub_sector in ('Mining - Coal', 'Mining - Diversified', 'Mining - Iron Ore', 'Mining - Copper', 'Mining - Manganese');

update stock_market
set sub_sector = 'Retail'
where sub_sector in ('Retail - Department Stores', 'Retail - Apparel', 'Retail - Speciality', 'Retail - Online');

update stock_market
set sub_sector = 'Metals'
where sub_sector in ('Metals - Diversified',
'Metals - Aluminium',
'Metals - Lead',
'Metals - Coke',
'Metals - Iron',
'Metals - Copper');

select * from stock_market;

-- > Treatment of NULL values:
-- If NULL Values > 30%, we delete them.
-- If Null Values < 30%, we replace them by their average.

-- sub_sector
with my_cte1 as(
select count(*) as count_null
from stock_market where sub_sector is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.count_null / my_cte2.total_count)*100 as null_pct 
from my_cte1, my_cte2;

-- Note: As null percentage in sub_sector is 12.98 %, we can replace null values by their mode. 
-- However, as doing this may give wrong data, for instance, if an agriculture company with null sub_sector is assigned as metal industry (assuming mode of sub-sector is metal), we will reduce data accuracy.
-- Hence, we will drop records from sub_sector with null values.

delete from stock_market where sub_sector is NULL;

-- -- market_cap
with my_cte1 as (
select count(*) as null_count 
from stock_market where market_cap is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(market_cap) from stock_market;

update stock_market
set market_cap = 7442.81
where market_cap is NULL;

select market_cap from stock_market;

-- close_price
with my_cte1 as (
select count(*) as null_count
from stock_market where close_price is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count)*100 as pct_null
from my_cte1, my_cte2;

select avg(close_price) from stock_market;

update stock_market
set close_price = 433.87
where close_price is NULL;

-- pe_ratio
with my_cte1 as (
select count(*) as null_count
from stock_market where pe_ratio is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count)*100 as pct_null
from my_cte1, my_cte2;

select avg(pe_ratio) from stock_market;

update stock_market
set pe_ratio = 0
where pe_ratio is NULL;

-- 5_yr_growth:
with my_cte1 as (
select count(*) as null_count
from stock_market where 5_yr_growth is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count)*100 as pct_null
from my_cte1, my_cte2;

select avg(5_yr_growth) from stock_market;

update stock_market
set 5_yr_growth = 8.15
where 5_yr_growth is NULL;

-- 1_yr_growth:
with my_cte1 as (
select count(*) as null_count 
from stock_market where 1_yr_growth is NULL),
my_cte2 as (
select count(*) as total_count
from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

update stock_market
set 1_yr_growth = 0
where 1_yr_growth is NULL;

select * from stock_market;

-- total_revenue
with my_cte1 as (
select count(*) as null_count from stock_market
where total_revenue is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(total_revenue) from stock_market;

update stock_market
set total_revenue = 3734.37
where total_revenue is NULL;

-- pbt
with my_cte1 as (
select count(*) as null_count from stock_market
where pbt is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(pbt) from stock_market;

update stock_market
set pbt = 380.24
where pbt is NULL;

-- taxes_and_other
with my_cte1 as (
select count(*) as null_count from stock_market
where taxes_and_other is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(taxes_and_other) from stock_market;

update stock_market
set taxes_and_other = 112.37
where taxes_and_other is NULL;

-- dii_change
with my_cte1 as (
select count(*) as null_count from stock_market
where dii_change is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(dii_change) from stock_market;

update stock_market
set dii_change = 0.02
where dii_change is NULL;

-- fii_change
with my_cte1 as (
select count(*) as null_count from stock_market
where fii_change is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(fii_change) from stock_market;

update stock_market
set fii_change = 0.08
where fii_change is NULL;

-- mf_change
with my_cte1 as (
select count(*) as null_count from stock_market
where mf_change is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(mf_change) from stock_market;

update stock_market
set mf_change = 0.02
where mf_change is NULL;

-- promoter_change
with my_cte1 as (
select count(*) as null_count from stock_market
where promoter_change is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(promoter_change) from stock_market;

update stock_market
set promoter_change = -0.29
where promoter_change is NULL;

-- percentage_buy
with my_cte1 as (
select count(*) as null_count from stock_market
where percentage_buy is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(percentage_buy) from stock_market;

update stock_market
set percentage_buy = 73.4
where percentage_buy is NULL;

-- analyst_buy
with my_cte1 as (
select count(*) as null_count from stock_market
where analyst_buy is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(analyst_buy) from stock_market;

update stock_market
set analyst_buy = 1.28
where analyst_buy is NULL;

-- percentage_upside
with my_cte1 as (
select count(*) as null_count from stock_market
where percentage_upside is NULL),
my_cte2 as (
select count(*) as total_count from stock_market)
select (my_cte1.null_count / my_cte2.total_count) * 100 as null_pct
from my_cte1, my_cte2;

select avg(percentage_upside) from stock_market;

update stock_market
set percentage_upside = 18.77
where percentage_upside is NULL;

select count(*) from stock_market where percentage_upside = 18.77;

update stock_market
set percentage_upside = 0
where percentage_upside = 18.77;
-- As percentage of nulls in percentage_upside was around 70%, using average of 18.77 would result in skewness. Hence replaced them by 0.

-- Basic data cleaning is completed!
-- As we have completed basic cleaning (removing null, checking data accuracy, and integrity), we can exxport our file to csv and python for further analysis.

select * from stock_market;