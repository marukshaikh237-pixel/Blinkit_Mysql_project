USE blinkit;

SELECT * FROM blinkit_project;

-- 1. Display products with MRP between 100 and 250
SELECT *
FROM blinkit_project
WHERE Item_MRP BETWEEN 100 AND 250
ORDER BY Item_MRP DESC;


-- 2. Count distinct item types
SELECT COUNT(DISTINCT Item_Type) AS Total_Values
FROM blinkit_project;


-- 3. Top 10 highest selling products
SELECT
    Item_Identifier,
    Item_Type,
    Outlet_Identifier,
    Item_Outlet_Sales
FROM blinkit_project
ORDER BY Item_Outlet_Sales DESC
LIMIT 10;

-- 4. Calculate outlet age
SELECT
    Outlet_Identifier,
    Outlet_Establishment_Year,
    YEAR(CURDATE()) - Outlet_Establishment_Year AS Outlet_Age
FROM blinkit_project
ORDER BY Outlet_Establishment_Year;

-- 5. Average MRP by sales
SELECT
    Item_Outlet_Sales,
    ROUND(AVG(Item_MRP),2) AS Avg_Item_MRP
FROM blinkit_project
GROUP BY Item_Outlet_Sales;

-- 6. Average visibility by item type
SELECT
    Item_Type,
    AVG(Item_Visibility) AS Avg_Visibility
FROM blinkit_project
GROUP BY Item_Type;

-- 7. Total sales by item type
SELECT
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales
FROM blinkit_project
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

-- 8. Item types with sales greater than 1,000,000
SELECT
    Item_Type,
    ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales
FROM blinkit_project
GROUP BY Item_Type
HAVING Total_Sales > 1000000
ORDER BY Total_Sales DESC;

-- 9. Categorize products based on sales
SELECT
    Item_Identifier,
    Item_Type,
    Item_Outlet_Sales,
    CASE
        WHEN Item_Outlet_Sales < 2000 THEN 'LOW SALES'
        WHEN Item_Outlet_Sales BETWEEN 2000 AND 5000 THEN 'MEDIUM SALES'
        ELSE 'HIGH SALES'
    END AS Sales_Category
FROM blinkit_project;

-- 10. Top 5 outlets by total sales
SELECT
    Outlet_Identifier,
    ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales
FROM blinkit_project
GROUP BY Outlet_Identifier
ORDER BY Total_Sales DESC
LIMIT 5;

-- 11. Products with above average sales
SELECT *
FROM blinkit_project
WHERE Item_Outlet_Sales >
(
    SELECT AVG(Item_Outlet_Sales)
    FROM blinkit_project
);

-- 12. Create View
CREATE VIEW High_Sales_Products AS
SELECT
    Item_Identifier,
    Item_MRP,
    Item_Type,
    Item_Outlet_Sales
FROM blinkit_project
WHERE Item_Outlet_Sales > 5000;

SELECT *
FROM High_Sales_Products;

-- 13. Create Index on Item_Type
CREATE INDEX idx_item_type
ON blinkit_project(Item_Type);

-- Search using index
SELECT
    Item_Type,
    Item_Identifier
FROM blinkit_project
WHERE Item_Type = 'Canned';

-- 14. Create Index on Outlet_Size
CREATE INDEX idx_outlet_size
ON blinkit_project(Outlet_Size);

-- Search using index
SELECT *
FROM blinkit_project
WHERE Outlet_Size = 'Medium';

-- 15. Stored Procedure
DELIMITER $$

CREATE PROCEDURE GetOutletRecord(IN records VARCHAR(100))
BEGIN
    SELECT *
    FROM blinkit_project
    WHERE Outlet_Identifier = records;
END $$

DELIMITER ;

CALL GetOutletRecord('OUT019');

-- 16. Rank outlets by total sales
SELECT
    Outlet_Identifier,
    ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales,
    RANK() OVER(
        ORDER BY SUM(Item_Outlet_Sales) DESC
    ) AS Sales_Rank
FROM blinkit_project
GROUP BY Outlet_Identifier;

-- 17. Top 3 products by total sales
SELECT
    Item_Identifier,
    ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales,
    RANK() OVER(
        ORDER BY SUM(Item_Outlet_Sales) DESC
    ) AS Sales_Rank
FROM blinkit_project
GROUP BY Item_Identifier
LIMIT 3;

-- 18. Top 3 products in each outlet
SELECT
    Outlet_Identifier,
    Item_Identifier,
    Item_Type,
    Item_Outlet_Sales
FROM
(
    SELECT
        Outlet_Identifier,
        Item_Identifier,
        Item_Type,
        Item_Outlet_Sales,
        DENSE_RANK() OVER(
            PARTITION BY Outlet_Identifier
            ORDER BY Item_Outlet_Sales DESC
        ) AS Sales_Rank
    FROM blinkit_project
) Ranked_Products
WHERE Sales_Rank <= 3
ORDER BY Outlet_Identifier, Sales_Rank;

-- 19. CTE: Total sales by outlet
WITH Outlet_Sales AS
(
    SELECT
        Outlet_Identifier,
        ROUND(SUM(Item_Outlet_Sales)) AS Total_Sales
    FROM blinkit_project
    GROUP BY Outlet_Identifier
)
SELECT
    Outlet_Identifier,
    Total_Sales
FROM Outlet_Sales
WHERE Total_Sales >
(
    SELECT AVG(Total_Sales)
    FROM Outlet_Sales
);
