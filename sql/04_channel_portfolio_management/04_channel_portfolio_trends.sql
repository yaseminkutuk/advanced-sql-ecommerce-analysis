-- 	4. Analyzing channel potfolio trends

-- Business Question:
-- We bid down bsearch nonbrand on December 2nd.
-- Can you pull weekly session volume for gsearch and bsearch nonrand broken down by device since November 4th?
-- If you can include a comparison metric to show bsearch as a percent of gsearch for each device.
-- Analysis date: 2012-12-22.

select 
min(date(created_at)) as week_start_date,
count(distinct case when device_type = "desktop" and utm_source = "gsearch" then website_session_id end) as g_desktop_sessions,
count(distinct case when device_type = "desktop" and utm_source = "bsearch" then website_session_id end) as b_desktop_sessions,
count(distinct case when device_type = "desktop" and utm_source = "bsearch" then website_session_id end)/
  count(distinct case when device_type = "desktop" and utm_source = "gsearch" then website_session_id end) 
    as b_percentage_of_g_desktop,
count(distinct case when ws.device_type = "mobile" and utm_source = "gsearch" then ws.website_session_id end) as g_mobile_sessions,
count(distinct case when ws.device_type = "mobile" and utm_source = "bsearch" then ws.website_session_id end) as b_mobile_sessions,
count(distinct case when device_type = "mobile" and utm_source = "bsearch" then website_session_id end)/
  count(distinct case when device_type = "mobile" and utm_source = "gsearch" then website_session_id end) 
    as b_percentage_of_g_mobile
from website_sessions ws
where ws.created_at < "2012-12-22"
and ws.created_at > "2012-11-04"
and ws.utm_campaign = "nonbrand"
group by yearweek(created_at)
order by week_start_date;
