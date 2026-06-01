--Расчет маржинальности каждого букета/Calculating the marginality of each bouquet

with flower_avg_price as (
    select flower_id, avg(purchase_price) as avg_flower_price
    from supplier_prices 
    group by 1 
),
bouquet_cost as (
    select 
        bc.bouquet_id,
        b.bouquet_name,
        b.bouquet_category,
        b.retail_price,
        sum(fap.avg_flower_price * bc.stems_count) as bouquet_cost
    from bouquet_composition bc 
        inner join flower_avg_price fap on fap.flower_id = bc.flower_id
        inner join bouquets b on bc.bouquet_id = b.bouquet_id
    group by 1,2,3,4
 ) 
select 
    bouquet_id,
    bouquet_name,
    bouquet_category,
    retail_price,
    round(bouquet_cost) as bouquet_cost,
    round((retail_price - bouquet_cost), 2) as margin,
    round(((retail_price - bouquet_cost)/retail_price) * 100) as margin_part
from bouquet_cost
order by margin_part desc;

--Расчет маржинальности категории букетов/Calculation of the marginality of the bouquet category

with flower_avg_price as (
    select flower_id, avg(purchase_price) as avg_flower_price
    from supplier_prices 
    group by 1 
),
bouquet_cost as (
    select 
        bc.bouquet_id,
        b.bouquet_name,
        b.bouquet_category,
        b.retail_price,
        sum(fap.avg_flower_price * bc.stems_count) as bouquet_cost
    from bouquet_composition bc 
        inner join flower_avg_price fap on fap.flower_id = bc.flower_id
        inner join bouquets b on bc.bouquet_id = b.bouquet_id
    group by 1,2,3,4
 ) 
select 
    bouquet_category,
    count(bouquet_id) as bouquets_count,
    round(avg(retail_price), 2) as avg_retail_price,
    round(avg(bouquet_cost), 2) as avg_bouquet_cost,
    round(avg(retail_price - bouquet_cost), 2) as avg_margin,
    round(avg((retail_price - bouquet_cost)/retail_price) * 100)  as avg_margin_part
from bouquet_cost
group by 1
order by avg_margin_part desc;

--Расчет фактической прибыли по букетам/Calculation of the actual profit from the sale of bouquets

with flower_avg_price as (
    select flower_id, avg(purchase_price) as avg_flower_price
    from supplier_prices 
    group by 1 
),
bouquet_cost as (
    select 
        bc.bouquet_id,
        b.bouquet_name,
        b.bouquet_category,
        b.retail_price,
        sum(fap.avg_flower_price * bc.stems_count) as bouquet_cost
    from bouquet_composition bc 
        inner join flower_avg_price fap on fap.flower_id = bc.flower_id
        inner join bouquets b on bc.bouquet_id = b.bouquet_id
    group by 1,2,3,4
 ),
 sales_by_bouquet as (
     select
         oi.bouquet_id,
         sum(oi.quantity) as bouquet_count,
         sum(oi.quantity * oi.unit_price) as revenue
     from order_items oi 
         inner join orders o on o.order_id = oi.order_id
     where o.status = 'completed'
     group by 1
 )  
select 
    bc.bouquet_name,
    bc.bouquet_category,
    sb.bouquet_count,
    round(sb.revenue, 2) as revenue,
    round(bc.bouquet_cost, 2) as bouquet_cost,
    round(bc.retail_price - bc.bouquet_cost, 2) as bouquet_margin,
    round(sb.bouquet_count * bc.bouquet_cost, 2) as total_cost,
    round(sb.revenue - sb.bouquet_count * bc.bouquet_cost, 2) as total_profit,
    round((sb.revenue - sb.bouquet_count * bc.bouquet_cost/sb.revenue) * 100, 2) as actual_margin_rate
from sales_by_bouquet sb
    inner join bouquet_cost bc on bc.bouquet_id = sb.bouquet_id
order by actual_margin_rate desc;

--Популярные но низкомаржинальные букеты/Popular but low-margin bouquets

with flower_avg_price as (
    select flower_id, avg(purchase_price) as avg_flower_price
    from supplier_prices 
    group by 1 
),
bouquet_cost as (
    select 
        bc.bouquet_id,
        b.bouquet_name,
        b.bouquet_category,
        b.retail_price,
        sum(fap.avg_flower_price * bc.stems_count) as bouquet_cost
    from bouquet_composition bc 
        inner join flower_avg_price fap on fap.flower_id = bc.flower_id
        inner join bouquets b on bc.bouquet_id = b.bouquet_id
    group by 1,2,3,4
 ),
 sales_by_bouquet as (
     select
         oi.bouquet_id,
         sum(oi.quantity) as bouquet_count,
         sum(oi.quantity * oi.unit_price) as revenue
     from order_items oi 
         inner join orders o on o.order_id = oi.order_id
     where o.status = 'completed'
     group by 1
 )  
select 
    bc.bouquet_name,
    bc.bouquet_category,
    sb.bouquet_count,
    round(((sb.revenue - sb.bouquet_count * bc.bouquet_cost)/sb.revenue) * 100, 2) as actual_margin_rate
from sales_by_bouquet sb
    inner join bouquet_cost bc on bc.bouquet_id = sb.bouquet_id
order by sb.bouquet_count desc, actual_margin_rate;

--Непопулярные но высокомаржинальные букеты/Unpopular but high-margin bouquets

with flower_avg_price as (
    select flower_id, avg(purchase_price) as avg_flower_price
    from supplier_prices 
    group by 1 
),
bouquet_cost as (
    select 
        bc.bouquet_id,
        b.bouquet_name,
        b.bouquet_category,
        b.retail_price,
        sum(fap.avg_flower_price * bc.stems_count) as bouquet_cost
    from bouquet_composition bc 
        inner join flower_avg_price fap on fap.flower_id = bc.flower_id
        inner join bouquets b on bc.bouquet_id = b.bouquet_id
    group by 1,2,3,4
 ),
 sales_by_bouquet as (
     select
         oi.bouquet_id,
         sum(oi.quantity) as bouquet_count,
         sum(oi.quantity * oi.unit_price) as revenue
     from order_items oi 
         inner join orders o on o.order_id = oi.order_id
     where o.status = 'completed'
     group by 1
 )  
select 
    bc.bouquet_name,
    bc.bouquet_category,
    coalesce(sb.bouquet_count, 0) as bouquet_count,
    coalesce(round(sb.revenue, 2), 0) as revenue,
    round(bc.retail_price, 2) as retail_price,
    round(bc.bouquet_cost, 2) as bouquet_cost,
    round(bc.retail_price - bc.bouquet_cost, 2) as unit_margin,
    round(((bc.retail_price - bc.bouquet_cost) / bc.retail_price) *100) as unit_margin_rate  
from bouquet_cost bc
    left join sales_by_bouquet sb on bc.bouquet_id = sb.bouquet_id
where coalesce(sb.bouquet_count, 0) < 100 and (bc.retail_price - bc.bouquet_cost) / bc.retail_price >= 0.6
order by unit_margin_rate desc, bouquet_count;
