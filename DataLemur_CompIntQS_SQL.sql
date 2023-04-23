-- Question 1 (Uber): 
-- Assume you are given the table below on Uber transactions made by users. (Table Name = transactions).
-- Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.
with my_cte as (
select *, row_number() 
over(partition by user_id order by transaction_date) as row_num
from transactions)
select user_id, spend, transaction_date 
from my_cte where row_num % 3 = 0;


-- Question 2 (Google Odd-Even Measurements): 
-- Assume you are given the table containing measurement values obtained from a Google sensor over several days. 
-- Measurements are taken several times within a given day. Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns. 
-- Refer to the Example Output below for the output format.
with my_cte as(select cast(measurement_time as date) measurement_time,
measurement_value, row_number()
over(partition by cast(measurement_time as date)
order by measurement_time) as row_num from measurements)
select measurement_time,
sum(case when row_num % 2 = 1 then measurement_value else 0 end) as odd_sum,
sum(case when row_num % 2 = 0 then measurement_value else 0 end) as even_sum
from my_cte group by measurement_time;
-- Note: Learned to use 'cast' with 'window functions' and 'with clause'. Cast is used to change data type (here measurement_time).


-- Question 3 (United Health - Patient Support Analysis - Part 1):
-- UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs 
-- (contd) whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.
-- Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.
with my_cte as (
select policy_holder_id,
count(case_id) from callers
group by policy_holder_id having
count(case_id)>= 3)
select count(policy_holder_id) from my_cte;

-- United Health - Patient Support Analysis - Part 2): 
-- Calls to the Advocate4Me call centre are categorised, but sometimes they can't fit neatly into a category. 
-- (contd) These uncategorised calls are labelled “n/a”, or are just empty (when a support agent enters nothing into the category field).
-- Write a query to find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.
with my_cte as(
select count(case_id) as null_count 
from callers where call_category is null or call_category like '%n/a%')
select round(null_count::numeric/(select count(*) from callers)*100, 1) 
as call_percentage from my_cte group by null_count;


-- Question 4 (Microsoft): Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022. 
-- (contd) Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending count of the messages.
-- (contd) Assumption: No two users has sent the same number of messages in August 2022.
select sender_id, count(message_id) as message_count
from messages
where sent_date >= '08/01/2022' and sent_date <= '09/01/2022'
group by sender_id order by message_count desc
limit 2;


-- Question 5 (Spotify - Top Artist):
-- Assume there are three Spotify tables containing information about the artists, songs, and music charts. 
-- (contd) Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. 
-- (contd) From now on, we'll refer to this ranking number as "song appearances".
-- (contd) Output the top 5 artist names in ascending order along with their song appearances ranking 
-- (contd) (not the number of song appearances, but the rank of who has the most appearances). The order of the rank should take precedence.
with my_cte as(select distinct
artists.artist_name,
count(*) filter (where global_song_rank.rank <=10)
over(partition by artists.artist_name) 
as artist_rank
from artists
join songs on artists.artist_id = songs.artist_id
join global_song_rank on songs.song_id = global_song_rank.song_id
order by artist_rank desc)
select artist_name,
dense_rank() over(order by my_cte.artist_rank desc) as artistrank1
from my_cte limit 6;


-- Question 6 (Amazon - Review Ratings):
-- Given the reviews table, write a query to get the average stars for each product every month.
select 
date_part('month', submit_date) as month,
product_id as product, 
round(avg(stars),2) as avg_stars
from reviews
group by product_id, date_part('month', submit_date)
order by date_part('month', submit_date), product_id;
-- Note: date_part used for postgre, in case of mysql, we will use 'month' query.


-- Question 7 (Snapchat - Sending vs Opening snaps):
-- Assume you are given the tables below containing information on Snapchat users, their ages, and their time spent sending and opening snaps.
-- (contd) Write a query to obtain a breakdown of the time spent sending vs. opening snaps (as a percentage of total time spent on these activities) for each age group.
-- Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2 decimal places.
with my_cte as (
select *, row_number() over (partition by activities.activity_type 
order by activities.user_id) as row_num
from activities
join age_breakdown on activities.user_id = age_breakdown.user_id),
my_cte2 as (
select age_bucket,
sum(case when activity_type = 'chat' then time_spent else 0 end) as chat,
sum(case when activity_type = 'open' then time_spent else 0 end) as open,
sum(case when activity_type = 'send' then time_spent else 0 end) as send,
sum(case when activity_type in ('open', 'send') then time_spent ELSE 0 END) as total
from my_cte
group by my_cte.age_bucket)
select
my_cte2.age_bucket,
round(100*send/total, 2) as send_perc,
round(100*open/total, 2) as send_perc
from my_cte2;


-- Question 8 (Amazon - Highest Grossing Products):
-- Assume you are given the table containing information on Amazon customers and their spending on products in various categories.
-- (contd) Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.
with my_cte as(select category, product, sum(spend) as total_spend,
rank() over (partition by category order by sum(spend) desc) as rank1
from product_spend
where transaction_date >= '01/01/2022' and transaction_date <= '12/31/2022'
group by product, category)
select category,
product,
total_spend from my_cte
where rank1 <= 2;
-- Note: Learned to use rank() to group by same products within the a category and fetch top n products within same category.


