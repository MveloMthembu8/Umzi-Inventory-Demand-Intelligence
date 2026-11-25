-- ==========================================
-- UMZI WHOLESALE & DISTRIBUTION
-- Inventory & Demand Analysis
-- ==========================================


-- QUERY 1: Sales Performance by Product

SELECT
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_revenue_zar)::numeric, 2) AS total_revenue
FROM umzi_inventory.inventory_transactions
WHERE transaction_type = 'Sale'
  AND transaction_status = 'Completed'
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- QUERY 2: Stockouts and Lost Revenue

SELECT
    product_name,
    SUM(unfilled_quantity) AS unfulfilled_units,
    ROUND(
        SUM(unfilled_quantity * unit_selling_price_zar)::numeric,
        2
    ) AS estimated_lost_revenue
FROM inventory_demand_cleaned idc 
WHERE transaction_type = 'Sale'
  AND transaction_status = 'Completed'
GROUP BY product_name
HAVING SUM(unfilled_quantity) > 0
ORDER BY estimated_lost_revenue DESC
LIMIT 10;


-- QUERY 3: Supplier Delivery Performance

SELECT
    supplier_name,
    COUNT(*) AS total_deliveries,
    COUNT(*) FILTER (
        WHERE actual_delivery_date > expected_delivery_date
    ) AS late_deliveries,
    ROUND(
        COUNT(*) FILTER (
            WHERE actual_delivery_date > expected_delivery_date
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate
from inventory_demand_cleaned idc 
WHERE transaction_type = 'Purchase'
  AND transaction_status = 'Completed'
  AND actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL
GROUP BY supplier_name
ORDER BY late_delivery_rate DESC;


-- QUERY 4: Monthly Revenue Trends

SELECT
    DATE_TRUNC('month', transaction_date::date)::date AS sales_month,
    ROUND(SUM(total_revenue_zar)::numeric, 2) AS monthly_revenue
FROM inventory_demand_cleaned idc 
WHERE transaction_type = 'Sale'
  AND transaction_status = 'Completed'
GROUP BY sales_month
ORDER BY sales_month;