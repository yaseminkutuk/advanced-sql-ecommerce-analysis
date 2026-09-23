-- 	4. Landing Page Tests Analysis

-- Business Question:
-- Based on bounce rate analysis, a landing page(/lander-1) is created in a 50/50 test against homepage for gsearch non brand traffic.
-- Can you pull bounce rates for these two groups? 
-- Make sure to just look at the time period where lander-1 was getting traffic.
-- Request date: 2012-07-28

-- step 1. finding the first instance of lander-1:
SELECT 
min(website_pageview_id), 
min(created_at)  
FROM website_pageviews
where pageview_url= "/lander-1";

-- step 2.finding the first website pageview ids
create temporary table first_entry
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
create temporary table sessions_and_two_landing_pages
select wp.pageview_url as landing_page,
f.website_session_id
from first_entry as f
left join website_pageviews as wp on f.min_pv_id = wp.website_pageview_id
where wp.pageview_url  in ("/home","/lander-1");

-- step 4.counting pageviews for each sessions to identify bounce sessions
create temporary table bounced_sessions_two
select s.website_session_id,
s.landing_page,
count(wp.website_pageview_id) as view_count
from sessions_and_two_landing_pages as s
left join website_pageviews as wp on s.website_session_id = wp.website_session_id
group by s.website_session_id, s.landing_page
having count(wp.website_pageview_id) = 1;

-- step 5.counting total sessions, bounced sessions and bounce rate
select 
s.landing_page,
count(distinct s.website_session_id) as total_sessions,
count(distinct b.website_session_id) as bounced_sessions,
count(distinct b.website_session_id)/count(distinct s.website_session_id) as bounce_rate
from sessions_and_two_landing_pages as s
left join bounced_sessions_two as b on b.website_session_id = s.website_session_id
group by s.landing_page;
