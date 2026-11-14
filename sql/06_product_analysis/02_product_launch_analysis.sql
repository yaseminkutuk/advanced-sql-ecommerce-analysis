-- 	2. Analyzing Product Launches

-- 	Business Question:
-- We launched our second product on January 6th.
-- Id like to see monthly order volume, overall conversion rates, revenue per session, and breakdown of sales by product?
-- All for the time period since April 1,2012.
-- Analysis date: 2013-04-05.

select 
year(ws.created_at) AS year,
month(ws.created_at) as month,
count(distinct o.order_id) as order_volume,
count(distinct o.order_id)/count(distinct ws.website_session_id)  as conv_rate,
sum(o.price_usd)/count(distinct ws.website_session_id) as revenue_per_session,
count(distinct case when o.primary_product_id = 1 then o.order_id end) as product1,
count(distinct case when o.primary_product_id = 2 then o.order_id end) as product2
from website_sessions ws
left join orders o on o.website_session_id = ws.website_session_id
where ws.created_at < "2013-04-05"
and ws.created_at > "2012-04-01"
group by year(ws.created_at), month(ws.created_at);
