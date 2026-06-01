--Расчет выручки по месяцам/Calculation of revenue by month

select 
    extract(year from order_date) as year,
    extract(month from order_date) as month_number,
    case 
    	when extract(month from order_date) = 1 then 'January'
    	when extract(month from order_date) = 2 then 'February'
    	when extract(month from order_date) = 3 then 'March'
    	when extract(month from order_date) = 4 then 'April'
    	when extract(month from order_date) = 5 then 'May'
    	when extract(month from order_date) = 6 then 'June'
    	when extract(month from order_date) = 7 then 'July'
    	when extract(month from order_date) = 8 then 'August'
    	when extract(month from order_date) = 9 then 'September'
    	when extract(month from order_date) = 10 then 'October'
    	when extract(month from order_date) = 11 then 'November'
    	when extract(month from order_date) = 12 then 'December' 
    end as month_name,
    count(distinct oi.order_id) as count_order, --количество заказов
    count(quantity) as bouquet_count, --количество букетов
    sum(quantity * unit_price) as revenue, --выручка по месяцам
    round(sum(quantity * unit_price)/count(distinct oi.order_id), 2) as avg_order_value -- средняя цена за заказ
from orders o 
inner join order_items oi on o.order_id = oi.order_id
where status = 'completed'
group by 1, 2
order by 1, 2;

--Сезонный индекс спроса по месяцам/Seasonal demand index by month

with revenue_by_month as (
	select 
		extract(year from order_date) as year,
    	extract(month from order_date) as month_number,
    	sum(oi.quantity * oi.unit_price) as revenue --выручка по месяцам за 2 года
	from orders o 
	inner join order_items oi on o.order_id = oi.order_id
	where status = 'completed'
	group by 1, 2
	order by 1, 2
),
avg_revenue_by_month as (
	select 
		month_number,
		avg(revenue) as avg_revenue_by_month -- средняя выручка за месяц
	from revenue_by_month
	group by 1
)
select 
    month_number,
    case 
    	when month_number = 1 then 'January'
    	when month_number = 2 then 'February'
    	when month_number = 3 then 'March'
    	when month_number = 4 then 'April'
    	when month_number = 5 then 'May'
    	when month_number = 6 then 'June'
    	when month_number = 7 then 'July'
    	when month_number = 8 then 'August'
    	when month_number = 9 then 'September'
    	when month_number = 10 then 'October'
    	when month_number = 11 then 'November'
    	when month_number = 12 then 'December' 
    end as month_name,
    round(avg_revenue_by_month) as avg_revenue_by_month,
    round(avg(avg_revenue_by_month) over ()) as overall_revenue, 
    round(avg_revenue_by_month/avg(avg_revenue_by_month) over (), 2) as seasonality_index
from avg_revenue_by_month
order by 1; 	

--Сравнение выручки 2023 и 2024 года/Comparison of revenue in 2023 and 2024

with revenue_2023 as (
	select 
	    extract(month from order_date) as month_number,
	    sum(quantity * unit_price) as revenue_2023
	from orders o 
	inner join order_items oi on o.order_id = oi.order_id
	where status = 'completed' and extract(year from order_date) = 2023
	group by 1    
),	
revenue_2024 as (
	select 
	    extract(month from order_date) as month_number,
	    sum(quantity * unit_price) as revenue_2024
	from orders o 
	inner join order_items oi on o.order_id = oi.order_id
	where status = 'completed' and extract(year from order_date) = 2024
	group by 1    
)		
select 
    r23.month_number,
    case 
    	when r23.month_number = 1 then 'January'
    	when r23.month_number = 2 then 'February'
    	when r23.month_number = 3 then 'March'
    	when r23.month_number = 4 then 'April'
    	when r23.month_number = 5 then 'May'
    	when r23.month_number = 6 then 'June'
    	when r23.month_number = 7 then 'July'
    	when r23.month_number = 8 then 'August'
    	when r23.month_number = 9 then 'September'
    	when r23.month_number = 10 then 'October'
    	when r23.month_number = 11 then 'November'
    	when r23.month_number = 12 then 'December' 
    end as month_name,
    revenue_2023,
    revenue_2024,
    round((revenue_2024 - revenue_2023)/revenue_2023, 4) as revenue_growth_rate
 from revenue_2023 r23
 inner join revenue_2024 r24 on r23.month_number = r24.month_number
 order by 1;

 --Расчет выручки в зависимости от типа события/Revenue calculation depending on the type of event

 select 
	event_type,
	count(distinct o.order_id) as order_count, --количество заказов
	sum(quantity) as bouquet_count, -- количесвто букетов
	sum(quantity * unit_price) as revenue_by_event, --выручка
	round(sum(quantity * unit_price)/count(distinct o.order_id), 2) as avg_price_by_order, --средняя цена заказа
	round(sum(quantity * unit_price)/sum(sum(quantity * unit_price)) over (), 2) as revenue_share
