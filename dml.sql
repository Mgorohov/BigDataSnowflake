CREATE OR REPLACE FUNCTION safe_to_numeric(text_val TEXT, default_val NUMERIC DEFAULT NULL)
RETURNS NUMERIC AS $$
BEGIN
    IF text_val IS NULL OR text_val = '' THEN RETURN default_val; END IF;
    RETURN text_val::NUMERIC;
EXCEPTION WHEN others THEN RETURN default_val; END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_to_int(text_val TEXT, default_val INT DEFAULT NULL)
RETURNS INT AS $$
BEGIN
    IF text_val IS NULL OR text_val = '' THEN RETURN default_val; END IF;
    RETURN text_val::INT;
EXCEPTION WHEN others THEN RETURN default_val; END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_to_date(text_val TEXT, format_str TEXT, default_val DATE DEFAULT NULL)
RETURNS DATE AS $$
BEGIN
    IF text_val IS NULL OR text_val = '' THEN RETURN default_val; END IF;
    RETURN TO_DATE(text_val, format_str);
EXCEPTION WHEN others THEN RETURN default_val; END;
$$ LANGUAGE plpgsql IMMUTABLE;


INSERT INTO DimDate (full_date, day_of_week, day_name, day_of_month, month, month_name, quarter, year)
SELECT
    d.dt AS full_date,
    EXTRACT(ISODOW FROM d.dt) AS day_of_week,
    TO_CHAR(d.dt, 'Dy') AS day_name,
    EXTRACT(DAY FROM d.dt) AS day_of_month,
    EXTRACT(MONTH FROM d.dt) AS month,
    TO_CHAR(d.dt, 'Mon') AS month_name,
    EXTRACT(QUARTER FROM d.dt) AS quarter,
    EXTRACT(YEAR FROM d.dt) AS year
FROM (
    SELECT DISTINCT safe_to_date(sale_date_text, 'MM/DD/YYYY') AS dt FROM mock_data_staging WHERE safe_to_date(sale_date_text, 'MM/DD/YYYY') IS NOT NULL
    UNION
    SELECT DISTINCT safe_to_date(product_release_date_text, 'MM/DD/YYYY') AS dt FROM mock_data_staging WHERE safe_to_date(product_release_date_text, 'MM/DD/YYYY') IS NOT NULL
    UNION
    SELECT DISTINCT safe_to_date(product_expiry_date_text, 'MM/DD/YYYY') AS dt FROM mock_data_staging WHERE safe_to_date(product_expiry_date_text, 'MM/DD/YYYY') IS NOT NULL
) d
WHERE d.dt IS NOT NULL
ON CONFLICT (full_date) DO NOTHING;


INSERT INTO DimCountry (country_name)
SELECT DISTINCT country FROM (
    SELECT customer_country AS country FROM mock_data_staging WHERE customer_country IS NOT NULL AND customer_country <> ''
    UNION
    SELECT seller_country AS country FROM mock_data_staging WHERE seller_country IS NOT NULL AND seller_country <> ''
    UNION
    SELECT store_country AS country FROM mock_data_staging WHERE store_country IS NOT NULL AND store_country <> ''
    UNION
    SELECT supplier_country AS country FROM mock_data_staging WHERE supplier_country IS NOT NULL AND supplier_country <> ''
) AS countries
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO DimCustomer (customer_email, first_name, last_name, age, country_key, postal_code)
SELECT DISTINCT
    s.customer_email,
    s.customer_first_name,
    s.customer_last_name,
    safe_to_int(s.customer_age_text), 
    cy.country_key,
    s.customer_postal_code
FROM mock_data_staging s
LEFT JOIN DimCountry cy ON s.customer_country = cy.country_name
WHERE s.customer_email IS NOT NULL AND s.customer_email <> ''
ON CONFLICT (customer_email) DO NOTHING;

INSERT INTO DimCustomerPet (customer_key, pet_type, pet_name, pet_breed)
SELECT DISTINCT
    dc.customer_key,
    s.customer_pet_type,
    s.customer_pet_name,
    s.customer_pet_breed
FROM mock_data_staging s
JOIN DimCustomer dc ON s.customer_email = dc.customer_email
WHERE s.customer_pet_type IS NOT NULL AND s.customer_pet_type <> ''
   OR s.customer_pet_name IS NOT NULL AND s.customer_pet_name <> ''
   OR s.customer_pet_breed IS NOT NULL AND s.customer_pet_breed <> ''
ON CONFLICT (customer_key, pet_type, pet_name, pet_breed) DO NOTHING;


INSERT INTO DimSeller (seller_email, first_name, last_name, country_key, postal_code)
SELECT DISTINCT
    s.seller_email,
    s.seller_first_name,
    s.seller_last_name,
    cy.country_key,
    s.seller_postal_code
FROM mock_data_staging s
LEFT JOIN DimCountry cy ON s.seller_country = cy.country_name
WHERE s.seller_email IS NOT NULL AND s.seller_email <> ''
ON CONFLICT (seller_email) DO NOTHING;

INSERT INTO DimPetCategory (pet_category_name)
SELECT DISTINCT
    pet_category
FROM mock_data_staging
WHERE pet_category IS NOT NULL AND pet_category <> ''
ON CONFLICT (pet_category_name) DO NOTHING;

INSERT INTO DimProductCategory (category_name, pet_category_key)
SELECT DISTINCT
    s.product_category,
    dpc.pet_category_key
