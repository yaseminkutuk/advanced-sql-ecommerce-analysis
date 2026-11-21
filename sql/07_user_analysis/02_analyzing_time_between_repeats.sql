-- 	2. Analyzing time to repeat

-- 	Business Question:
-- Could you get the min, max, and average time between the first and second session for customers wo come back?
-- 2014 to date is good.
-- Analysis date: 2014-11-03.

create temporary table repeated_sessions
select new_sessions.user_id, 
new_sessions.website_session_id as new_session_id,
ws.website_session_id as repeated_session_id,
new_sessions.first_visit_time as first_visit_time,
ws.created_at as repeat_visit_time
from 
(SELECT user_id, 
website_session_id,
created_at as first_visit_time
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

select 
user_id,
new_session_id,
first_visit_time,
min(repeated_session_id) as second_visit_id,
min(repeat_visit_time) as second_visit_time
from repeated_sessions
where repeated_session_id is not null
group by 1,2,3;

create temporary table first_and_second_sessions_time_interval
select user_id,
datediff(second_visit_time,first_visit_time) as time_between
from
(select 
user_id,
new_session_id,
first_visit_time,
min(repeated_session_id) as second_visit_id,
min(repeat_visit_time) as second_visit_time
from repeated_sessions
where repeated_session_id is not null
group by user_id,
new_session_id,
first_visit_time) as first_second;

select 
avg(time_between) as average_day_between_second_and_first_visit,
min(time_between) as min_day_between_second_and_first_visit,
max(time_between) as max_day_between_second_and_first_visit
from first_and_second_sessions_time_interval;
