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


------------------------- LOCATION ANALYSIS --------------------------------------------

-- Top 4 Sales Regions
 
WITH RevenueCTE AS (
    SELECT
        r.Region,
        SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) AS total_revenue
    FROM 
        FactTable ft
    JOIN 
        [Dim_Store location] s ON ft.StoreID = s.StoreID
    JOIN
        Dim_Regions r ON s.StateCode = r.StateCode
    GROUP BY 
        r.Region
)
SELECT 
    Region,
    total_revenue
FROM (
    SELECT 
        Region,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM 
        RevenueCTE
) AS RankedRevenue
WHERE 
    revenue_rank <= 4;

-- Top 3 Sales Teams

WITH RevenueCTE AS (
    SELECT
        st.Sales_Team,
        SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) AS total_revenue
    FROM 
        FactTable ft
    JOIN 
        Dim_SalesTeams st ON ft.SalesTeamID = st.SalesTeamID 
    GROUP BY 
        st.Sales_Team
)
SELECT 
    Sales_Team,
    total_revenue
FROM (
    SELECT 
        Sales_Team,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank
    FROM 
        RevenueCTE
) AS RankedRevenue
WHERE 
    revenue_rank <= 3;

-- Full Sales Details By All SAles Team

SELECT
	Sales_Team AS name_of_sales_team,
	COUNT(ft.OrderNumber) AS total_transactions,
	SUM(ft.Order_Quantity) AS order_qty,
	CEILING(SUM(ft.Order_Quantity * ft.Unit_Cost)) AS COGS,
	CEILING(SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied))) AS total_revenue,
	CEILING(SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM
	factTable ft
JOIN 
	Dim_SalesTeams st ON  ft.SalesTeamID = st.SalesTeamID
GROUP BY Sales_Team;

