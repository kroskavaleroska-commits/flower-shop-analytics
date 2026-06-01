# Flower Shop Analytics/ Анализ цветочного магазина

SQL + Power BI проект по анализу продаж, маржинальности, сезонности, закупок и списаний цветочного магазина./SQL + Power BI project to analyze sales, margins, seasonality, purchases, and write-offs for a flower shop.

## Business Problem

Цель проекта — определить, какие букеты и каналы продаж приносят прибыль, какие цветы чаще списываются, и как планировать закупки перед сезонными пиками спроса./
The project's goal is to determine which bouquets and sales channels are profitable, which flowers are most frequently written off, and how to plan purchases before seasonal peaks in demand.

## Dataset

Данные являются синтетическими и были сгенерированы для учебного проекта.  
Датасет смоделирован на основе типовых бизнес-процессов цветочного магазина: продажи, клиенты, букеты, состав букетов, поставщики, закупки и списания.
Несмотря на то, что данные искусственные, структура данных, сезонность, логика ценообразования и списаний отражают специфику флористического бизнеса./

The data is synthetic and was generated for a training project. 
The dataset is modeled based on the typical business processes of a flower shop: sales, customers, bouquets, bouquet composition, suppliers, purchases, and write-offs.
 Despite the fact that the data is artificial, the data structure, seasonality, pricing logic, and write-offs reflect the specifics of the floristry business.

## Tools

- PostgreSQL
- SQL
- Power BI
- DAX
- Power Query
- GitHub

## Project Structure

- `data/` — source CSV files
- `sql/` — SQL scripts
- `results/` — exported SQL query results
- `power_bi/` — Power BI dashboard file
- `images/` — dashboard screenshots

## SQL Analysis

The following analysis blocks are performed in the project:

- sales analysis;
- margin analysis;
- supplier analysis;
- write-off analysis;
- seasonality analysis;
- Double ABC analysis.

## Power BI Dashboard

Dashboard contains 6 pages:

1. Executive Summary
2. Sales Channels
3. Assortment & Margin
4. Double abc-analysis
5. Seasonality & Write-offs
6. Supplier Performance

# Key Findings / Основные выводы

## 1. Creating a tables

## 2. Sales Analysis/Анализ продаж

Анализ продаж показал, что выручка и средний чек букетов в разные периоды отличается. Самая высокая выручка приходится на праздники 8 марта, свадебный сезон (в основном июнь), а также на предновогодний период. При этом средний чек в самый пиковый сезон - 8 марта, довольно низкий, в отличии от свадебного сезона. Это означает, что в разные сезонные периоды необходимо делать упор на подходящие по бюджету позиции.
Также было выявлено, что самые популярные по выручке и количеству заказов букеты отличаются, что означает, что самые популярные позиции не всегда являются главными по денежному вкладу: часть букетов продаётся часто за счёт более доступной цены, а часть формирует выручку за счёт высокого среднего чека.
Сравнение каналов продаж показывает различия между offline и online: каналы немного отличаются по количеству заказов, среднему чеку и доле в общей выручке. При этом доля offline продаж чуть больше чем online, из чего можно сделать вывод, что необходимо обращать внимание на оба этих канала продаж.
Анализ отменённых заказов помогает определить, в какие месяцы и в каком канале выше риск потери продаж. Это важно для планирования загрузки администраторов, коммуникации с клиентами и контроля качества обработки заказов.

The sales analysis showed that the revenue and the average receipt of bouquets in different periods is different. The highest revenue falls on the holidays of March 8, the wedding season (mainly June), and the New Year period. At the same time, the average check during the peak season, on March 8, is quite low, unlike the wedding season. This means that in different seasonal periods, it is necessary to focus on positions that are suitable for the budget.
It was also revealed that the bouquets that are most popular in terms of revenue and number of orders differ, which means that the most popular items are not always the main ones in terms of monetary contribution: some bouquets are often sold at a more affordable price, and some generate revenue due to a high average receipt.
A comparison of sales channels shows the differences between offline and online: the channels differ slightly in the number of orders, the average receipt, and the share of total revenue. At the same time, the share of offline sales is slightly higher than online, from which we can conclude that it is necessary to pay attention to both of these sales channels.
The analysis of cancelled orders helps to determine in which months and in which channel the risk of loss of sales is higher. This is important for scheduling admin workload, communicating with customers, and quality control of order processing.