FROM mock_data_staging s
LEFT JOIN DimPetCategory dpc ON s.pet_category = dpc.pet_category_name
WHERE s.product_category IS NOT NULL AND s.product_category <> ''
ON CONFLICT (category_name, pet_category_key) DO NOTHING;

INSERT INTO DimProductBrand (brand_name)
SELECT DISTINCT
    product_brand
FROM mock_data_staging
WHERE product_brand IS NOT NULL AND product_brand <> ''
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO DimProduct (
    product_name, category_key, brand_key, color, size_, material,
    weight, description, rating, reviews, release_date_key, expiry_date_key
)
SELECT DISTINCT
    s.product_name,
    cat.category_key,
    brand.brand_key,
    s.product_color,
    s.product_size,
    s.product_material,
    safe_to_numeric(s.product_weight_text),       
    s.product_description,
    safe_to_numeric(s.product_rating_text),       
    safe_to_int(s.product_reviews_text),          
    dr.date_key AS release_date_key,
    de.date_key AS expiry_date_key
FROM mock_data_staging s
LEFT JOIN DimProductBrand brand ON s.product_brand = brand.brand_name
LEFT JOIN DimPetCategory dpc_join ON s.pet_category = dpc_join.pet_category_name
LEFT JOIN DimProductCategory cat ON s.product_category = cat.category_name AND cat.pet_category_key = dpc_join.pet_category_key
LEFT JOIN DimDate dr ON safe_to_date(s.product_release_date_text, 'MM/DD/YYYY') = dr.full_date
LEFT JOIN DimDate de ON safe_to_date(s.product_expiry_date_text, 'MM/DD/YYYY') = de.full_date
WHERE s.product_name IS NOT NULL AND s.product_name <> ''
ON CONFLICT (product_name, brand_key, category_key) DO NOTHING;

INSERT INTO DimStore (store_name, store_email, location_address, city, state, country_key, phone)
SELECT DISTINCT
    s.store_name,
    s.store_email,
    s.store_location,
    s.store_city,
    s.store_state,
    cy.country_key,
    s.store_phone
FROM mock_data_staging s
LEFT JOIN DimCountry cy ON s.store_country = cy.country_name
WHERE s.store_name IS NOT NULL AND s.store_name <> ''
ON CONFLICT (store_name, city, country_key) DO NOTHING;

INSERT INTO DimSupplier (supplier_name, supplier_email, contact_person, phone, address, city, country_key)
SELECT DISTINCT
    s.supplier_name,
    s.supplier_email,
    s.supplier_contact,
    s.supplier_phone,
    s.supplier_address,
    s.supplier_city,
    cy.country_key
FROM mock_data_staging s
LEFT JOIN DimCountry cy ON s.supplier_country = cy.country_name
WHERE s.supplier_name IS NOT NULL AND s.supplier_name <> ''
ON CONFLICT (supplier_name, supplier_email) DO NOTHING;


INSERT INTO FactSales (
    sale_id_source, date_key, customer_key, seller_key, product_key, store_key, supplier_key,
    sale_quantity, product_price_at_sale, sale_total_price
)
SELECT
    s.id_source, 
    dd.date_key,
    dc.customer_key,
    dsel.seller_key,
    dp.product_key,
    dstore.store_key,
    dsup.supplier_key,
    safe_to_int(s.sale_quantity_text),            
    safe_to_numeric(s.product_price_text),        
    safe_to_numeric(s.sale_total_price_text)      
FROM mock_data_staging s
JOIN DimDate dd ON safe_to_date(s.sale_date_text, 'MM/DD/YYYY') = dd.full_date
JOIN DimCustomer dc ON s.customer_email = dc.customer_email
JOIN DimSeller dsel ON s.seller_email = dsel.seller_email

LEFT JOIN DimProductBrand dpb_join ON s.product_brand = dpb_join.brand_name
LEFT JOIN DimPetCategory dpc_join_prod ON s.pet_category = dpc_join_prod.pet_category_name
LEFT JOIN DimProductCategory dptc_join ON s.product_category = dptc_join.category_name AND dptc_join.pet_category_key = dpc_join_prod.pet_category_key
JOIN DimProduct dp ON s.product_name = dp.product_name 
                   AND COALESCE(dp.brand_key, -1) = COALESCE(dpb_join.brand_key, -1)
                   AND COALESCE(dp.category_key, -1) = COALESCE(dptc_join.category_key, -1)

LEFT JOIN DimCountry dscy_join ON s.store_country = dscy_join.country_name
JOIN DimStore dstore ON s.store_name = dstore.store_name 
                     AND COALESCE(dstore.city, '') = COALESCE(s.store_city, '') 
                     AND COALESCE(dstore.country_key, -1) = COALESCE(dscy_join.country_key, -1)

LEFT JOIN DimCountry dsupcy_join ON s.supplier_country = dsupcy_join.country_name
JOIN DimSupplier dsup ON s.supplier_name = dsup.supplier_name 
                      AND COALESCE(dsup.supplier_email, '') = COALESCE(s.supplier_email, '')
WHERE
    s.id_source IS NOT NULL 
    AND safe_to_date(s.sale_date_text, 'MM/DD/YYYY') IS NOT NULL
    AND s.customer_email IS NOT NULL AND s.customer_email <> ''
    AND s.seller_email IS NOT NULL AND s.seller_email <> ''
    AND s.product_name IS NOT NULL AND s.product_name <> ''
    AND s.store_name IS NOT NULL AND s.store_name <> ''
    AND s.supplier_name IS NOT NULL AND s.supplier_name <> ''
ON CONFLICT (sale_id_source) DO NOTHING;