-- Question 9 (Tiktok - Signup Activation Rate):
-- New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. 
-- (contd) Users may receive multiple text messages for account confirmation until they have confirmed their new account.
-- (contd) A senior analyst is interested to know the activation rate of specified users in the emails table. 
-- (contd) Write a query to find the activation rate. Round the percentage to 2 decimal places.
SELECT 
ROUND(COUNT(texts.email_id)::DECIMAL
/COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed';
-- Converted to decimal to prevent diving integer by integer


-- Question 10 (Microsoft Supercloud Customer):
-- A Microsoft Azure Supercloud customer is a company which buys at least 1 product from each product category.
-- (contd) Write a query to report the company ID which is a Supercloud customer.
with my_cte as(select customer_contracts.customer_id, customer_contracts.product_id,
customer_contracts.amount, products.product_category, products.product_name
from customer_contracts
JOIN products on customer_contracts.product_id = products.product_id)
select customer_id from my_cte 
group by customer_id having count(distinct product_category) = 3;

-- Note: This query won't work if more product_categories are added infuture. A query provided by user Abraham Setiawan on the Discussion platform solves this issue:
SELECT c.customer_id
FROM customer_contracts c
JOIN products p
ON c.product_id = p.product_id
GROUP BY 1
HAVING ARRAY_AGG(DISTINCT product_category ORDER BY product_category) = 
(SELECT ARRAY_AGG(DISTINCT product_category ORDER BY product_category)
FROM products)
        
        
-- Question 11 (Walmart - Histogram of Users and Purchases):
-- Assume you are given the table on Walmart user transactions. 
-- (contd) Based on a user's most recent transaction date, write a query to obtain the users and the number of products bought.
-- (contd) Output the user's most recent transaction date, user ID and the number of products sorted by the transaction date in chronological order.
with my_cte as(select transaction_date, user_id, count(product_id) as purchase_count,
rank() over (partition by user_id order by transaction_date desc)
from user_transactions
group by user_id, transaction_date 
order by transaction_date)
select transaction_date, user_id, purchase_count
from my_cte where rank = 1;


-- Question 12 (Alibaba - Compressed Mode):
-- You are trying to find the most common (aka the mode) number of items bought per order on Alibaba.
-- (contd) However, instead of doing analytics on all Alibaba orders, you have access to a summary table, 
-- (contd) which describes how many items were in an order (item_count), and the number of orders that had that many items (order_occurrences).
with my_cte as(
select *, dense_rank() over(order by order_occurrences) as rank1
from items_per_order  order by rank1 desc , item_count asc)
select my_cte.item_count from my_cte 
where my_cte.order_occurrences = (select max(my_cte.order_occurrences) from my_cte)


-- Question 13 (Facebook - App Click-Through Rate):
-- Assume you have an events table on Facebook app analytics. 
-- (contd) Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.
with my_cte as(select app_id, event_type, timestamp, ctr from events
where timestamp >= '01/01/2022' and timestamp <= '12/31/2022')
select app_id,
round(100.0*sum(case when event_type = 'click' then 1 else 0 end) / 
sum(case when event_type = 'impression' then 1 else 0 end), 2)as ctr from my_cte
group by my_cte.app_id


-- Question 14 (Verizon - International Call Percentage):
-- A phone call is considered an international call when the person calling is in a different country than the person receiving the call.
-- (contd) What percentage of phone calls are international? Round the result to 1 decimal.
with my_cte as (
select 
caller.caller_id, 
caller.country_id,
receiver.caller_id, 
receiver.country_id
from phone_calls AS calls
join phone_info AS caller
on calls.caller_id = caller.caller_id
join phone_info AS receiver
on calls.receiver_id = receiver.caller_id
where caller.country_id <> receiver.country_id)
select round(100.0*count(*) / (select count(*) from phone_calls), 1) as int_calls
from my_cte;


-- Question 15 (JPMorgan Chase - Card Launch Success):
-- Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.
-- (contd) Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.
-- (contd) Write a query that outputs the name of the credit card, and how many cards were issued in its launch month.
with my_cte as(select card_name, issued_amount, issue_month, issue_year,
rank() over(PARTITION BY card_name ORDER BY issued_amount, issue_month) as rank1
FROM monthly_cards_issued)
select card_name, issued_amount from my_cte where rank1 = 1 order by issued_amount desc;


-- Question 16 (Twitter - Rolling Average):
-- Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. 
-- (contd) Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.
SELECT user_id, tweet_date, round(avg(tweet_count) 
over(partition by user_id order by tweet_date 
rows between 2 preceding and current row), 2) as rolling_avg
from tweets;
-- Note:: Learned about rolling average


-- Question 17 (Facebook - Active User Retention):
-- Assume you're given a table containing information on Facebook user actions. 
-- (contd) Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".
-- (contd) Hint: An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
with month6 as(select user_id from user_actions where event_type in('sign-in', 'like', 'comment')
and EXTRACT(month from event_date) = 6)
select extract(month from event_date) as month,
count(distinct(user_id)) as monthly_active_users
from user_actions 
where extract(month from event_date) = 7 and user_id in (select * from month6)
group by month
-- Learned to use extract() more effectively.


-- Question 18 (Wayfair - Year-on-Year Growth Rate):
-- Assume you are given the table below containing information on user transactions for particular products. 
-- (contd) Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.
-- (contd) Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).
with my_cte1 as(select transaction_id, product_id, spend as curr_year_spend, 
extract(year from transaction_date) as year
from user_transactions),
my_cte2 as(select product_id, curr_year_spend, year, 
lag(curr_year_spend, 1) over(partition by product_id order by product_id)
as prev_year_spend from my_cte1)
select year, product_id, curr_year_spend, prev_year_spend,
round((curr_year_spend-prev_year_spend)/prev_year_spend*100, 2) as yoy
from my_cte2;
-- Note: learned to use lag.