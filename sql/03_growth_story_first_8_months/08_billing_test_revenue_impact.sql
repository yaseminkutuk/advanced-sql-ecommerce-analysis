-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 8:
-- I'd love for you to quantify the impact of our billing test, as well. 
-- Please analyze the lift generated from the test (Sep 10 - Nov 10), in terms of revenue per billing page session.
-- and then pull the number of billing page sessions for the past month to understand monthly impact.

-- step1. Analyzing the lift generated from the test in terms of revenue per billing page session.
select wp.pageview_url as billing_version_seen,
count(distinct wp.website_session_id) as sessions,
sum(o.price_usd) as total_revenue,
sum(o.price_usd)/count(wp.website_session_id) as revenue_per_billing_page
from website_pageviews as wp
left join orders as o on o.website_session_id = wp.website_session_id
where wp.pageview_url in ("/billing","/billing-2")
and wp.created_at > "2012-09-10" 
and wp.created_at < "2012-11-10"
group by 1
order by revenue_per_billing_page asc;
-- results:
-- $22.83 revenue per billing page seen for the old "/billing" page.
-- $31.33 revenue per billing page seen for the new "/billing-2" page.
-- $8.5 lift.

-- step2. calculating the number of billing page sessions for the past month

select count(website_session_id) as last_month_sessions
from website_pageviews
where pageview_url in ("/billing","/billing-2")
and created_at > "2012-10-27" 
and created_at < "2012-11-27" ;
-- 1193 billing sessions last month. 
-- value of billing test: 1193 x 8.5 = $10140.