## 3. Margin Analysis

Расчёт себестоимости букетов через состав и закупочные цены показал, что выручка сама по себе не отражает реальную прибыльность ассортимента. Некоторые букеты могут давать высокий объём продаж, но иметь слабую маржинальность из-за дорогого состава или низкой розничной цены.
Анализ маржинальности по букетам позволяет выделить наиболее прибыльные позиции, на которые стоит сделать упор в продажах. Такие букеты дают бизнесу не только оборот, но и валовую прибыль.
Анализ популярных, но низкомаржинальных букетов выявляет позиции, которые создают высокий поток заказов, но приносят ограниченную прибыль. Для таких букетов стоит проверить цену, состав, скидки и возможные замены дорогих компонентов.
Высокомаржинальные, но редко продающиеся букеты могут быть перспективными для продвижения. Если спрос на них можно увеличить через витрину, online-канал или сезонные предложения, они могут стать дополнительным источником прибыли.
Сравнение маржинальности по каналам продаж показывает, какой канал не только приносит выручку, но и обеспечивает более высокий финансовый результат.

Calculating the cost of bouquets through the composition and purchase prices has shown that revenue alone does not reflect the real profitability of the assortment. Some bouquets may have high sales, but have low margins due to expensive ingredients or low retail prices.
The margin analysis of bouquets allows you to identify the most profitable positions, which should be emphasized in sales. Such bouquets give the business not only turnover, but also gross profit.
The analysis of popular but low-margin bouquets reveals positions that create a high flow of orders, but bring limited profits. For such bouquets, it is worth checking the price, composition, discounts and possible replacements of expensive components.
High-margin but rarely sold bouquets can be promising for promotion. If the demand for them can be increased through a showcase, an online channel, or seasonal offers, they can become an additional source of profit.
A comparison of marginality across sales channels shows which channel not only generates revenue, but also provides a higher financial result.

## 4. Supplier Analysis

Анализ закупок по поставщикам показывает, как распределяются объёмы закупки между поставщиками. Если значительная доля закупок приходится на одного поставщика, это создаёт зависимость бизнеса от его стабильности, сроков доставки и качества продукции.
Сравнение средней закупочной цены по поставщикам и цветам показывает, что один и тот же цветок может быть выгоднее закупать у разных поставщиков. Поэтому закупочную стратегию лучше строить не только на уровне поставщика в целом, но и на уровне конкретных цветочных позиций.
Самый дешёвый поставщик не всегда является самым выгодным. Если у поставщика низкая цена, но высокая доля списаний, фактическая выгода может снижаться из-за потерь качества цветов.
Итоговая оценка поставщиков учитывает сразу несколько факторов: закупочную цену, объём поставок, ассортимент, сроки доставки и потери от списаний. Такой подход позволяет принимать более взвешенные решения, чем простой выбор самого дешёвого поставщика.

An analysis of purchases by supplier shows how the purchase volumes are distributed among suppliers. If a significant proportion of purchases are made by a single supplier, this creates a dependence of the business on its stability, delivery time and product quality.
A comparison of the average purchase price by suppliers and flowers shows that it may be more profitable to purchase the same flower from different suppliers. Therefore, it is better to build a purchasing strategy not only at the level of the supplier as a whole, but also at the level of specific flower items.
The cheapest supplier is not always the most profitable. If the supplier has a low price but a high percentage of write-offs, the actual benefit may decrease due to loss of color quality.
The final supplier assessment takes into account several factors at once: the purchase price, the volume of supplies, the assortment, the delivery time and losses from write-offs. This approach allows you to make more informed decisions than simply choosing the cheapest supplier.

## 5. Write-off Analysis

Анализ списаний показывает, какие самый частые причины списаний цветов, в какие периоды списания происходят чаще всего.
Наибольший объём списаний приходится на цветы и категории с самым непродолжительным сроком хранения. Важно учитывать это и обеспечивать правильный уход за каждыми позициями.
Анализ причин списаний показывает основные источники потерь: увядание, излишки после праздников, плохое качество поставки, поломки или истечение срока хранения. Эти причины помогают понять решаемые и нерешаемые причины списаний.
Доля списаний от закупленного объёма является более полезной метрикой, чем абсолютное количество списанных стеблей. Цветок может часто списываться просто потому, что его много закупают, но высокий write-off rate показывает реальный риск позиции.
Оценка денежных потерь от списаний показывает, как списания снижают валовую прибыль магазина. Особенно важно контролировать списания во время праздничных пиков, когда закупки резко увеличиваются, а непроданные остатки быстро теряют товарный вид.

