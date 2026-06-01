--Какие цветы списываются чаще всего?/Which flowers are written off most often?

select 
    flower_name, 
	flower_category,
	shelf_life_days,
	count(write_off_id) as count_write_off, --количество списаний
	sum(quantity_stems) as sum_of_stems --количество списанных стеблей
from flowers f
	left join write_offs wo on f.flower_id = wo.flower_id
group by 1,2,3
order by sum_of_stems desc;

--Самая частая причина списаний/The most common reason for write-offs

select 
	reason,
	count(write_off_id) as count_write_off, --количество списаний
	sum(quantity_stems) as sum_of_stems, --количество списанных стеблей
	round(sum(quantity_stems)::numeric/sum(sum(quantity_stems)) over(),4) as sum_of_stems_share --доля списания
from write_offs 
group by 1
order by sum_of_stems_share desc;

--В какие месяцы максимум списаний?/Which months have the maximum write-offs?

select 
	date_trunc('month', write_off_date)::date AS month,
	count(write_off_id) as count_write_off, --количество списаний
	sum(quantity_stems) as sum_of_stems --количество списанных стеблей
from write_offs 
group by 1
order by month;

--Доля списаний от закупленного объёма по цветам/The share of write-offs from the purchased volume by color

with write_off_by_flower as (
	select 
		flower_id, 
		sum(quantity_stems) as sum_of_stems --количество списанных стеблей
	from write_offs
	group by 1
),
purchases_by_flower as (
	 select 
	 	flower_id,
	 	sum(quantity_stems) as sum_of_purchases --количество закупленных стеблей
	 from purchases
	 group by 1
)
select 
	flower_name,
	flower_category,
	shelf_life_days,
	sum_of_purchases,
	coalesce(sum_of_stems,0) as sum_of_stems,
	round(coalesce(sum_of_stems,0)::numeric/sum_of_purchases, 4) as  write_off_rate --доля списаний с общей закупки
from purchases_by_flower pf
inner join flowers f on pf.flower_id = f.flower_id
left join write_off_by_flower wof on pf.flower_id = wof.flower_id
order by write_off_rate desc;
	
--Денежные потери по каждому цветку/Monetary losses for each flower

with avg_price_by_flower as (
	select 
		flower_id,
		avg(purchase_price_per_stem) as avg_price_per_stem --примерная цена за стебель
	from purchases
	group by 1
),
write_off_by_flower as (
	select 
		flower_id, 
		sum(quantity_stems) as sum_of_stems --количество списанных стеблей
	from write_offs
	group by 1
)
select 
	flower_name,
    flower_category,
    round((sum_of_stems * avg_price_per_stem), 2) as monetary_losses
from avg_price_by_flower apbf 
inner join flowers f on apbf.flower_id = f.flower_id
left join write_off_by_flower wof on apbf.flower_id = wof.flower_id
order by 3 desc;