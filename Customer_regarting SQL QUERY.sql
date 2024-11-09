USE Regional_Sales_DB;

SELECT * FROM Dim_customers; --CustomerID, Customers_Names

SELECT * FROM Dim_Products; -- ProductID, Product_Name

SELECT * FROM Dim_Regions; -- StateCode, State, Region

SELECT * FROM Dim_SalesTeams; -- SalesTeamID, Sales_Team, Region

SELECT * FROM [Dim_Store location]; -- StoreID, City_Names, Country, StateCode, State, Type, latitude,
									-- Longitude, AreaCode, Population, Household_Income, Land_Area
									-- Water_Area, Time_Zone.

SELECT * FROM FactTable; --OrderNumber, Sales_Channel, WaterhouseCode, ProcedureDate, OrderDate, ShipDate
						 -- DeliveryDate, CurrencyCode, SalesTeamID, CustomerID, StoreID
						 -- ProductID, Order_Qunatity, Discount_Applied, Unit_Price, Unit_Cost


-------------Customer Retargetting------------------------------------------------------

-- Number of Customers who patronised the business

SELECT COUNT(DISTINCT CustomerID ) FROM FactTable;

-- Number of Transactions

SELECT COUNT(*) FROM FactTable;

-- Customer retagetting table

WITH LastPurchase AS (
    SELECT MAX(OrderDate) AS OverallLastPurchaseDate
    FROM FactTable
)
SELECT 
	dc.Customer_Names,
    MAX(ft.OrderDate) AS LastPurchaseDate,
    DATEDIFF(DAY, MAX(ft.OrderDate), lp.OverallLastPurchaseDate ) AS Date_SLP,
    COUNT(*) AS Total_Transaction
FROM 
    FactTable ft
JOIN 
    Dim_customers dc ON ft.CustomerID = dc.CustomerID
CROSS JOIN 
    LastPurchase lp
GROUP BY 
    dc.Customer_Names, lp.OverallLastPurchaseDate;

-- Customers retargetting chart

WITH LastPurchase AS (
    SELECT MAX(OrderDate) AS OverallLastPurchaseDate
    FROM FactTable
)
SELECT TOP 5
    dc.Customer_Names,
    CASE 
        WHEN DATEDIFF(DAY, MAX(ft.OrderDate), lp.OverallLastPurchaseDate) >= 12 THEN DATEDIFF(DAY, MAX(ft.OrderDate), lp.OverallLastPurchaseDate)
        ELSE NULL 
    END AS Remarketing
FROM 
    FactTable ft
JOIN 
    Dim_customers dc ON ft.CustomerID = dc.CustomerID
CROSS JOIN 
    LastPurchase lp
GROUP BY 
    dc.Customer_Names, lp.OverallLastPurchaseDate
ORDER BY Remarketing DESC;
