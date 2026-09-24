-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 6:
-- For the gsearch lander test, please estimate the revenue that test earned us 
-- (Hint: Look at the increase in CVR from the test (Jun 19 - Jul 28), 
-- and use nonbrand sessions and revenue since then to calculate incremental value)

-- step 1. finding the first instance of lander-1(double check):
SELECT 
min(website_pageview_id), 
min(created_at)  
FROM website_pageviews
where pageview_url= "/lander-1";

-- step 2.finding the first website pageview ids
create temporary table first_test_pageviews
select min(wp.website_pageview_id) as min_pv_id,
wp.website_session_id
from website_pageviews as wp
inner join website_sessions as ws on ws.website_session_id = wp.website_session_id
where wp.created_at > "2012-06-19" -- or we can use "wp.website_pageview_id > 23504"
and wp.created_at < "2012-07-28"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by website_session_id;

-- step 3.identifying the landing pages for every session
create temporary table nonbrand_test_sessions_landing_pages
select wp.pageview_url as landing_page,
f.website_session_id
from first_test_pageviews as f
left join website_pageviews as wp on f.min_pv_id = wp.website_pageview_id
where wp.pageview_url  in ("/home","/lander-1");

-- step4. then we make another table to bring the orders
create temporary table nonbrand_test_sessions_w_orders
select nb.website_session_id,
o.order_id,
nb.landing_page
from nonbrand_test_sessions_landing_pages as nb
left join orders as o on nb.website_session_id = o.website_session_id;

-- step5. to find the difference between conv rates
select landing_page,
count(website_session_id) as sessions,
count(order_id) as orders,
count(order_id)/count(website_session_id)  as conv_rate
from nonbrand_test_sessions_w_orders
group by landing_page;
-- 0.0406 for lander and 0.0318 for home.

-- step6. finding most recent pageview 

select max(ws.website_session_id) as most_recent_id
from website_sessions as ws
left join website_pageviews as wp on wp.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
and ws.utm_source ="gsearch"
and ws.utm_campaign = "nonbrand"
and wp.pageview_url = "/home";
-- 17145

-- step7. nonbrand sessions and revenue since then:

select count(website_session_id) as session_since
from website_sessions
where created_at < "2012-11-27"
and website_session_id >17145
and utm_source ="gsearch"
and utm_campaign = "nonbrand";

-- Results:
-- sessions since:22972.
-- 0.0406 for lander and 0.0318 for home: the difference is 0.0088. 22972 × 0.0088 ≈ 202
-- 202 incremental orders since July 29th.
-- Approximately 50 incremental orders per month.

SELECT
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.price_usd) AS revenue,
    SUM(o.price_usd) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM website_sessions AS ws
LEFT JOIN orders AS o
    ON o.website_session_id = ws.website_session_id
WHERE ws.created_at < '2012-11-27'
  AND ws.website_session_id > 17145
  AND ws.utm_source = 'gsearch'
  AND ws.utm_campaign = 'nonbrand';

-- Results:
-- 931 orders since the test
-- $46,540.69 revenue since the test
-- $49.99 average order value
-- Incremental orders: 22,972 × 0.0088 ≈ 202
-- Estimated incremental revenue: 202 × $49.99 ≈ $10,097.98
