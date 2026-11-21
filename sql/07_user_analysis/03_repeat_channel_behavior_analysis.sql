-- 	3. Analyzing repeat channel behavior

-- 	Business Question:
-- Could you get the channels they come back through?
-- Curios if it is all direct type in, or if we are paying for these customers with paid searchs ads multiple times.
-- comparing new. vs repeat sessions by channel would be great. 2014 to date is good.
-- Analysis date: 2014-11-05.

SELECT
CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
  WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
  WHEN utm_campaign = 'brand' THEN 'paid_brand'
  WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
  when http_referer = "https://www.socialbook.com" then 'paid_social'
  END AS channel_group,
  count(CASE WHEN is_repeat_session = 0 THEN website_session_id end) as 'new_sessions',
  count(CASE WHEN is_repeat_session = 1 THEN website_session_id end) as 'repeat_sessions'
FROM website_sessions
WHERE created_at < '2014-11-05'
and created_at >= '2014-01-01'
group by channel_group
order by repeat_sessions desc;
