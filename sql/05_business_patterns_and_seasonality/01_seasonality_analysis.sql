-- 	1. Analyzing Seasonality

-- 	Business Question:
-- we should take a look at 2012'S monthly and weekly volume patterns.
-- if you can pull session volume and order volume.
-- Analysis date: 2013-01-02.

-- monthly:
select 
year(ws.created_at) AS year,
month(ws.created_at) as month,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders
from website_sessions ws
left join orders o on o.website_session_id = ws.website_session_id
where ws.created_at < "2013-01-01"
group by year(ws.created_at), month(ws.created_at);

-- weekly:
select 
year(ws.created_at) AS year,
week(ws.created_at) as week,
min(date(ws.created_at)) as week_start_date,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders
from website_sessions ws
left join orders o on o.website_session_id = ws.website_session_id
where ws.created_at < "2013-01-01"
group by year(ws.created_at), week(ws.created_at);
