-- models/facts/fact_orders.sql

SELECT
oh.OrderID AS OrderKey,
    ol.ProductID,
    dp.ProductKey,
    oh.CustomerID,
    dc.CustomerKey,
    ol.OrderLineID,
    oh.OrderDate,
    ol.Quantity,
    ol.PricePerUnit,
    ol.Quantity * ol.PricePerUnit AS TotalPrice
FROM {{ source('source_data','OrderLines') }} ol
JOIN {{ source('source_data','OrderHeaders')  }} oh ON ol.OrderID = oh.OrderID
LEFT JOIN {{ ref('dim_products') }} dp ON ol.ProductID = dp.ProductKey
LEFT JOIN {{ ref('dim_customers') }} dc ON oh.CustomerID = dc.CustomerKey;
