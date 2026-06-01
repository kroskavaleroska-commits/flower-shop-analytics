-- Расчет общей суммы заказа и количества цветов у разных поставщиков. У какого поставщика магазин закупает больше всего и по какой средней цене?/
--Calculation of the total order amount and the number of colors from different suppliers. Which supplier does the store buy the most from and at what average price?

select 
    supplier_name, 
    count(distinct p.flower_id) as unique_flowers_count, --сколько уникальных цветов поставляет поставщик
    sum(p.quantity_stems) as total_stems_purchased, --сколько стеблей закупили
    sum(total_purchase_amount) as total_sum_purchases, --общая сумма закупки
    round(sum(p.total_purchase_amount) / sum(p.quantity_stems), 2) as avg_purchase_price_per_stem --средняя цена за стебель
from suppliers s 
    inner join purchases p on s.supplier_id = p.supplier_id
group by 1
order by 2 desc;

--Доля закупки каждого поставщика/Purchase share of each supplier

select 
    supplier_name, 
    sum(p.quantity_stems) as total_stems_purchased, --сколько стеблей закупили
    sum(total_purchase_amount) as total_sum_purchases, --общая сумма закупки
    round((sum(total_purchase_amount)/sum(sum(total_purchase_amount)) over ()) * 100) as purchase_amount_share, --доля суммы закупки
    round((sum(p.quantity_stems)::numeric/sum(sum(p.quantity_stems)) over()) * 100) as stems_share --доля количества стеблей 
from suppliers s 
    inner join purchases p on s.supplier_id = p.supplier_id
group by 1
order by purchase_amount_share desc;

--Наибольшая и наименьшая цена по каждому цветку у каждого поставщика/Each supplier has the highest and lowest price for each flower

with data_price as (
	select f.flower_name, sp.purchase_price, s.supplier_name,
	rank() over(partition by f.flower_name order by sp.purchase_price desc) as rank_max,
	rank() over(partition by f.flower_name order by sp.purchase_price asc) as rank_min
	from supplier_prices sp 
	left join suppliers s on s.supplier_id = sp.supplier_id 
	left join flowers f on f.flower_id = sp.flower_id 
)
select flower_name,
max(case when rank_max = 1 then purchase_price end ) as max_price,
string_agg(case when rank_max = 1 then supplier_name end, ' / ') as max_supplier,
max(case when rank_min = 1 then purchase_price end ) as min_price,
string_agg(case when rank_min = 1 then supplier_name end, ' / ') as min_supplier
from data_price
group by flower_name
order by max_price desc;

--Как изменялась цена в разные месяцы?/How did the price change in different months?

select
    date_trunc('month', p.purchase_date)::date as month,
    s.supplier_name,
    round(sum(p.total_purchase_amount) / sum(p.quantity_stems),2) as avg_purchase_price_per_stem
from purchases p
inner join suppliers s
    on p.supplier_id = s.supplier_id
group by 1, 2
order by 1;


--Доля списаний по поставщикам/Percentage of write-offs by supplier
    
with count_of_write_off as( 
	select 
	    supplier_id,
	    count(write_off_id) as count_of_write_off, --количество списаний
	    sum(quantity_stems) as count_of_stems_write_off --количество списанных стеблей
	from write_offs 
	group by 1	
),
total_sum_purchases as (
	select 
	    p.supplier_id, 
	    sum(quantity_stems) as total_stems_purchased, --сколько стеблей закупили
	    sum(total_purchase_amount) as total_sum_purchases, --общая сумма закупки
	    sum(total_purchase_amount)::numeric / nullif(sum(quantity_stems), 0) as avg_price_per_stem, --средняя цена за стебель
        round((sum(count_of_stems_write_off * purchase_price_per_stem)/sum(total_purchase_amount)),4) as sum_write_off_share --доля списаний в рублях
	from purchases p 
	    inner join count_of_write_off cof on p.supplier_id = cof.supplier_id
	group by 1
)
select 
    supplier_name,
    supplier_type,
    total_stems_purchased, --сколько стеблей закупили
    total_sum_purchases, -- на какую сумму закупили
    count_of_stems_write_off, --количество списанных стеблей
    round(coalesce(count_of_stems_write_off, 0) * avg_price_per_stem) as sum_write_off_share, --сумма списаний
    round(((coalesce(count_of_stems_write_off, 0)::numeric)/total_stems_purchased), 4) as count_write_off_share --доля списаний в количестве стеблей
from total_sum_purchases tsp
    inner join suppliers s on tsp.supplier_id = s.supplier_id
    left join count_of_write_off cow on cow.supplier_id = tsp.supplier_id
order by count_write_off_share desc;

--Итоговая таблица сравнения поставщиков/Final supplier comparison table

with count_of_write_off as( 
	select 
	    supplier_id,
	    sum(quantity_stems) as count_of_stems_write_off --количество списанных стеблей
	from write_offs 
	group by 1	
),
total_sum_purchases as (
	select 
	    p.supplier_id, 
	    count(purchase_id) as purchases_count, --количество заказов
	    count(distinct flower_id) as unique_flowers_count,
	    sum(quantity_stems) as total_stems_purchased, --сколько стеблей закупили
	    sum(total_purchase_amount) as total_sum_purchases, --общая сумма закупки
	    sum(total_purchase_amount)::numeric / nullif(sum(quantity_stems), 0) as avg_price_per_stem, --средняя цена за стебель
        round((sum(count_of_stems_write_off * purchase_price_per_stem)/sum(total_purchase_amount)),4) as sum_write_off_share --доля списаний в рублях
	from purchases p 
	    inner join count_of_write_off cof on p.supplier_id = cof.supplier_id
	group by 1
)
select 
    supplier_name,
    supplier_type,
    city,
    avg_delivery_days,
    payment_terms,
    purchases_count, --количество заказов
    unique_flowers_count, --количетво уникальных позиций
    total_stems_purchased, --сколько стеблей закупили
    total_sum_purchases, -- на какую сумму закупили
    round(avg_price_per_stem, 2) as avg_price_per_stem, 
    count_of_stems_write_off, --количество списанных стеблей
    round(((coalesce(count_of_stems_write_off, 0)::numeric)/total_stems_purchased), 4) as count_write_off_share --доля списаний в количестве стеблей
from total_sum_purchases tsp
    inner join suppliers s on tsp.supplier_id = s.supplier_id
    left join count_of_write_off cow on cow.supplier_id = tsp.supplier_id
order by count_write_off_share, avg_price_per_stem;