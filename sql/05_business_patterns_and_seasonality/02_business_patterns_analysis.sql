-- 	2. Analyzing  Business Patterns

-- 	Business Question:
-- Could you analyze the average website session volume by hour of day and by day week?
-- Let's avoid the holiday time period and use a date range of September 15 - November 15 2012.

select 
hour,
round(avg(sessions),1),
round(avg(case when day = 0 then sessions else null end),1) as monday,
round(avg(case when day = 1 then sessions else null end),1) as tuesday,
round(avg(case when day = 2 then sessions else null end),1) as wednesday,
round(avg(case when day = 3 then sessions else null end),1) as thursday,
round(avg(case when day = 4 then sessions else null end),1) as friday,
round(avg(case when day = 5 then sessions else null end),1) as saturday,
round(avg(case when day = 6 then sessions else null end),1) as sunday
from (
select
date(created_at) AS date,
weekday(created_at) as day,
hour(created_at) AS hour,
count(distinct website_session_id) as sessions
from website_sessions
where created_at between "2012-09-15" and "2012-11-15"
group by 1,2,3
) as daily_hourly
group by 1
order by hour;
