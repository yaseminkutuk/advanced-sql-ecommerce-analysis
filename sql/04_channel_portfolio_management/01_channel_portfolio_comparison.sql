-- 	1.Analyzing Channel Portfolios

-- 	Business Question:
-- With the gsearch doing well we launched a second paid search channel bsearch around August 22.
-- can you pull weekly trended session volume since then and compare to gsearch?
-- Analysis date: 2012-11-29

select 
min(date(created_at)) as week_start_date,
count(distinct case when utm_source = "gsearch" then website_session_id end) as gsearch_sessions,
count(distinct case when utm_source = "bsearch" then website_session_id end) as bsearch_sessions
from website_sessions 
where created_at < "2012-11-29"
and created_at > "2012-08-22"
and utm_campaign = "nonbrand"
group by week(created_at), year(created_at)
order by week_start_date;
