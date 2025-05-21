
DROP TABLE IF EXISTS FactSales CASCADE;
DROP TABLE IF EXISTS DimProduct CASCADE;
DROP TABLE IF EXISTS DimProductBrand CASCADE;
DROP TABLE IF EXISTS DimProductCategory CASCADE;
DROP TABLE IF EXISTS DimPetCategory CASCADE;
DROP TABLE IF EXISTS DimCustomerPet CASCADE;
DROP TABLE IF EXISTS DimCustomer CASCADE;
DROP TABLE IF EXISTS DimSeller CASCADE;
DROP TABLE IF EXISTS DimStore CASCADE;
DROP TABLE IF EXISTS DimSupplier CASCADE;
DROP TABLE IF EXISTS DimCountry CASCADE;
DROP TABLE IF EXISTS DimDate CASCADE;

CREATE TABLE DimDate (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    day_of_week INT,
    day_name VARCHAR(10),
    day_of_month INT,
    month INT,
    month_name VARCHAR(10),
    quarter INT,
    year INT
);

CREATE TABLE DimCountry (
    country_key SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE DimCustomer (
    customer_key SERIAL PRIMARY KEY,
    customer_email VARCHAR(150) UNIQUE NOT NULL, 
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INT,
    country_key INT REFERENCES DimCountry(country_key),
    postal_code VARCHAR(50)
);

CREATE TABLE DimCustomerPet (
    customer_pet_key SERIAL PRIMARY KEY,
    customer_key INT REFERENCES DimCustomer(customer_key) NOT NULL,
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    pet_breed VARCHAR(100),
    CONSTRAINT uq_customer_pet UNIQUE (customer_key, pet_type, pet_name, pet_breed) 
);

CREATE TABLE DimSeller (
    seller_key SERIAL PRIMARY KEY,
    seller_email VARCHAR(150) UNIQUE NOT NULL, 
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    country_key INT REFERENCES DimCountry(country_key),
    postal_code VARCHAR(50)
);

CREATE TABLE DimPetCategory ( 
    pet_category_key SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE DimProductCategory ( 
    category_key SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    pet_category_key INT REFERENCES DimPetCategory(pet_category_key), 
    CONSTRAINT uq_product_category UNIQUE (category_name, pet_category_key)
);

CREATE TABLE DimProductBrand (
    brand_key SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE DimProduct (
    product_key SERIAL PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_key INT REFERENCES DimProductCategory(category_key),
    brand_key INT REFERENCES DimProductBrand(brand_key),
    color VARCHAR(50),
    size_ VARCHAR(50), 
    material VARCHAR(100),
    weight NUMERIC(10,2),
    description TEXT,
    rating NUMERIC(3,1),
    reviews INT,
    release_date_key INT REFERENCES DimDate(date_key),
    expiry_date_key INT REFERENCES DimDate(date_key),
    CONSTRAINT uq_product UNIQUE (product_name, brand_key, category_key)
);

CREATE TABLE DimStore (
    store_key SERIAL PRIMARY KEY,
    store_name VARCHAR(150) NOT NULL,
    store_email VARCHAR(150),
    location_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    country_key INT REFERENCES DimCountry(country_key),
    phone VARCHAR(50),
    CONSTRAINT uq_store UNIQUE (store_name, city, country_key) 
);

CREATE TABLE DimSupplier (
    supplier_key SERIAL PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    supplier_email VARCHAR(150), 
    contact_person VARCHAR(150),
    phone VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    country_key INT REFERENCES DimCountry(country_key),
    CONSTRAINT uq_supplier UNIQUE (supplier_name, supplier_email) 
);



CREATE TABLE FactSales (
    sale_id_source INT, 
    date_key INT NOT NULL REFERENCES DimDate(date_key),
    customer_key INT NOT NULL REFERENCES DimCustomer(customer_key),
    seller_key INT NOT NULL REFERENCES DimSeller(seller_key),
    product_key INT NOT NULL REFERENCES DimProduct(product_key),
    store_key INT NOT NULL REFERENCES DimStore(store_key),
    supplier_key INT NOT NULL REFERENCES DimSupplier(supplier_key), 
    
    sale_quantity INT,
    product_price_at_sale NUMERIC(10,2), 
    sale_total_price NUMERIC(12,2),
    
    PRIMARY KEY (sale_id_source) 
);

CREATE INDEX IF NOT EXISTS idx_fs_date ON FactSales(date_key);
CREATE INDEX IF NOT EXISTS idx_fs_customer ON FactSales(customer_key);
CREATE INDEX IF NOT EXISTS idx_fs_seller ON FactSales(seller_key);
CREATE INDEX IF NOT EXISTS idx_fs_product ON FactSales(product_key);
CREATE INDEX IF NOT EXISTS idx_fs_store ON FactSales(store_key);
CREATE INDEX IF NOT EXISTS idx_fs_supplier ON FactSales(supplier_key);
CREATE INDEX IF NOT EXISTS idx_prod_category ON DimProduct(category_key);
CREATE INDEX IF NOT EXISTS idx_prod_brand ON DimProduct(brand_key);
CREATE INDEX IF NOT EXISTS idx_prod_release ON DimProduct(release_date_key);
CREATE INDEX IF NOT EXISTS idx_prod_expiry ON DimProduct(expiry_date_key);
CREATE INDEX IF NOT EXISTS idx_pcat_petcat ON DimProductCategory(pet_category_key);
CREATE INDEX IF NOT EXISTS idx_store_country ON DimStore(country_key);
CREATE INDEX IF NOT EXISTS idx_supplier_country ON DimSupplier(country_key);
CREATE INDEX IF NOT EXISTS idx_customer_country ON DimCustomer(country_key);
CREATE INDEX IF NOT EXISTS idx_seller_country ON DimSeller(country_key);