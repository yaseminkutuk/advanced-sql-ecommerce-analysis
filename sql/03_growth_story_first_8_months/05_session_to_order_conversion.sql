-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 5:
-- I'd like to tell the story of our website performance improvements over the course of the first 8 months. 
-- Could you pull session to order conversion rates, by month?

select 
month(ws.created_at) as month,
count(ws.website_session_id) as sessions,
count(o.order_id) as orders,
count(o.order_id)/count(ws.website_session_id) as session_to_orders_conv_rate
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
group by month(ws.created_at);
