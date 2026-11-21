-- 	4. Analyzing repeat channel behavior

-- 	Business Question:
-- I'd like to see a comparison of conversion rates and revenue per session for repeat sessions vs new sessions.
-- 2014 to date is good.
-- Analysis date: 2014-11-8.

SELECT
ws.is_repeat_session,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id)/count(distinct ws.website_session_id) as conv_rate,
sum(price_usd)/count(distinct ws.website_session_id) as revenue_per_session
FROM website_sessions as ws
left join orders as o on o.website_session_id = ws.website_session_id
WHERE ws.created_at < '2014-11-08'
and ws.created_at >= '2014-01-01'
group by ws.is_repeat_session
