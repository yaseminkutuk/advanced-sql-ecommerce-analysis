-- 	2. Finding Top Entry Pages

-- Business Question:
-- Could you get a list of the top entry pages?
-- Rank them on entry volume.
-- Request date: 2012-06-12

-- step 1.finding the first website pageview ids:
create temporary table first_entry_ids
select min(website_pageview_id) as min_pv_id,
website_session_id
from website_pageviews
where created_at < "2012-06-12"
group by website_session_id;

-- step 2.finding the landing pages and total count of sessions for every landing page:
select wp.pageview_url as landing_page,
count(distinct f.website_session_id) as sessions
from first_entry_ids as f
left join website_pageviews as wp on f.min_pv_id = wp.website_pageview_id
group by wp.pageview_url
order by count(f.website_session_id) desc;
