-- 	5. Landing Page Trend Analysis

-- Business Question:
-- Could you pull the volume of paid search nonbrand traffic landing on /home and /lander-1, trended weekly since June 1st?
-- Can you also pull overall paid search bounce rate trended weekly?
-- Request date: 2012-08-31

-- step 1.finding the first website pageview ids
create temporary table min_pv_id_2
select min(wp.website_pageview_id) as min_pv_id,
ws.website_session_id
from website_sessions as ws
left join website_pageviews as wp on ws.website_session_id = wp.website_session_id
where  ws.created_at >  "2012-06-01"
and ws.created_at < "2012-08-31"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by ws.website_session_id;

-- step 2.identifying the landing pages for each session
create temporary table sessions_created_at_2
select
m.website_session_id,
m.min_pv_id,
wp.pageview_url as landing_page,
wp.created_at as session_created_at
from min_pv_id_2 as m
left join website_pageviews as wp on m.min_pv_id = wp.website_pageview_id
where wp.pageview_url  in ("/home","/lander-1");

-- step 3.counting pageviews for each sessions to identify bounce sessions
create temporary table bounced_sessions_or2
select s.website_session_id,
s.landing_page,
count(wp.website_pageview_id) as view_count
from sessions_created_at_2 as s
left join website_pageviews as wp on s.website_session_id = wp.website_session_id
group by s.website_session_id, s.landing_page
having count(wp.website_pageview_id) = 1;

-- step 4.counting total sessions for each landing page, and bounce rate trended weekly
select min(date(s.session_created_at)) as week_start_date,
count(distinct b.website_session_id)/ count(distinct s.website_session_id) as bounce_rate,
count(distinct case when s.landing_page = "/home" then s.website_session_id else null end) as home_sessions,
count(distinct case when s.landing_page = "/lander-1" then s.website_session_id else null end) as lander_sessions
from sessions_created_at_2 as s
left join bounced_sessions_or2 as b on b.website_session_id = s.website_session_id
group by week(s.session_created_at), year(s.session_created_at);

-- or we can combine two steps together:

-- step 1.finding the first website pageview ids and pageview count in one step
create temporary table min_pv_id_and_view_count
select min(wp.website_pageview_id) as min_pv_id,
ws.website_session_id,
count(wp.website_pageview_id) as pv_count --this line is added
from website_sessions as ws
left join website_pageviews as wp on ws.website_session_id = wp.website_session_id
where  ws.created_at >  "2012-06-01"
and ws.created_at < "2012-08-31"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by ws.website_session_id;

-- step 2.identifying the landing pages for each session
create temporary table sessions_counts_and_created_at
select
m.website_session_id,
m.min_pv_id,
m.pv_count, -- this line is added later as well
wp.pageview_url as landing_page,
wp.created_at as session_created_at
from min_pv_id_and_view_count as m
left join website_pageviews as wp on m.min_pv_id = wp.website_pageview_id;

-- step 3.counting pageviews for each sessions to identify bounce sessions
select min(date(session_created_at)) as week_start_date,
count(distinct case when pv_count = 1 then website_session_id else null end)/ count(distinct website_session_id) as bounce_rate,
count(distinct case when landing_page = "/home" then website_session_id else null end) as home_sessions,
count(distinct case when landing_page = "/lander-1" then website_session_id else null end) as lander_sessions
from sessions_counts_and_created_at
group by week(session_created_at), year(session_created_at);
