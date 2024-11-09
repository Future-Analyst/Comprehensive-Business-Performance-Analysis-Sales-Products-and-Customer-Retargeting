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


-- Total number of pruducts 

SELECT COUNT(1) AS Total_number_of_products FROM Dim_Products;

-- Total number of customers

SELECT COUNT(1) AS Total_number_of_customers FROM Dim_customers;

-- Total number of Store_locations

SELECT COUNT(DISTINCT State) AS number_store_locations from [Dim_Store location]	;

-- Total number of Sales_team

SELECT COUNT(1) AS Total_number_of_products FROM Dim_SalesTeams;

-- Number of Years
SELECT COUNT(DISTINCT YEAR(OrderDate)) FROM FactTable;



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


------------------------- PRODUCT INSIGHT --------------------------------------------

-- Horizontal Bar Chart for Top 5 Total revenue vs Product Name

SELECT TOP 5
    p.Product_Name,
    SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) AS total_revenue
FROM 
    FactTable ft
JOIN 
    Dim_Products p ON ft.ProductID = p.ProductID
GROUP BY 
    p.Product_Name;

-- Horizontal Bar Chart for Top 5 Total revenue vs Product Name 

SELECT TOP 5
    p.Product_Name,
    (SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM 
    FactTable ft
JOIN 
    Dim_Products p ON ft.ProductID = p.ProductID
GROUP BY 
    p.Product_Name
ORDER BY 
    profit_margin DESC;

 -- 5 Least Performing Products 

SELECT TOP 5
    p.Product_Name,
    (SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM 
    FactTable ft
JOIN 
    Dim_Products p ON ft.ProductID = p.ProductID
GROUP BY 
    p.Product_Name
ORDER BY 
    profit_margin ASC;


----- Table of product insight

SELECT
	 p.Product_Name As Product_name,
	 COUNT(OrderNumber) AS Total_Transaction,
	 SUM(Order_Quantity) AS Total_Order_Quantity,
	 SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) AS total_revenue,
	 SUM(ft.Order_Quantity * ft.Unit_Cost) AS COGS,
	 (SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM 
	FactTable ft
JOIN 
    Dim_Products p ON ft.ProductID = p.ProductID
GROUP BY 
    p.Product_Name
ORDER BY 
    profit_margin DESC;

------------------------- LOCATION ANALYSIS --------------------------------------------

-- TOP - 3 PROFITABLE LOCATION TYPE

SELECT TOP 3
    s.Type,
    (SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM 
    FactTable ft
JOIN 
    [Dim_Store location] s ON ft.StoreID = s.StoreID
GROUP BY 
    s.Type
ORDER BY 
    profit_margin DESC;


-- TOP - 3 PROFITABLE LOCATION CITY NAME

SELECT TOP 3
    s.City_Name,
    (SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost)) AS profit_margin
FROM 
    FactTable ft
JOIN 
    [Dim_Store location] s ON ft.StoreID = s.StoreID
GROUP BY 
    s.City_Name
ORDER BY 
    profit_margin DESC;

--- Total Number of States

SELECT	
	 COUNT(DISTINCT State)
FROM
	[Dim_Store location];

--- Total Number of Cities

SELECT	
	 COUNT(DISTINCT City_Name)
FROM
	[Dim_Store location];



-- City_Names,Population,State Vs COGS

SELECT
    s.City_Name,
	s.State,
	s.Population,
    SUM(ft.Order_Quantity * ft.Unit_Cost) AS COGS
FROM 
    FactTable ft
JOIN 
    [Dim_Store location] s ON ft.StoreID = s.StoreID
GROUP BY 
    s.City_Name, s.Population,s.State
ORDER BY 
	COGS DESC;


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


------------------------- TRANSACTION ANALYSIS --------------------------------------------

-- Total Quantity Ordered

SELECT
	CEILING(SUM(Order_Quantity))
FROM
	FactTable;

-- Total Revenue

SELECT
	CEILING(SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied))) AS total_revenue
FROM
	factTable ft
JOIN 
	Dim_SalesTeams st ON  ft.SalesTeamID = st.SalesTeamID


-- Gross Profit

SELECT 
    CEILING((SUM(ft.Order_Quantity * ft.Unit_Price * (1 - ft.Discount_Applied)) - SUM(ft.Order_Quantity * ft.Unit_Cost))) AS profit_margin
FROM 
    FactTable ft
JOIN 
    [Dim_Store location] s ON ft.StoreID = s.StoreID;


--- Total ordered Quantity (Early Shipping)

