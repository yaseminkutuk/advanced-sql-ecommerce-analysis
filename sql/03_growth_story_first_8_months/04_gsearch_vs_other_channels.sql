-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 4:
-- I'm worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch. 
-- Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?

-- Step 1: Identify the available traffic channels
SELECT utm_source,utm_campaign,http_referer FROM mavenfuzzyfactory.website_sessions
where created_at < "2012-11-27"
group by utm_source,utm_campaign,http_referer;

-- Step 2: Compare monthly session trends across traffic channels
select 
month(ws.created_at) as month,
count(case when ws.utm_source ="gsearch" then ws.website_session_id else null end ) as gsearch_paid_sessions,
count(case when ws.utm_source ="bsearch" then ws.website_session_id else null end ) as bsearch_paid_sessions,
count(case when ws.utm_source is null and ws.http_referer is not null then ws.website_session_id else null end ) as organic_search_sessions,
count(case when ws.utm_source is null and ws.http_referer is null then ws.website_session_id else null end ) as direct_type_in_sessions
from website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
where ws.created_at < "2012-11-27"
group by month(ws.created_at);
