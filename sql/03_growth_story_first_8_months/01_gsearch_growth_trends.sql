-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 1:
-- Gsearch seems to be the biggest driver of our business. 
-- Could you pull monthly trends for gsearch sessions and orders so that we can showcase the growth

select 
month(ws.created_at) as month,
count(ws.website_session_id) as sessions,
count(o.order_id) as orders
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
group by month(ws.created_at);
