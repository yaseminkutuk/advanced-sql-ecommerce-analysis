-- 	1. Finding Top Website Pages

-- Business Question:
-- Could you get most-viewed webpages, ranked by session volume?
-- Request date: 2012-06-09

select pageview_url,
count(distinct website_session_id) as sessions
from website_pageviews
where created_at < "2012-06-09"
group by pageview_url
order by count(website_session_id) desc;