from orders o
inner join order_items oi on o.order_id = oi.order_id
where status = 'completed'
group by 1
order by revenue_share desc;

--Расчет выручки по праздникам/Calculation of revenue on holidays

select 
	extract(year from o.order_date) as year,
	case
        when to_char(o.order_date, 'MM-DD') between '02-13' and '02-14' then '14 февраля'
        when to_char(o.order_date, 'MM-DD') between '03-05' and '03-08' then '8 марта'
        when to_char(o.order_date, 'MM-DD') between '08-31' and '09-01' then '1 сентября'
        when to_char(o.order_date, 'MM-DD') between '12-20' and '12-31' then 'Новый год'
        else 'Обычный период'
    end as period_name,
    count(distinct o.order_id) as order_count, --количество заказов
    sum(quantity) as bouquet_count, -- количество букетов
	sum(quantity * unit_price) as revenue_by_period, --выручка
	round(sum(quantity * unit_price)/count(distinct o.order_id), 2) as avg_price_by_order --средняя цена заказа
from orders o
inner join order_items oi on o.order_id = oi.order_id
where status = 'completed'
group by 1, 2
order by 1, 5 desc;

--Как меняется выручка в течении недели?How revenue changes during the week?

with week_day_revenue as (
	select 
		extract(week from order_date) as week,
		extract(isodow from order_date) as day,
		to_char(order_date, 'Day') as day_of_week,
	    count(distinct o.order_id) as order_count, --количество заказов
	    sum(quantity) as bouquet_count, -- количество букетов
		sum(quantity * unit_price) as revenue_by_period, --выручка
		round(sum(quantity * unit_price)/count(distinct o.order_id), 2) as avg_price_by_order --средняя цена заказа
	from orders o
	inner join order_items oi on o.order_id = oi.order_id
	where status = 'completed' and extract(year from o.order_date) = 2024 and case
	        when to_char(o.order_date, 'MM-DD') between '02-13' and '02-14' then '14 февраля'
	        when to_char(o.order_date, 'MM-DD') between '03-05' and '03-08' then '8 марта'
	        when to_char(o.order_date, 'MM-DD') between '08-31' and '09-01' then '1 сентября'
	        when to_char(o.order_date, 'MM-DD') between '12-20' and '12-31' then 'Новый год'
	        else 'Обычный период'
	    end = 'Обычный период'
	group by 1, 2, 3
)
select
    day_of_week,
	round(avg(order_count)) as avg_order_count,
	round(avg(bouquet_count)) as avg_bouquet_count,
	round(avg(revenue_by_period), 2) as avg_revenue_by_period
from week_day_revenue
group by 1
order by 4 desc;

--Определение сезонности цветка/Determining the seasonality of a flower

with season_type as (
	select 
		 flower_name,
		 case 
		 	when extract(month from o.order_date) in (12, 1, 2) then 'winter'
		 	when extract(month from o.order_date) in (3, 4, 5) then 'spring'
		 	when extract(month from o.order_date) in (6, 7, 8) then 'summer'
		 	when extract(month from o.order_date) in (9, 10, 11) then 'autumn'
		 end,
		 sum(stems_count * quantity) as stems_count
	from flowers f
	inner join bouquet_composition bc on f.flower_id = bc.flower_id
	inner join order_items oi on bc.bouquet_id = oi.bouquet_id
	inner join orders o on oi.order_id = o.order_id
	where o.status = 'completed'
	group by 1, 2 
),
for_rank as (
	select sp.*,
	rank() over(partition by flower_name order by stems_count desc) as flower_season_rank
	from season_type sp
)
select *
from for_rank
where flower_season_rank = 1;

--Топ букетов в праздники/Top bouquets for the holidays

select 
	case
        when to_char(o.order_date, 'MM-DD') between '02-13' and '02-14' then '14 февраля'
        when to_char(o.order_date, 'MM-DD') between '03-05' and '03-08' then '8 марта'
        when to_char(o.order_date, 'MM-DD') between '08-31' and '09-01' then '1 сентября'
        when to_char(o.order_date, 'MM-DD') between '12-20' and '12-31' then 'Новый год'
        else 'Обычный период'
    end as period_name,
    bouquet_name,
    sum(oi.quantity) as count_bouquet,
	sum(oi.quantity * oi.unit_price) as bouquet_revenue
from order_items oi 
inner join orders o on oi.order_id = o.order_id
inner join bouquets b on oi.bouquet_id = b.bouquet_id
where case
        when to_char(o.order_date, 'MM-DD') between '02-13' and '02-14' then '14 февраля'
        when to_char(o.order_date, 'MM-DD') between '03-05' and '03-08' then '8 марта'
        when to_char(o.order_date, 'MM-DD') between '08-31' and '09-01' then '1 сентября'
        when to_char(o.order_date, 'MM-DD') between '12-20' and '12-31' then 'Новый год'
        else 'Обычный период'
    end != 'Обычный период' and status = 'completed'
group by 1,2
order by period_name, 4 desc;