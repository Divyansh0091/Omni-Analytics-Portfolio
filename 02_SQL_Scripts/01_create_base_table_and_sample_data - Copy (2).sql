-- ==========================================================
-- STEP 01: Create Base Schema and Insert Raw Sample Data
-- ==========================================================

-- Drop the table if it already exists to start fresh
DROP TABLE IF EXISTS fct_Sales_Raw;

-- Create the primary raw sales table structure
CREATE TABLE fct_Sales_Raw (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Order_Date DATE,
    Customer_Name VARCHAR(50),
    Region VARCHAR(20),
    Category VARCHAR(50),
    Sales DECIMAL(10, 2),
    Profit DECIMAL(10, 2)
);

-- Insert initial 30 base sample rows containing dirty values, typos, and NULLs
INSERT INTO fct_Sales_Raw (Order_ID, Order_Date, Customer_Name, Region, Category, Sales, Profit) 
VALUES
('ORD-1001', '2025-01-05', 'Amit Soni', 'North', 'Electronics', 450.00, 90.00),
('ORD-1002', '2025-01-08', NULL, 'South', 'Electrnc', 1200.50, 240.00),
('ORD-1003', '2025-01-12', 'Rahul Dev', 'East', 'Furniture', NULL, NULL),
('ORD-1004', '2025-01-15', 'Divyansh', NULL, 'Furnitr', 300.00, 60.00),
('ORD-1005', '2025-01-18', 'Sneha', 'West', 'Books', 150.00, 45.00),
('ORD-1006', '2025-01-20', NULL, 'North', 'Electronics', 800.00, 160.00),
('ORD-1007', '2025-01-22', 'Vikram', 'South', 'Electrnc', NULL, NULL),
('ORD-1008', '2025-01-25', 'Amit Soni', NULL, 'Furniture', 950.00, 190.00),
('ORD-1009', '2025-01-28', 'Rahul Dev', 'East', 'Books', 200.00, 60.00),
('ORD-1010', '2025-02-01', NULL, 'West', 'Elec', 1100.00, 220.00),
('ORD-1011', '2025-02-03', 'Divyansh', 'North', 'Furnitr', NULL, NULL),
('ORD-1012', '2025-02-05', 'Sneha', NULL, 'Electronics', 600.00, 120.00),
('ORD-1013', '2025-02-08', 'Vikram', 'South', 'Books', 350.00, 105.00),
('ORD-1014', '2025-02-10', NULL, 'East', 'Electrnc', 400.00, 80.00),
('ORD-1015', '2025-02-12', 'Amit Soni', 'West', 'Furniture', 750.00, 150.00),
('ORD-1016', '2025-02-15', 'Rahul Dev', 'North', 'Books', 250.00, 75.00),
('ORD-1017', '2025-02-18', NULL, NULL, 'Electronics', 1300.00, 260.00),
('ORD-1018', '2025-02-20', 'Divyansh', 'South', 'Furnitr', NULL, NULL),
('ORD-1019', '2025-02-22', 'Sneha', 'East', 'Books', 500.00, 150.00),
('ORD-1020', '2025-02-25', 'Vikram', 'West', 'Electronics', 900.00, 180.00),
('ORD-1021', '2025-02-28', NULL, 'North', 'Electrnc', 350.00, 70.00),
('ORD-1022', '2025-03-02', 'Amit Soni', NULL, 'Furniture', 650.00, 130.00),
('ORD-1023', '2025-03-05', 'Rahul Dev', 'South', 'Books', 450.00, 135.00),
('ORD-1024', '2025-03-08', NULL, 'East', 'Electronics', 1500.00, 300.00),
('ORD-1025', '2025-03-10', 'Divyansh', 'West', 'Furnitr', NULL, NULL),
('ORD-1026', '2025-03-12', 'Sneha', 'North', 'Books', 300.00, 90.00),
('ORD-1027', '2025-03-15', 'Vikram', NULL, 'Electronics', 850.00, 170.00),
('ORD-1028', '2025-03-18', NULL, 'South', 'Electrnc', 700.00, 140.00),
('ORD-1029', '2025-03-20', 'Amit Soni', 'East', 'Furniture', 950.00, 190.00),
('ORD-1030', '2025-03-22', 'Rahul Dev', 'West', 'Books', 200.00, 60.00);

-- Verify initial data insertion
SELECT * FROM fct_Sales_Raw;

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

-- ==========================================================
-- STEP 03: Data Cleaning - Handle NULLs, Typos, and Standardization
-- ==========================================================

-- Creating a reporting view/table to display cleaned dataset
CREATE TABLE fct_Sales_Cleaned AS
SELECT 
    Order_ID,
    Order_Date,
    
    -- Handle missing/NULL Customer names
    COALESCE(Customer_Name, 'Unknown Customer') AS Cleaned_Customer,
    
    -- Handle missing/NULL Regions
    COALESCE(Region, 'Not Specified') AS Cleaned_Region,
    
    -- Standardize inconsistent Category typos (Electrnc/Elec -> Electronics, etc.)
    CASE 
        WHEN Category IN ('Electrnc', 'Elec', 'Electronics') THEN 'Electronics'
        WHEN Category IN ('Furnitr', 'Furniture') THEN 'Furniture'
        ELSE 'Other Categories' 
    END AS Cleaned_Category,
    
    -- Impute missing Sales values with 0
    COALESCE(Sales, 0) AS Cleaned_Sales,
    
    -- Impute missing Profit values with 0
    COALESCE(Profit, 0) AS Cleaned_Profit

FROM fct_Sales_Raw;

-- Display final cleaned records to validate everything is perfectly aligned
SELECT * FROM fct_Sales_Cleaned;