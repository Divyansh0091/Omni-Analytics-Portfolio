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