The analysis of write-offs shows which are the most common reasons for flower write-offs, and during which periods write-offs occur most often.
The largest volume of write-offs is for flowers and categories with the shortest shelf life. It is important to take this into account and ensure proper care for each position.
An analysis of the reasons for write-offs shows the main sources of losses: wilting, surpluses after the holidays, poor quality of supply, breakdowns or expiration of shelf life. These reasons help to understand the solvable and unsolvable reasons for write-offs.
The percentage of write-offs from the purchased volume is a more useful metric than the absolute number of stems written off. A flower can often be written off simply because it is bought a lot, but a high write-off rate shows the real risk of the position.
Estimating monetary losses from write-offs shows how write-offs reduce the store's gross profit. It is especially important to control write-offs during holiday peaks, when purchases increase dramatically and unsold balances quickly lose their marketability.

## 6. Seasonality Analysis

Анализ сезонности подтверждает, что спрос во флористике распределён неравномерно в течение года. Продажи усиливаются в периоды праздников и событий, когда цветы покупают как подарок или для оформления мероприятий.
Сезонный индекс помогает определить месяцы, которые значительно сильнее или слабее среднего уровня продаж. Месяцы с индексом выше 1 требуют усиленного планирования закупок, персонала и обработки заказов.
Сравнение 2023 и 2024 годов позволяет оценить динамику развития магазина: рост выручки, изменение количества заказов и влияние online-канала. Это помогает отделить сезонные всплески от реального роста бизнеса.
Анализ праздничных периодов показывает, какие события формируют основные пики спроса. Для таких периодов важно заранее планировать закупки, так как ошибка в объёме может привести либо к упущенным продажам, либо к высоким списаниям после праздника.
Также был произведен анализ спросу в течении недели, так как день недели также влияет на количество проданных товаров. Было выявлено, что основными ударными днями являются воскресенье и суббота, на это стоит обратить внимание при составлении расписания работы и распределения нагрузки на флористов.
При сравнении разных периодов года было выявлено, что разные цветы имеют разную сезонность. Одни позиции продаются стабильно круглый год, другие требуют сезонного подхода к закупкам и продвижению.
То же касается и определенных букетов, некоторые позиции имеет больший спрос в различные праздники, что тоже необходимо учитывать при составлении коллекции.

The analysis of seasonality confirms that the demand in floristry is unevenly distributed throughout the year. Sales increase during holidays and events, when flowers are bought as gifts or to decorate events.
The seasonal index helps you identify months that are significantly stronger or weaker than the average sales level. Months with an index above 1 require enhanced procurement planning, staffing, and order processing.
Comparing 2023 and 2024 allows us to assess the dynamics of the store's development: revenue growth, changes in the number of orders and the impact of the online channel. This helps to separate seasonal spikes from real business growth.
The analysis of the holiday periods shows which events form the main peaks of demand. For such periods, it is important to plan purchases in advance, as an error in volume can lead either to missed sales or to high write-offs after the holiday.
An analysis of demand during the week was also performed, as the day of the week also affects the number of goods sold. It was revealed that the main impact days are Sunday and Saturday, it is worth paying attention to this when drawing up a work schedule and distributing the workload to florists.
When comparing different periods of the year, it was found that different flowers have different seasonality. Some items are sold consistently all year round, while others require a seasonal approach to procurement and promotion.
The same applies to certain bouquets, some items are in greater demand on various holidays, which also needs to be taken into account when compiling a collection.

## 7. Double ABC Analysis

