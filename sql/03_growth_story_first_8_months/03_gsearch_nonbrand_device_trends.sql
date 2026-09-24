-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 3:
-- While we're on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type? 
-- I want to flex our analytical muscles a little and show the board we really know our traffic sources.alter

-- Solution 1: Device type as rows
select 
month(ws.created_at) as month,
ws.device_type,
count(ws.website_session_id) as sessions,
count(o.order_id) as orders
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
and ws.utm_campaign = "nonbrand"
group by month(ws.created_at),
ws.device_type;

-- Solution 2: Device types as separate columns
select 
month(ws.created_at) as month,
count(case when ws.device_type = "mobile" then ws.website_session_id else null end ) as mobile_sessions,
count(case when ws.device_type = "mobile" then o.order_id else null end ) as mobile_orders,
count(case when ws.device_type = "desktop" then ws.website_session_id else null end ) as desktop_sessions,
count(case when ws.device_type = "desktop" then o.order_id else null end ) as desktop_orders
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
and ws.utm_campaign = "nonbrand"
group by month(ws.created_at);
