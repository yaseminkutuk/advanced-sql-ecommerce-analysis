-- 	5. Trending with Granular Segments

-- Business Question:
-- How do weekly desktop and mobile session volumes compare before the bid optimization?
-- Baseline period: 2012-04-15 onward
-- Request date: 2012-06-09

select 
min(date(created_at)) as week_start_date,
count(distinct case when ws.device_type = "desktop" then ws.website_session_id end) as desktop_sessions,
count(distinct case when ws.device_type = "mobile" then ws.website_session_id end) as mobile_sessions
from website_sessions ws
where ws.created_at < "2012-06-09"
and ws.created_at > "2012-04-15"
and ws.utm_source = "gsearch"
and ws.utm_campaign = "nonbrand"
group by week(created_at), year(created_at)
order by week_start_date;
