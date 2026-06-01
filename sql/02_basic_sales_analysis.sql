--Расчет выручки по месяцам, количества заказов и средний чек за месяц/Calculation of revenue by month, number of orders, and average check per month

select 
    date_trunc('month', o.order_date)::date AS month,
    sum(oi.quantity * oi.unit_price) as revenue, 
    count (distinct o.order_id) as order_count,
    round(sum(oi.quantity * oi.unit_price)/count(distinct oi.quantity)) as avg_order_value_by_month
from orders o 
    inner join order_items oi 
    on o.order_id = oi.order_id
where o.status = 'completed'
group by 1
order by 1;

--Топ 10 самых популярных позиций по количеству заказов/Top 10 most popular items by number of orders

select 
    oi.bouquet_id, 
    b.bouquet_name,
    b.retail_price, 
    sum(oi.quantity) as bouquet_count, 
    sum(oi.quantity * oi.unit_price) as revenue
from bouquets b
    inner join order_items oi on b.bouquet_id = oi.bouquet_id
    inner join orders o on o.order_id = oi.order_id
where o.status = 'completed'
group by 1, 2, 3
order by 4 desc
limit 10;

--Топ 10 самых популярных позиций по сумме выручки/Top 10 most popular items by revenue

select 
    oi.bouquet_id, 
    b.bouquet_name,
    b.retail_price, 
    sum(oi.quantity * oi.unit_price) as revenue,
    sum(oi.quantity) as bouquet_count
from bouquets b
    inner join order_items oi on b.bouquet_id = oi.bouquet_id
    inner join orders o on o.order_id = oi.order_id
where o.status = 'completed'
group by 1, 2, 3
order by 4 desc
limit 10;

--Сравнение двух типов каналов заказов (онлайн и офлайн)/Comparison of two types of order channels (online and offline)

select 
    o.sales_channel, 
    count(distinct o.order_id) as orders_count,
    sum(oi.quantity) as bouquets_count,
    sum(oi.quantity * oi.unit_price) as revenue,
    round(sum(oi.quantity * oi.unit_price) / count(distinct o.order_id), 2) AS avg_order_value,
    round(sum(oi.quantity * oi.unit_price)/sum(sum(oi.quantity * oi.unit_price)) over () * 100, 2) as revenue_share
from orders o
    inner join order_items oi
    on o.order_id = oi.order_id
where o.status = 'completed'
group by 1
ORDER BY revenue DESC;

--Расчет количества отмененных заказов по каждому каналу/Calculating the number of canceled orders for each channel

select 
    date_trunc('month', o.order_date)::date AS month,
    o.sales_channel,
    count(distinct o.order_id) as total_orders,
    count(distinct case when status = 'cancelled' then o.order_id end) as cancelled_count,
    round(count(distinct case when status = 'cancelled' then o.order_id end)::numeric / count(distinct o.order_id)  * 100, 2) as cancelled_share
from orders o
group by 1, 2
order by 1, cancelled_count desc;