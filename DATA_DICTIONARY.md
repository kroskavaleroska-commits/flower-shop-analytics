Flower Shop Analytics — source CSV data

Synthetic dataset for the Bloom & Co flower shop analytics project. Dates cover 2023-01-01 through 2024-12-31.

## Row counts

| Table | Rows |
|---|---:|
| flowers | 25 |
| suppliers | 5 |
| supplier_prices | 122 |
| bouquets | 30 |
| bouquet_composition | 108 |
| clients | 2915 |
| orders | 5487 |
| order_items | 6249 |
| purchases | 2304 |
| write_offs | 1638 |

## Tables and columns

### flowers.csv
- flower_id: primary key
- flower_name: flower name
- flower_category: flower group/category
- color: main color
- country_origin: source country
- shelf_life_days: typical shelf life
- is_seasonal: true/false flag

### suppliers.csv
- supplier_id: primary key
- supplier_name: supplier name
- supplier_type: local/federal/import/seasonal
- city: supplier city
- avg_delivery_days: average delivery time
- payment_terms: payment terms

### supplier_prices.csv
- supplier_price_id: primary key
- supplier_id: supplier key
- flower_id: flower key
- purchase_price: purchase price per stem
- valid_from, valid_to: annual price period

### bouquets.csv
- bouquet_id: primary key
- bouquet_name: product name
- bouquet_category: mono/author/premium/wedding/corporate/seasonal
- retail_price: selling price


### bouquet_composition.csv
- bouquet_id: bouquet key
- flower_id: flower key
- stems_count: number of stems of this flower in one bouquet

### clients.csv
- client_id: primary key
- gender: female/male/unknown
- age_group: age range
- first_order_date: first order date in the dataset
- client_type: new/regular by total order count in the dataset

### orders.csv
- order_id: primary key
- order_date: order date
- client_id: client key
- sales_channel: offline/online
- event_type: reason/event for the order
- status: completed/cancelled
- discount_amount: order-level discount amount

### order_items.csv
- order_item_id: primary key
- order_id: order key
- bouquet_id: bouquet key
- quantity: number of bouquets
- unit_price: selling price per bouquet before order-level discount

### purchases.csv
- purchase_id: primary key
- purchase_date: purchase date
- supplier_id: supplier key
- flower_id: flower key
- quantity_stems: purchased stems
- purchase_price_per_stem: actual purchase price per stem
- total_purchase_amount: quantity_stems * purchase_price_per_stem

### write_offs.csv
- write_off_id: primary key
- write_off_date: write-off date
- supplier_id: supplier key, added to make supplier write-off analysis possible
- flower_id: flower key
- quantity_stems: written off stems
- reason: wilted/broken/overstock/poor_quality/expired
