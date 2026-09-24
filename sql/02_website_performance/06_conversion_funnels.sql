-- 	6. Building Conversion Funnels

-- Business Question:
-- I would like to understand where we lose our gsearch visitors between new lander-1 page and placing an order.
-- Can you build a full conversion funnel, analyzing how many customers make it to each step?
-- Start with /lander-1 and build the funnel all the way to the thank you page.
-- Use the data since August 5.
-- Request date: 2012-09-05

-- step1. select all pageviews for relevant sessions:
select ws.website_session_id, 
wp.pageview_url, 
wp.created_at as pageview_created_at,
case when  wp.pageview_url = "/products" then 1 else 0 end as products_page,
case when  wp.pageview_url = "/the-original-mr-fuzzy" then 1 else 0 end as fuzzy_page,
case when  wp.pageview_url = "/cart" then 1 else 0 end as cart_page,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page,
case when  wp.pageview_url = "/billing" then 1 else 0 end as billing_page,
case when  wp.pageview_url = "/thank-you-for-your-order" then 1 else 0 end as thank_you_page
from website_sessions as ws
left join website_pageviews as wp on wp.website_session_id = ws.website_session_id
where ws.utm_source ="gsearch"
and ws.utm_campaign = "nonbrand"
and ws.created_at > "2012-08-05" 
and ws.created_at < "2012-09-05";

-- step2. identify each pageview as specific funnel step:
create temporary table session_level_made_it
select website_session_id,
max(products_page) as clicked_to_products,
max(fuzzy_page) as clicked_to_fuzzy,
max(cart_page) as clicked_to_cart,
max(shipping_page) as clicked_to_shipping,
max(billing_page) as clicked_to_billing,
max(thank_you_page) as clicked_to_thank_you
from 
(select ws.website_session_id, 
wp.pageview_url, 
wp.created_at as pageview_created_at,
case when  wp.pageview_url = "/products" then 1 else 0 end as products_page,
case when  wp.pageview_url = "/the-original-mr-fuzzy" then 1 else 0 end as fuzzy_page,
case when  wp.pageview_url = "/cart" then 1 else 0 end as cart_page,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page,
case when  wp.pageview_url = "/billing" then 1 else 0 end as billing_page,
case when  wp.pageview_url = "/thank-you-for-your-order" then 1 else 0 end as thank_you_page
from website_sessions as ws
left join website_pageviews as wp on wp.website_session_id = ws.website_session_id
where ws.utm_source ="gsearch"
and ws.utm_campaign = "nonbrand"
and ws.created_at > "2012-08-05" 
and ws.created_at < "2012-09-05") as pageview_level
group by website_session_id;

-- step3: create the session level conversion funnel:
select 
count(website_session_id) as sessions,
count(distinct case when clicked_to_products=1 then website_session_id else null end) as to_products,
count(distinct case when clicked_to_fuzzy=1 then website_session_id else null end) as to_fuzzy,
count(distinct case when clicked_to_cart=1 then website_session_id else null end) as to_cart,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end) as to_shipping,
count(distinct case when clicked_to_billing=1 then website_session_id else null end) as to_billing,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end) as to_thank_you
from session_level_made_it; 

-- step4: display clickthrough rates for each step:
select 
count(website_session_id) as session_count,
count(distinct case when clicked_to_products=1 then website_session_id else null end)/count(website_session_id) 
	as lander_to_products_clickthrough_rate,
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
from session_level_made_it;
