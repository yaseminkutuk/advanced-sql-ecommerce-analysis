-- 	1. Analyzing Top Traffic Sources

-- 	Business Question:

-- Where is the majority of website traffic coming from?
-- Break down sessions by UTM source, campaign, and referring domain.
-- Analysis date: 2012-04-12

select utm_source, utm_campaign, http_referer, count(*) as sessions
from website_sessions
where created_at < "2012-04-12"
group by utm_source, utm_campaign, http_referer
order by sessions desc;
