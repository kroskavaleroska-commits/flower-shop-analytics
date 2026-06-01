--ABC-анализ по выручке/ABC-revenue analysis
with revenue as (
	select 
		b.bouquet_id,
		bouquet_name,
		bouquet_category,
		sum(quantity) as bouquet_count, --количество букетов
		sum(quantity * unit_price) as revenue --выручка за тип букета
	from order_items oi
	inner join orders o on oi.order_id = o.order_id
	inner join bouquets b on oi.bouquet_id = b.bouquet_id
	where status = 'completed'
	group by 1, 2, 3
	order by 5 desc
),
abc_analysis as (
	select
	    bouquet_id,
		bouquet_name,
		bouquet_category,
		bouquet_count,
		revenue,
		round(revenue/sum(revenue) over (), 4) as revenue_share, --доля выручки по каждому типу букета от общей выручки
		round(sum(revenue) over(order by revenue desc rows between unbounded preceding and current row)/sum(revenue) over (), 4) as cumulative_revenue --кумулятивная выручка
	from revenue
)
select 
	bouquet_name,
	bouquet_category,
    bouquet_count,
	revenue,	
    revenue_share,
    cumulative_revenue,
    case 
    	when cumulative_revenue <= 0.8 then 'A'
    	when cumulative_revenue <= 0.95 then 'B'
    	else 'C'
    end as type_abc
from abc_analysis
order by revenue desc;

----ABC-анализ по объему продаж/ABC-sales volume analysis

with sales_volume as (
	select 
		b.bouquet_id,
		bouquet_name,
		bouquet_category,
		sum(quantity) as sales_volume --объем продаж
	from order_items oi
	inner join orders o on oi.order_id = o.order_id
	inner join bouquets b on oi.bouquet_id = b.bouquet_id
	where status = 'completed'
	group by 1, 2, 3
	order by 4 desc
),
abc_analysis as (
	select
	    bouquet_id,
		bouquet_name,
		bouquet_category,
		sales_volume,
		round(sales_volume/sum(sales_volume) over (), 4) as sales_volume_share, --доля объема продаж по каждому типу букета от общей выручки
		round(sum(sales_volume) over(order by sales_volume desc rows between unbounded preceding and current row)/sum(sales_volume) over (), 4) as cumulative_sales_volume 
	from sales_volume
)
select 
	bouquet_name,
	bouquet_category,
    sales_volume,
	sales_volume_share,	
    cumulative_sales_volume,
    case 
    	when cumulative_sales_volume <= 0.8 then 'A'
    	when cumulative_sales_volume <= 0.95 then 'B'
    	else 'C'
    end as type_abc
from abc_analysis
order by sales_volume desc;


--Двойной ABC-анализ/Double ABC analysis

with revenue as (
	select 
		b.bouquet_id,
		bouquet_name,
		bouquet_category,
		sum(quantity) as sales_volume, --объем продаж
		sum(quantity * unit_price) as revenue --выручка за тип букета
	from order_items oi
	inner join orders o on oi.order_id = o.order_id
	inner join bouquets b on oi.bouquet_id = b.bouquet_id
	where status = 'completed'
	group by 1, 2, 3
	order by 5 desc
),
abc_analysis as (
	select
	    bouquet_id,
		bouquet_name,
		bouquet_category,
		sales_volume,
		revenue,
		round(revenue/sum(revenue) over (), 4) as revenue_share, --доля выручки по каждому типу букета от общей выручки
		round(sum(revenue) over(order by revenue desc rows between unbounded preceding and current row)/sum(revenue) over (), 4) as cumulative_revenue, --кумулятивная выручка
		round(sum(sales_volume) over(order by sales_volume desc rows between unbounded preceding and current row)/sum(sales_volume) over (), 4) as cumulative_sales_volume  --кумулятивный объем продаж
	from revenue
)
select 
	bouquet_name,
	bouquet_category,
    sales_volume,
	revenue,
	case 
    	when cumulative_sales_volume <= 0.8 then 'A'
    	when cumulative_sales_volume <= 0.95 then 'B'
    	else 'C'
    end as abc_sales_volume,
    case 
    	when cumulative_revenue <= 0.8 then 'A'
    	when cumulative_revenue <= 0.95 then 'B'
    	else 'C'
    end as abc_revenue,
    case 
    	when cumulative_sales_volume <= 0.8 then 'A'
    	when cumulative_sales_volume <= 0.95 then 'B'
    	else 'C'
    end || case 
    	when cumulative_revenue <= 0.8 then 'A'
    	when cumulative_revenue <= 0.95 then 'B'
    	else 'C'
    end as double_class
from abc_analysis
order by revenue desc;
