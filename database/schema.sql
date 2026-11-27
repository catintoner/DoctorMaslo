-- Таблица товаров
CREATE TABLE IF NOT EXISTS products
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying(250) NOT NULL,
    price numeric(12,2),
    sku character varying(25) NOT NULL,
    picture_url character varying(250),
    avito_url character varying(250),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_pkey PRIMARY KEY (id)
);


SELECT *FROM products