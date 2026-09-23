-- 	7. Conversion Funnel Test Analysis

-- Business Question:
-- We tested an updated billing page. 
-- Can you take a look whether new billing-2 is doing any better than original billing page?
-- We are wondering what % of sessions on those pages end up placing an order.
-- Tested for all traffic not just our search visitors.
-- Request date: 2012-11-10

-- step1: finding the first /billing-2 was seen
SELECT min(website_pageview_id),
min(created_at) 
FROM website_pageviews
where pageview_url = "/billing-2";
-- 2012-09-10

-- step2:
select wp.pageview_url as billing_version,
count(wp.website_session_id) as sessions,
count(o.order_id) as orders,
count(o.order_id)/count(wp.website_session_id) order_session_conv
from website_pageviews as wp
left join orders as o on o.website_session_id = wp.website_session_id
where wp.pageview_url in ("/billing","/billing-2")
and wp.created_at between "2012-09-10" and "2012-11-10"
group by wp.pageview_url
order by order_session_conv asc;
