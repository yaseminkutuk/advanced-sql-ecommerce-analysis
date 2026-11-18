
-- 7. Product Refund Analysis

-- 	Business Question:
-- Our Mr. Fuzzy supplier had some quality issues which weren't corrected until September 2013. 
-- Then they had a major problem where the bears' arms were falling off in Aug/Sep 2014. 
-- As a result, we replaced them with a new supplier on September 16, 2014.
-- Can you please pull monthly product refund rates, by product, and confirm our quality issues are now fixed?
-- Analysis date: 2014-10-15.

select 
year(o.created_at) AS year,
month(o.created_at) as month,
count(distinct case when o.product_id = 1 then o.order_item_id else NULL end) as product1_orders,
count(distinct case when o.product_id = 1 then r.order_item_refund_id else NULL end)
	/count(distinct case when o.product_id = 1 then o.order_item_id else NULL end) as product1_refund_rate,
    
count(distinct case when o.product_id = 2 then o.order_item_id else NULL end) as product2_orders,
count(distinct case when o.product_id = 2 then r.order_item_refund_id else NULL end)
	/count(distinct case when o.product_id = 2 then o.order_item_id else NULL end) as product2_refund_rate,
    
count(distinct case when o.product_id = 3 then o.order_item_id else NULL end) as product3_orders,
count(distinct case when o.product_id = 3 then r.order_item_refund_id else NULL end)
	/count(distinct case when o.product_id = 3 then o.order_item_id else NULL end) as product3_refund_rate,
    
count(distinct case when o.product_id = 4 then o.order_item_id else NULL end) as product4_orders,
count(distinct case when o.product_id = 4 then r.order_item_refund_id else NULL end)
	/count(distinct case when o.product_id = 4 then o.order_item_id else NULL end) as product4_refund_rate
    
from order_items as o
left join order_item_refunds as r
	on o.order_item_id = r.order_item_id
where o.created_at < "2014-10-15"
group by year(o.created_at), month(o.created_at);
