-- 	2. Channel Characteristics Comparision

--  Business Question:
-- Could you pull the percentage of traffic coming on mobile and compare that to gsearch?
-- Aggregate data since August 22.
-- Analysis date: 2012-11-30

select 
utm_source,
count(distinct website_session_id) as sessions,
count(distinct case when device_type = "mobile" then website_session_id else null end) as mobile_sessions,
count(distinct case when device_type = "mobile" then website_session_id else null end)/count(distinct website_session_id) as percentage
from website_sessions 
where created_at < "2012-11-30"
and created_at > "2012-08-22"
and utm_campaign = "nonbrand"
group by utm_source;
