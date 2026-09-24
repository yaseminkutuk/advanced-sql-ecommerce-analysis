-- Growth Story for First 8 Months of the Company
-- Request date: 2012-11-27

-- Business Question 7:
-- For the landing page test you analyzed previously, it would be great to show a full conversion funnel from each of the two pages to orders. 
-- You can use the same time period you analyzed last time (Jun 19 - Jul 28).

-- Step 1: Identify the first pageview for each relevant session
CREATE TEMPORARY TABLE first_pageviews AS
SELECT
    ws.website_session_id,
    MIN(wp.website_pageview_id) AS first_pageview_id
FROM website_sessions AS ws
LEFT JOIN website_pageviews AS wp
    ON wp.website_session_id = ws.website_session_id
WHERE ws.utm_source = 'gsearch'
  AND ws.utm_campaign = 'nonbrand'
  AND ws.created_at > '2012-06-19'
  AND ws.created_at < '2012-07-28'
GROUP BY ws.website_session_id;

-- Step 2: Identify the landing page for each session
CREATE TEMPORARY TABLE test_sessions AS
SELECT
    f.website_session_id,
    wp.pageview_url AS landing_page
FROM first_pageviews AS f
LEFT JOIN website_pageviews AS wp
    ON f.first_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1');

-- Step 3: Retrieve funnel pageviews for each test session
select ts.website_session_id, 
ts.landing_page,
wp.pageview_url, 
wp.created_at as pageview_created_at,
case when  wp.pageview_url = "/products" then 1 else 0 end as products_page,
case when  wp.pageview_url = "/the-original-mr-fuzzy" then 1 else 0 end as fuzzy_page,
case when  wp.pageview_url = "/cart" then 1 else 0 end as cart_page,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page,
case when  wp.pageview_url = "/billing" then 1 else 0 end as billing_page,
case when  wp.pageview_url = "/thank-you-for-your-order" then 1 else 0 end as thank_you_page
from test_sessions as ts
left join website_pageviews as wp on wp.website_session_id = ts.website_session_id
where wp.pageview_url in ("/home","/lander-1","/products","/the-original-mr-fuzzy","/cart","/shipping","/billing","/thank-you-for-your-order");

-- Step 4: Aggregate pageviews at the session level
CREATE TEMPORARY TABLE session_level_made_it_home AS
SELECT
    ts.website_session_id,
    MAX(CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END) AS clicked_to_products,
    MAX(CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS clicked_to_fuzzy,
    MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS clicked_to_cart,
    MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS clicked_to_shipping,
    MAX(CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END) AS clicked_to_billing,
    MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS clicked_to_thank_you
FROM test_sessions AS ts
LEFT JOIN website_pageviews AS wp
    ON ts.website_session_id = wp.website_session_id
WHERE ts.landing_page = '/home'
GROUP BY ts.website_session_id;

CREATE TEMPORARY TABLE session_level_made_it_lander AS
SELECT
    ts.website_session_id,
    MAX(CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END) AS clicked_to_products,
    MAX(CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END) AS clicked_to_fuzzy,
    MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS clicked_to_cart,
    MAX(CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END) AS clicked_to_shipping,
    MAX(CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END) AS clicked_to_billing,
    MAX(CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END) AS clicked_to_thank_you
FROM test_sessions AS ts
LEFT JOIN website_pageviews AS wp
    ON ts.website_session_id = wp.website_session_id
WHERE ts.landing_page = '/lander-1'
GROUP BY ts.website_session_id;

-- Step 5: Compare the conversion funnel between landing pages
select 
"lander-1" as landing_page_name,
count(website_session_id) as sessions,
count(distinct case when clicked_to_products=1 then website_session_id else null end) as to_products,
count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end) as to_fuzzy,
count(distinct case when clicked_to_cart=1 then website_session_id else null end) as to_cart,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end) as to_shipping,
count(distinct case when clicked_to_billing=1 then website_session_id else null end) as to_billing,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end) as to_thank_you
from session_level_made_it_lander
union
select 
"home" as landing_page_name,
count(website_session_id) as sessions,
count(distinct case when clicked_to_products=1 then website_session_id else null end) as to_products,
count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end) as to_fuzzy,
count(distinct case when clicked_to_cart=1 then website_session_id else null end) as to_cart,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end) as to_shipping,
count(distinct case when clicked_to_billing=1 then website_session_id else null end) as to_billing,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end) as to_thank_you
from session_level_made_it_home;

-- Step 6: Calculate click-through rates between funnel stages
select 
"lander-1" as landing_page_name,
count(website_session_id) as session_count,
count(distinct case when clicked_to_products=1 then website_session_id else null end)/count(website_session_id) 
	as landing_to_products_clickthrough_rate,
count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end)/count(distinct case when clicked_to_products=1 then website_session_id else null end) 
	as products_to_fuzzy_clickthrough_rate,
count(distinct case when clicked_to_cart=1 then website_session_id else null end)/count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end) 
	as fuzzy_to_cart_clickthrough_rate,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end)/count(distinct case when clicked_to_cart=1 then website_session_id else null end)
	as cart_to_shipping_clickthrough_rate,
count(distinct case when clicked_to_billing=1 then website_session_id else null end)/count(distinct case when clicked_to_shipping=1 then website_session_id else null end)
	as shipping_to_billing_clickthrough_rate,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end)/count(distinct case when clicked_to_billing=1 then website_session_id else null end)
	as billing_to_thank_you_clickthrough_rate
from session_level_made_it_lander

union

select 
"home" as landing_page_name,
count(website_session_id) as session_count,
count(distinct case when clicked_to_products=1 then website_session_id else null end)/count(website_session_id) 
	as landing_to_products_clickthrough_rate,
count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end)/count(distinct case when clicked_to_products=1 then website_session_id else null end) 
	as products_to_fuzzy_clickthrough_rate,
count(distinct case when clicked_to_cart=1 then website_session_id else null end)/count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end) 
	as fuzzy_to_cart_clickthrough_rate,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end)/count(distinct case when clicked_to_cart=1 then website_session_id else null end)
	as cart_to_shipping_clickthrough_rate,
count(distinct case when clicked_to_billing=1 then website_session_id else null end)/count(distinct case when clicked_to_shipping=1 then website_session_id else null end)
	as shipping_to_billing_clickthrough_rate,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end)/count(distinct case when clicked_to_billing=1 then website_session_id else null end)
	as billing_to_thank_you_clickthrough_rate
from session_level_made_it_home;
