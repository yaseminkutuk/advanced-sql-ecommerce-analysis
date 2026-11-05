-- 	5. Analyzing Direct traffic

-- Business Question:
-- Could you pull organic search direct type in and paid brand search sessions by month
-- and show those sessions as a percentage of paid search nonbrand
-- Analysis date: 2012-12-23.

-- solution1:
select 
year(created_at) as year,
month(created_at) as month,
count(distinct case when utm_campaign = "nonbrand" then website_session_id else null end) as nonbrand_sessions,
count(distinct case when utm_campaign = "brand" then website_session_id else null end) as brand_sessions,
count(distinct case when utm_campaign = "brand" then website_session_id else null end)/
	count(distinct case when utm_campaign = "nonbrand" then website_session_id else null end)
		as brand_percentage_of_nonbrand,
count(distinct case when utm_source is null and http_referer is null then website_session_id else null end) as direct_in,
count(distinct case when utm_source is null and http_referer is null then website_session_id else null end)/
	count(distinct case when utm_campaign = "nonbrand" then website_session_id else null end)
		as direct_percentage_of_nonbrand,
count(distinct case when utm_source is null and http_referer is not null then website_session_id else null end) as organic,
count(distinct case when utm_source is null and http_referer is not null then website_session_id else null end)/
	count(distinct case when utm_campaign = "nonbrand" then website_session_id else null end)
		as organic_percentage_of_nonbrand
from website_sessions 
where created_at < "2012-12-23" 
group by month(created_at), year(created_at);

-- solution2:
SELECT
YEAR(created_at) AS year,
MONTH(created_at) AS month,
COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END) AS brand,
COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END)
	/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_of_nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END) AS direct,
COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END)
	/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'organic Fearch' THEN website_session_id ELSE NULL END) AS organic,
COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END)
/COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
FROM 
(SELECT
website_session_id, created_at,
CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
  WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
  WHEN utm_campaign = 'brand' THEN 'paid_brand'
  WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
  END AS channel_group
FROM website_sessions
WHERE created_at < '2012-12-23'
) AS sessions_w_channel_group
GROUP BY YEAR (created_at), MONTH (created_at);
