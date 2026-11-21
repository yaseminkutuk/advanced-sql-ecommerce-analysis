-- 	1. Repeat Visitor Analysis

-- 	Business Question:
-- Could you please pull data on how many of our website visitors come back for another session? 2014 to date is good.
-- Analysis date: 2014-11-01.

create temporary table repeated_session
select new_sessions.user_id, 
new_sessions.website_session_id as new_session_id,
ws.website_session_id as repeated_session_id
from 
(SELECT user_id, 
website_session_id
FROM website_sessions
where created_at < '2014-11-01'
and created_at >= '2014-01-01'
and is_repeat_session = 0
) as new_sessions
left join website_sessions as ws on ws.user_id = new_sessions.user_id
and ws.website_session_id > new_sessions.website_session_id
and ws.is_repeat_session = 1
and ws.created_at < '2014-11-01'
and ws.created_at >= '2014-01-01';

select user_id,
 count(new_session_id) as new_sessions,
 count(repeated_session_id) as repeated_sessions
from repeated_session
group by user_id;

select repeated_sessions,
count(distinct user_id) as users
from
(
select user_id,
 count(new_session_id) as new_sessions,
 count(repeated_session_id) as repeated_sessions
from repeated_session
group by user_id
)as users
group by 1;
