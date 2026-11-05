-- 	3. Cross-Channel Bid Optimization

-- Business Question:
-- Could you pull nonbrand conversion rates from session to order for gsearch and bsearch and slice the data by device type?
-- Analyze the data from August 22 to September 19.

select 
ws.device_type,
ws.utm_source,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
count(distinct o.order_id)/count(distinct ws.website_session_id)  as conv_rate
from website_sessions ws
left join orders o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-09-19"
and ws.created_at > "2012-08-22"
and ws.utm_campaign = "nonbrand"
group by ws.device_type, ws.utm_source;
