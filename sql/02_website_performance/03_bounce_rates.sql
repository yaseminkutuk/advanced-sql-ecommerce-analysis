-- 	3. Calculating Bounce Rates

-- Business Question:
-- Can you pull bounce rates for traffic landing on the homepage?
-- Display sessions, bounced sessions and % of the sessions which bounced(bounce rate).
-- Request date: 2012-06-14

-- step 1.finding the first website pageview ids
create temporary table first_entries
select min(website_pageview_id) as min_pv_id,
website_session_id
from website_pageviews 
where created_at < "2012-06-14"
group by website_session_id;

-- step 2.identifying the landing pages for every session
create temporary table sessions_and_landing_pages
select wp.pageview_url as landing_page,
f.website_session_id
from first_entries as f
left join website_pageviews as wp on f.min_pv_id = wp.website_pageview_id
where wp.pageview_url  = "/home";

-- step 3.counting pageviews for each sessions to identify bounce sessions
create temporary table bounced_sessions
select s.website_session_id,
s.landing_page,
count(wp.website_pageview_id) as view_count
from sessions_and_landing_pages as s
left join website_pageviews as wp on s.website_session_id = wp.website_session_id
group by s.website_session_id, s.landing_page
having count(wp.website_pageview_id) = 1;

-- step 4.counting total sessions, bounced sessions and bounce rate
select count(distinct s.website_session_id) as sessions,
count(distinct b.website_session_id) as bounced_sessions,
count(distinct b.website_session_id)/count(distinct s.website_session_id) as bounce_rate
from sessions_and_landing_pages as s
left join bounced_sessions as b on b.website_session_id = s.website_session_id;
