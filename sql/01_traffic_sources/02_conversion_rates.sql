-- 	2. Traffic Source Cenversion Rates

-- 	Business Question:
-- What is the conversion rate from session to order for the major traffic source?
-- Request date: 2012-04-14

select 
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
count(distinct o.order_id)/count(distinct ws.website_session_id)  as conv_rate
from website_sessions ws
left join orders o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-04-14"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand";
