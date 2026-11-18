-- 6. Product Portfolio Expansion Analysis

-- 	Business Question:
-- On December 12th 2013, we launched a third product targeting the birthday gift market (Birthday Bear).
-- Could you please run a pre-post analysis comparing the month before vs. the month after, 
-- in terms of session-to-order conversion rate, AOV, products per order, and revenue per session?
-- Analysis date: 2014-01-12.

-- solution1:

create temporary table expansion_time_period
select website_session_id,
created_at,
case 
	when created_at < "2013-12-12" then "Pre-Birthday_Bear"
    when created_at >="2013-12-12" then "Post-Birthday_Bear"
    ELSE 'check logic'
    end as time_period
from website_sessions
where created_at > "2013-11-12" 
and  created_at  < "2014-01-12";

select 
e.time_period,
count(distinct o.order_id)/count(distinct e.website_session_id) conv_rate,
sum(o.price_usd)/count(distinct o.order_id)  AS aov,
sum(o.items_purchased)/count(distinct o.order_id) as products_per_order,
sum(o.price_usd)/count(distinct e.website_session_id) as rev_per_session
from expansion_time_period as e
left join orders as o on o.website_session_id = e.website_session_id
group by e.time_period;

-- solution2:
SELECT
CASE
	WHEN ws.created_at < '2013-12-12' THEN 'Pre_Birthday_Bear' 
	WHEN ws.created_at >= '2013-12-12' THEN 'Post_Birthday_Bear'
    ELSE 'check logic'
END AS time_period,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conv_rate,
SUM(o.price_usd)/COUNT(DISTINCT o.order_id) AS aov,
SUM(o.items_purchased)/COUNT(DISTINCT o.order_id) AS products_per_order,
SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session
FROM website_sessions as ws
LEFT JOIN orders as o
ON o.website_session_id = ws.website_session_id
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1;