В данном ABC - анализе первая буква, это объем продаж, а вторая - выручка.
AA
Высокая выручка и высокий объём продаж
Ядро ассортимента. Эти букеты одновременно часто покупают и они дают основную выручку. Их нужно всегда держать в наличии, контролировать остатки цветов для их сборки и использовать как основу планирования закупок.
AB
Высокий объем продаж и средняя выручка
Массовые популярные позиции с относительно невысоким чеком. Они создают поток заказов, но вклад в выручку не максимальный. Нужно проверить маржинальность: если маржа низкая, можно пересмотреть цену или состав букета.
AC
Высокий объем продаж и низкая выручка
Очень популярные позиции, который приносят мало дохода. Потенциально проблемная зона, в которой стоит пересмотреть себестоимость букетов или поднять цену
ВА
Средний объем продаж и высокая выручка
Сильные позиции, которые приносят хороший доход, но не особо сильно популярные. Скорее всего позиции с высоким чеком. Стоит всегда поддерживать их в ассортименте и попробовать продвигать этот товар в online
ВВ
Средний объем продаж и средняя выручка
Стабильные позиции, которые дают хороший доход. Можно держать в ассортименте но без избытка.
ВС
Средний объем продаж и низкая выручка
Продаются в умеренном количестве но почти не влияют на выручку.Стоит также пересмотреть маржинальность этих товаров или не делать на них акцент при закупке товара, иметь в виду как дополнительные позиции.
СА
Низкий объем продаж и высокая выручка
Премиум сегмент или свадебные букеты. Покупаются редко, но приносят значительную выручку. Их не обязательно держать в большом объёме, но важно сохранять как имиджевый/премиальный ассортимент и предлагать под свадьбы или торжественные события.
СВ
Низкий объем продаж и средняя выручка
Нишевые позиции. Продаются редко, но дают средний вклад в выручку, вероятно за счёт более высокой цены. Стоит проверить, в какие периоды они продаются: возможно, это сезонные или событийные букеты.
СС
Низкий объем продаж и низкая выручка
Самое слабое звено в ассортименте. Стоит обратить внимание на них внимание, возможно удалить или перевести в разряд позиций только под заказ.

In this ABC analysis, the first letter is sales volume, and the second is revenue.
AA
High revenue and high sales volume
The core of the product range. These bouquets are often bought at the same time and they provide the main revenue. They should always be kept in stock, the remaining flowers should be monitored for their assembly and used as the basis for purchase planning.
AB
High sales volume and average revenue
Massive popular positions with a relatively low check. They create a flow of orders, but the contribution to revenue is not the maximum. It is necessary to check the marginality: if the margin is low, you can review the price or the composition of the bouquet.
AC
High sales volume and low revenue
Very popular positions that generate little income. A potentially problematic area in which it is worth reviewing the cost of bouquets or raising the price
va
Average sales and high revenue
Strong positions that generate good income, but are not very popular. Most likely positions with a high check. You should always keep them in stock and try to promote this product online.
vv
Average sales and average revenue
Stable positions that provide good income. You can keep it in stock but without excess.

Average sales and low revenue
They are sold in moderate quantities but have almost no effect on revenue.It is also worth reviewing the marginality of these products or not focusing on them when purchasing goods, keeping in mind as additional items.

Low sales volume and high revenue
Premium segment or wedding bouquets. They are rarely bought, but they bring significant revenue. It is not necessary to keep them in large quantities, but it is important to keep them as an image / premium assortment and offer them for weddings or special events.
SV
Low sales volume and average revenue
Niche positions. They are rarely sold, but they make an average contribution to revenue, probably due to the higher price. It is worth checking in which periods they are sold: perhaps these are seasonal or event bouquets.
SS
Low sales and low revenue
The weakest link in the product range. It is worth paying attention to them, it is possible to remove or transfer them to the category of items only for the order.

## Power BI Dashboard

### Executive Summary

![Executive Summary](images/executive_summary.png)

### Sales Channels

![Sales Channels](images/sales_channels.png)

### Assortment & Margin

![Assortment & Margin](images/assortment_margin.png)

### Double abc-analysis

![Double abc - analysis](images/double_abc_analysis.png)

### Seasonality & Write-offs

![Seasonality & Write-offs](images/seasonality_writeoffs.png)

### Supplier Performance

![Supplier Performance](images/supplier_performance.png)

## How to Run

1. Create PostgreSQL database.
2. Run `sql/01_create_tables.sql`.
3. Import CSV files from `data/`.
4. Run SQL analysis scripts from `sql/`.
5. Open `power_bi/flower_shop_dashboard.pbix`.