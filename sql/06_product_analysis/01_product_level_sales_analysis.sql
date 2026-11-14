-- 	1. Product-Level Sales Analysis


-- 	Business Question:
-- Can you pull monthly trends to date for number of sales, total revenue, and total margin generated?
-- Analysis date: 2013-01-04.

select 
year(created_at) AS year,
month(created_at) as month,
count(distinct order_id) as total_sales,
sum(price_usd) as total_revenue,
sum(price_usd)- sum(cogs_usd) as total_margin
from orders
where created_at < "2013-01-04"
group by year(created_at), month(created_at);
