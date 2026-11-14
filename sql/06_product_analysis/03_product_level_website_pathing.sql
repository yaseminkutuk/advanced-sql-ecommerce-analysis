-- 	3. Product-Level Website Pathing

-- 	Business Question:
-- Now that we have a new product, lets look at sessions which hit the /products page and see where they went next.
-- Can you pull clickthrough rates from /products since the launch on January 6th 2013, by product?
-- And Compare to the 3 months leading up to launch as a baseline?
-- Analysis date: 2013-04-06.

-- step1. finding the sessions

create temporary table pageview_time_periods
select website_session_id,
website_pageview_id,
created_at,
case 
	when created_at < "2013-01-06" then "Pre-Product"
    when created_at >="2013-01-06" then "Post-Product"
    end as time_period
from website_pageviews 
where created_at > "2012-10-06" 
and  created_at  < "2013-04-06"
and pageview_url = '/products';

-- step2: finding next pageviews

CREATE TEMPORARY TABLE next_pageview_ids
SELECT
pp.time_period, 
pp.website_session_id, 
MIN(wp.website_pageview_id) AS min_next_pageview_id
FROM pageview_time_periods as pp
LEFT JOIN website_pageviews as wp
ON wp.website_session_id = pp.website_session_id
AND wp.website_pageview_id > pp.website_pageview_id
GROUP BY pp.time_period, 
pp.website_session_id;

-- Step 3: find the pageview_url for the next pageview id

CREATE TEMPORARY TABLE sessions_next_pageview_urls
SELECT
np.time_period, 
np.website_session_id, 
wp.pageview_url AS next_pageview_url
FROM next_pageview_ids as np
LEFT JOIN website_pageviews as wp
ON wp.website_pageview_id = np.min_next_pageview_id;

-- Step 4: analyze the pre vs post periods

SELECT time_period,
COUNT(DISTINCT website_session_id) AS products_sessions,
COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS has_next_page,
COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS percentage_next_page,
COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS mrfuzzy,
cOUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS percentage_mrfuzzy,
COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS lovebear,
COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS percentage_lovebear
FROM sessions_next_pageview_urls
GROUP BY time_period;
