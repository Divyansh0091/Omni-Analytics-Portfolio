-- ==========================================================
-- STEP 02: Generate Data up to 1,000 Rows via Recursive CTE
-- ==========================================================

-- Note: This will overwrite the raw table combining base samples + generated rows up to 1000
DROP TABLE IF EXISTS fct_Sales_Raw;

CREATE TABLE fct_Sales_Raw AS
WITH RECURSIVE Gen_Numbers AS (
    SELECT 1 AS n UNION ALL SELECT n + 1 FROM Gen_Numbers WHERE n < 1000
)
SELECT 
    'ORD-' || LPAD(n::TEXT, 4, '0') AS Order_ID,
    CURRENT_DATE - (n % 365) AS Order_Date, 
    CASE 
        WHEN n % 7 = 0 THEN NULL 
        WHEN n % 7 = 1 THEN 'Amit Soni'
        WHEN n % 7 = 2 THEN 'Rahul Dev'
        WHEN n % 7 = 3 THEN 'Divyansh'
        WHEN n % 7 = 4 THEN 'Sneha'
        WHEN n % 7 = 5 THEN 'Vikram'
        ELSE 'Anjali'
    END AS Customer_Name,
    CASE 
        WHEN n % 5 = 0 THEN NULL
        WHEN n % 5 = 1 THEN 'North'
        WHEN n % 5 = 2 THEN 'South'
        WHEN n % 5 = 3 THEN 'East'
        ELSE 'West'
    END AS Region,
    CASE 
        WHEN n % 6 = 0 THEN 'Electrnc'
        WHEN n % 6 = 1 THEN 'Electronics'
        WHEN n % 6 = 2 THEN 'Furnitr'
        WHEN n % 6 = 3 THEN 'Furniture'
        WHEN n % 6 = 4 THEN 'Books'
        ELSE 'Elec'
    END AS Category,
    CASE 
        WHEN n % 4 = 0 THEN NULL
        ELSE ROUND(((n % 500) * 10.5)::numeric, 2)
    END AS Sales,
    CASE 
        WHEN n % 4 = 0 THEN NULL
        ELSE ROUND(((n % 500) * 2.1)::numeric, 2)
    END AS Profit
FROM Gen_Numbers
LIMIT 1000;

-- Verify the 1,000 generated records
SELECT * FROM fct_Sales_Raw;