WITH DateDiff AS (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, OrderDate, ShipDate) AS days_difference
    FROM
        FactTable
),
ShippingStatus AS (
    SELECT 
        Order_Quantity,  -- Include Order_Quantity here too
        days_difference,
        CASE 
            WHEN days_difference BETWEEN 2 AND 12 THEN 'Early Shipping'
            WHEN days_difference BETWEEN 13 AND 20 THEN 'Late Shipping'
            ELSE 'Very Late Shipping'
        END AS shipping_status
    FROM DateDiff
)
SELECT 
    SUM(Order_Quantity) AS total_very_late_shipping 
FROM 
    ShippingStatus
WHERE 
    shipping_status = 'Very Late Shipping';


 --- Total ordered Quantity (Very Late Shipping)

 WITH DateDiff AS (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, OrderDate, ShipDate) AS days_difference
    FROM
        FactTable
),
ShippingStatus AS (
    SELECT 
        Order_Quantity,  -- Include Order_Quantity here too
        days_difference,
        CASE 
            WHEN days_difference BETWEEN 2 AND 12 THEN 'Early Shipping'
            WHEN days_difference BETWEEN 13 AND 20 THEN 'Late Shipping'
            ELSE 'Very Late Shipping'
        END AS shipping_status
    FROM DateDiff
)
SELECT 
    SUM(Order_Quantity) AS total_late_shipping 
FROM 
    ShippingStatus
WHERE 
    shipping_status = 'Late Shipping';


 --- Total ordered Quantity (Early Shipping)

 WITH DateDiff AS (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, OrderDate, ShipDate) AS days_difference
    FROM
        FactTable
),
ShippingStatus AS (
    SELECT 
        Order_Quantity,  -- Include Order_Quantity here too
        days_difference,
        CASE 
            WHEN days_difference BETWEEN 2 AND 12 THEN 'Early Shipping'
            WHEN days_difference BETWEEN 13 AND 20 THEN 'Late Shipping'
            ELSE 'Very Late Shipping'
        END AS shipping_status
    FROM DateDiff
)
SELECT 
    SUM(Order_Quantity) AS total_early_shipping 
FROM 
    ShippingStatus
WHERE 
    shipping_status = 'Early Shipping'
 


--- Total ordered Quantity (Early Delivery)

SELECT 
    SUM(Order_Quantity) AS total_early_delivery 
FROM (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, ShipDate, DeliveryDate) AS days_difference,
        CASE 
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 1 AND 3 THEN 'Early Delivery'
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 4 AND 6 THEN 'Late Delivery'
            ELSE 'Very Late Delivery'
        END AS delivery_status
    FROM 
        FactTable
) AS DeliveryStatus
WHERE 
    delivery_status = 'Early Delivery';

--- Total ordered Quantity (Late Delivery)

SELECT 
    SUM(Order_Quantity) AS total_late_delivery 
FROM (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, ShipDate, DeliveryDate) AS days_difference,
        CASE 
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 1 AND 3 THEN 'Early Delivery'
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 4 AND 6 THEN 'Late Delivery'
            ELSE 'Very Late Delivery'
        END AS delivery_status
    FROM 
        FactTable
) AS DeliveryStatus
WHERE 
    delivery_status = 'Late Delivery';


--- Total ordered Quantity (Early Delivery)

SELECT 
    SUM(Order_Quantity) AS total_very_late_delivery 
FROM (
    SELECT 
        Order_Quantity,  
        DATEDIFF(day, ShipDate, DeliveryDate) AS days_difference,
        CASE 
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 1 AND 3 THEN 'Early Delivery'
            WHEN DATEDIFF(day, ShipDate, DeliveryDate) BETWEEN 4 AND 6 THEN 'Late Delivery'
            ELSE 'Very Late Delivery'
        END AS delivery_status
    FROM 
        FactTable
) AS DeliveryStatus
WHERE 
    delivery_status = 'Very Late Delivery';


--- Total ordered Quantity (Sales Channel -- In-Store)

SELECT 
	SUM(Order_Quantity) AS quantity_ordered
FROM
	FactTable
WHERE
	Sales_Channel = 'In-Store';



--- Total ordered Quantity (Sales Channel -- Online)

SELECT 
	SUM(Order_Quantity) AS quantity_ordered
FROM
	FactTable
WHERE
	Sales_Channel = 'Online';

--- Total ordered Quantity (Sales Channel -- Distributors)

SELECT 
	SUM(Order_Quantity) AS quantity_ordered
FROM
	FactTable
WHERE
	Sales_Channel = 'Distributor';


--- Total ordered Quantity (Sales Channel -- Wholesale)

SELECT 
	SUM(Order_Quantity) AS quantity_ordered
FROM
	FactTable
WHERE
	Sales_Channel = 'Wholesale';