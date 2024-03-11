-- models/dimensions/dim_products.sql

{{ config(materialized='incremental', unique_key='ProductID') }}

WITH product_category_joined AS (
    SELECT
        p.ProductID,
        p.ProductName,
        pc.CategoryName,
        p.Price,
        p.creationDate,
        COALESCE(p.lastUpdateDate, p.creationDate) AS lastUpdateDate
    FROM {{source('source_data', 'Products')}} p
    JOIN {{source('source_data', 'ProductCategories')}} pc
		ON p.ProductCategoryID = pc.ProductCategoryID
)

SELECT
    ProductID,
    ProductName,
    CategoryName,
    Price,
    creationDate,
    lastUpdateDate
FROM product_category_joined

{% if is_incremental() %}
    -- This WHERE clause ensures only new or updated records are processed
    WHERE lastUpdateDate > (SELECT ISNULL(MAX(lastUpdateDate), '1900-01-01') FROM {{ this }} )
{% endif %};

