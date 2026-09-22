-- 	3. Traffic Source Trending

-- Business Question:
-- How has gsearch nonbrand session volume changed over time?
-- Request date: 2012-05-10

-- solution 1: Weekly trend using year and week
select 
year(created_at) as year,
week(created_at) as week,
count(distinct ws.website_session_id) as sessions
from website_sessions ws
where ws.created_at < "2012-05-10"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by week(created_at), year(created_at);

-- solution 2: Weekly trend with week start date
select 
min(date(created_at)) as week_start_date,
count(distinct ws.website_session_id) as sessions
from website_sessions ws
where ws.created_at < "2012-05-10"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by week(created_at), year(created_at);
