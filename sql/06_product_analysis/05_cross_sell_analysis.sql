-- 5. Cross Sell Analysis

-- 	Business Question:
-- On September 25th we started giving customers the option to add a 2nd product while on the /cart page.
-- Could you please compare the month before vs the month after the change? 
-- I'd like to see CTR from the /cart page, Avg Products per Order, AOV, and overal revenue per /cart page view.
-- Analysis date: 2013-11-22.

-- step1. adjusting the time period for /cart page.

create temporary table cross_sell_time_period
select website_session_id,
website_pageview_id,
created_at,
case 
	when created_at < "2013-09-25" then "Pre-Cross-Sell"
    when created_at >="2013-09-25" then "Post-Cross-Sell"
    end as time_period
from website_pageviews 
where created_at > "2013-08-25" 
and  created_at  < "2013-10-25"
and pageview_url = '/cart';

-- step2. displaying the pageview urls to look for

select distinct wp.pageview_url
from cross_sell_time_period as cs
left join website_pageviews as wp
on cs.website_session_id = wp.website_session_id
and wp.website_pageview_id > cs.website_pageview_id;

-- step3: identify funnel step

create temporary table base_session_level_cart
select website_session_id,
time_period,
max(shipping_page) as clicked_to_shipping
from 
(select cs.website_session_id, 
cs.time_period,
case when  wp.pageview_url = "/shipping" then 1 else 0 end as shipping_page
from cross_sell_time_period as cs
left join website_pageviews as wp on wp.website_session_id = cs.website_session_id
and wp.website_pageview_id > cs.website_pageview_id) as pageview_level
group by website_session_id,time_period;

-- step4: display results joining orders table

select 
b.time_period,
count(distinct b.website_session_id) as cart_session_count,
count(distinct case when b.clicked_to_shipping=1 then b.website_session_id else null end) as to_shipping,
count(distinct case when b.clicked_to_shipping=1 then b.website_session_id else null end)/count(distinct b.website_session_id)
	as cart_to_shipping_clickthrough_rate,
sum(o.items_purchased)/count(distinct o.order_id) as products_per_order,
sum(o.price_usd)/count(distinct o.order_id)  AS aov,
sum(o.price_usd)/count(distinct b.website_session_id) as rev_per_session
from base_session_level_cart as b
left join orders as o on o.website_session_id = b.website_session_id
group by b.time_period;
