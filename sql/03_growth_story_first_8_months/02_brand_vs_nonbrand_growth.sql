-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 2:
-- Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand and brand campaigns separately. 
-- I am wondering if brand is picking up at all. If so, this is a good story to tell.

select 
month(ws.created_at) as month,
count(case when ws.utm_campaign = "brand" then ws.website_session_id else null end ) as brand_sessions,
count(case when ws.utm_campaign = "brand" then o.order_id else null end ) as brand_orders,
count(case when ws.utm_campaign = "nonbrand" then ws.website_session_id else null end ) as nonbrand_sessions,
count(case when ws.utm_campaign = "nonbrand" then o.order_id else null end ) as nonbrand_orders
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
group by month(ws.created_at);
