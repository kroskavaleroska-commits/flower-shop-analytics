--Создание таблицы flowers/Creating the table 'flowers'

CREATE TABLE flowers (
    flower_id INTEGER PRIMARY KEY,
    flower_name VARCHAR(100) NOT NULL,
    flower_category VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    country_origin VARCHAR(100) NOT NULL,
    shelf_life_days INTEGER NOT NULL,
    is_seasonal BOOLEAN NOT NULL
);

--Создание таблицы suppliers/Creating the table 'suppliers'

CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    supplier_type VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    avg_delivery_days INTEGER NOT NULL,
    payment_terms VARCHAR(100) NOT NULL
);

--Создание таблицы supplier_prices/Creating the table 'supplier_prices'

CREATE TABLE supplier_prices (
    supplier_price_id INTEGER PRIMARY KEY,
    supplier_id INTEGER NOT NULL,
    flower_id INTEGER NOT NULL,
    purchase_price NUMERIC(10, 2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,

    CONSTRAINT fk_supplier_prices_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id),

    CONSTRAINT fk_supplier_prices_flower
        FOREIGN KEY (flower_id)
        REFERENCES flowers (flower_id)
);

--Создание таблицы bouquets/Creating the table 'bouquets'

CREATE TABLE bouquets (
    bouquet_id INTEGER PRIMARY KEY,
    bouquet_name VARCHAR(150) NOT NULL,
    bouquet_category VARCHAR(50) NOT NULL,
    retail_price NUMERIC(10, 2) NOT NULL
);

--Создание таблицы bouquet_composition/Creating the table 'bouquet_composition'

CREATE TABLE bouquet_composition (
    bouquet_id INTEGER NOT NULL,
    flower_id INTEGER NOT NULL,
    stems_count INTEGER NOT NULL,

    CONSTRAINT pk_bouquet_composition
        PRIMARY KEY (bouquet_id, flower_id),

    CONSTRAINT fk_bouquet_composition_bouquet
        FOREIGN KEY (bouquet_id)
        REFERENCES bouquets (bouquet_id),

    CONSTRAINT fk_bouquet_composition_flower
        FOREIGN KEY (flower_id)
        REFERENCES flowers (flower_id)
);

--Создание таблицы clients/Creating the table 'clients'

CREATE TABLE clients (
    client_id INTEGER PRIMARY KEY,
    gender VARCHAR(20) NOT NULL,
    age_group VARCHAR(20) NOT NULL,
    first_order_date DATE NOT NULL,
    client_type VARCHAR(50) NOT NULL
);


--Создание таблицы orders/Creating the table 'orders'

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    client_id INTEGER NOT NULL,
    sales_channel VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    discount_amount NUMERIC(10, 2) NOT NULL,

    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id)
        REFERENCES clients (client_id)
);

--Создание таблицы order_items/Creating the table 'order_items'

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    bouquet_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id),

    CONSTRAINT fk_order_items_bouquet
        FOREIGN KEY (bouquet_id)
        REFERENCES bouquets (bouquet_id)
);


--Создание таблицы purchases/Creating the table 'purchases'

CREATE TABLE purchases (
    purchase_id INTEGER PRIMARY KEY,
    purchase_date DATE NOT NULL,
    supplier_id INTEGER NOT NULL,
    flower_id INTEGER NOT NULL,
    quantity_stems INTEGER NOT NULL,
    purchase_price_per_stem NUMERIC(10, 2) NOT NULL,
    total_purchase_amount NUMERIC(12, 2) NOT NULL,

    CONSTRAINT fk_purchases_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id),

    CONSTRAINT fk_purchases_flower
        FOREIGN KEY (flower_id)
        REFERENCES flowers (flower_id)
);

--Создание таблицы write_offs/Creating the table 'write_offs'

CREATE TABLE write_offs (
    write_off_id INTEGER PRIMARY KEY,
    write_off_date DATE NOT NULL,
    supplier_id INTEGER NOT NULL,
    flower_id INTEGER NOT NULL,
    quantity_stems INTEGER NOT NULL,
    reason VARCHAR(50) NOT NULL,

    CONSTRAINT fk_write_offs_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id),

    CONSTRAINT fk_write_offs_flower
        FOREIGN KEY (flower_id)
        REFERENCES flowers (flower_id)
);