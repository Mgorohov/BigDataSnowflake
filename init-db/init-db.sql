
DO $$
BEGIN
  RAISE NOTICE 'Starting 00-init-db.sql: Creating staging table and loading data...';
END $$;
-- Сделал для себя для проверки логов

DROP TABLE IF EXISTS mock_data_staging;

-- Создал staging таблицу чтобы использовать staging_id как первичный ключ, а id_source для хранения оригинального id из CSV
CREATE TABLE mock_data_staging (
    staging_id SERIAL PRIMARY KEY,   
    id_source INT,                    
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_age_text VARCHAR(10),     
    customer_email VARCHAR(150),
    customer_country VARCHAR(100),
    customer_postal_code VARCHAR(50),
    customer_pet_type VARCHAR(50),
    customer_pet_name VARCHAR(100),
    customer_pet_breed VARCHAR(100),
    seller_first_name VARCHAR(100),
    seller_last_name VARCHAR(100),
    seller_email VARCHAR(150),
    seller_country VARCHAR(100),
    seller_postal_code VARCHAR(50),
    product_name VARCHAR(150),
    product_category VARCHAR(100),
    product_price_text VARCHAR(50),
    product_quantity_at_source_text VARCHAR(10), 
    sale_date_text VARCHAR(50),
    sale_customer_id_text VARCHAR(10),  
    sale_seller_id_text VARCHAR(10),    
    sale_product_id_text VARCHAR(10),  
    sale_quantity_text VARCHAR(10),
    sale_total_price_text VARCHAR(50),
    store_name VARCHAR(150),
    store_location VARCHAR(255),
    store_city VARCHAR(100),
    store_state VARCHAR(50),
    store_country VARCHAR(100),
    store_phone VARCHAR(50),
    store_email VARCHAR(150),
    pet_category VARCHAR(100),
    product_weight_text VARCHAR(50),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    product_brand VARCHAR(100),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating_text VARCHAR(50),
    product_reviews_text VARCHAR(10),
    product_release_date_text VARCHAR(50),
    product_expiry_date_text VARCHAR(50),
    supplier_name VARCHAR(150),
    supplier_contact VARCHAR(150),
    supplier_email VARCHAR(150),
    supplier_phone VARCHAR(50),
    supplier_address VARCHAR(255),
    supplier_city VARCHAR(100),
    supplier_country VARCHAR(100)
);


DO $$ BEGIN RAISE NOTICE 'Table mock_data_staging created.'; END $$;


DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_1.csv...'; END $$;
COPY mock_data_staging (
    id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code,
    customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country,
    seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text,
    sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name,
    store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text,
    product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text,
    product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone,
    supplier_address, supplier_city, supplier_country
) FROM '/csv_data/mock_data_1.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_1.csv. Rows affected: %', (SELECT COUNT(*) FROM mock_data_staging WHERE staging_id <= 1000); END $$; -- Примерная проверка

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_2.csv...'; END $$;
COPY mock_data_staging (
    id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code,
    customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country,
    seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text,
    sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name,
    store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text,
    product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text,
    product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone,
    supplier_address, supplier_city, supplier_country
) FROM '/csv_data/mock_data_2.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_2.csv.'; END $$;


DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_3.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_3.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_3.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_4.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_4.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_4.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_5.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_5.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_5.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_6.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_6.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_6.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_7.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_7.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_7.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_8.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_8.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_8.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_9.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_9.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_9.csv.'; END $$;

DO $$ BEGIN RAISE NOTICE 'Starting data load from mock_data_10.csv...'; END $$;
COPY mock_data_staging (id_source, customer_first_name, customer_last_name, customer_age_text, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, product_name, product_category, product_price_text, product_quantity_at_source_text, sale_date_text, sale_customer_id_text, sale_seller_id_text, sale_product_id_text, sale_quantity_text, sale_total_price_text, store_name, store_location, store_city, store_state, store_country, store_phone, store_email, pet_category, product_weight_text, product_color, product_size, product_brand, product_material, product_description, product_rating_text, product_reviews_text, product_release_date_text, product_expiry_date_text, supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country) FROM '/csv_data/mock_data_10.csv' DELIMITER ',' CSV HEADER;
DO $$ BEGIN RAISE NOTICE 'Finished loading mock_data_10.csv.'; END $$;


-- Проверка количества загруж строк
DO $$
DECLARE
  row_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO row_count FROM mock_data_staging;
  RAISE NOTICE 'Finished 00-init-db.sql. Total rows in mock_data_staging: %', row_count;
END $$;