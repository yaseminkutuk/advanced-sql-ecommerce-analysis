
-- 4. Product-Level Conversion Funnel

-- 	Business Question:
-- I want to see our two products since Jan 6th and analyze conversion funnels from each product page to conversion.
-- If you could produce a comparison between the two conversion funnels, for all website traffic as well.
-- Analysis date: 2014-04-10.

-- step1. select all pageviews for relevant sessions:

create temporary table base_products_table
SELECT pageview_url as products,
website_session_id,
website_pageview_id
FROM website_pageviews
where pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear')
and created_at < '2013-04-10'
and created_at > '2013-01-06';

-- step2. displaying the pageview urls to look for

select distinct wp.pageview_url
from base_products_table as bp
left join website_pageviews as wp
on bp.website_session_id = wp.website_session_id
and wp.website_pageview_id > bp.website_pageview_id;

-- step3: identify funnel steps

select bp.website_session_id, 
bp.products,
case when  wp.pageview_url = "/cart" then 1 else 0 end as cart_page,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page,
case when  wp.pageview_url = "/billing-2" then 1 else 0 end as billing_page,
case when  wp.pageview_url = "/thank-you-for-your-order" then 1 else 0 end as thank_you_page
from base_products_table as bp
left join website_pageviews as wp on wp.website_session_id = bp.website_session_id
and wp.website_pageview_id > bp.website_pageview_id;

create temporary table base_session_level
select website_session_id,
case 
	when product_name = "/the-original-mr-fuzzy" then "mrfuzzy"
	when product_name =  "/the-forever-love-bear" then "lovebear"
    end as product_seen,
max(cart_page) as clicked_to_cart,
max(shipping_page) as clicked_to_shipping,
max(billing_page) as clicked_to_billing,
max(thank_you_page) as clicked_to_thank_you
from 
(select bp.website_session_id, 
bp.products as product_name,
case when  wp.pageview_url = "/cart" then 1 else 0 end as cart_page,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page,
case when  wp.pageview_url = "/billing-2" then 1 else 0 end as billing_page,
case when  wp.pageview_url = "/thank-you-for-your-order" then 1 else 0 end as thank_you_page
from base_products_table as bp
left join website_pageviews as wp on wp.website_session_id = bp.website_session_id
and wp.website_pageview_id > bp.website_pageview_id) as pageview_level
group by website_session_id,
case 
	when product_name = '/the-original-mr-fuzzy' then "mrfuzzy"
	when product_name =  "/the-forever-love-bear" then "lovebear"
    end;

-- step4: create the session level conversion funnel:

select product_seen,
count(distinct website_session_id) as sessions,
count(distinct case when clicked_to_cart=1 then website_session_id else null end) as to_cart,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end) as to_shipping,
count(distinct case when clicked_to_billing=1 then website_session_id else null end) as to_billing,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end) as to_thank_you
from base_session_level
group by product_seen;

-- step5: display clickthrough rates for each step:

select 
 product_seen,
count(website_session_id) as session_count,
count(distinct case when clicked_to_cart=1 then website_session_id else null end)/count(website_session_id)
	as product_to_cart_clickthrough_rate,
count(distinct case when clicked_to_shipping=1 then website_session_id else null end)/count(distinct case when clicked_to_cart=1 then website_session_id else null end)
	as cart_to_shipping_clickthrough_rate,
count(distinct case when clicked_to_billing=1 then website_session_id else null end)/count(distinct case when clicked_to_shipping=1 then website_session_id else null end)
	as shipping_to_billing_clickthrough_rate,
count(distinct case when clicked_to_thank_you=1 then website_session_id else null end)/count(distinct case when clicked_to_billing=1 then website_session_id else null end)
	as billing_to_thank_you_clickthrough_rate
from base_session_level
group by product_seen;
