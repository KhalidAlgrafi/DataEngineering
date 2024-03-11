{{ config(materialized='incremental', unique_key='CustomerID') }}

WITH source_data AS (
    SELECT
        CustomerID,
        FirstName,
        LastName,
        Email,
        Phone,
        Latitude,
        Longitude,
        creationDate,
        lastUpdateDate
    FROM {{ source('source_data', 'Customers') }}
)

SELECT
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    Latitude,
    Longitude,
    creationDate,
    lastUpdateDate
FROM source_data
{% if is_incremental() %}
    -- This WHERE clause ensures only new or updated records are processed
    WHERE lastUpdateDate > (SELECT ISNULL(MAX(lastUpdateDate), '1900-01-01') FROM {{ this }} )
{% endif %}
