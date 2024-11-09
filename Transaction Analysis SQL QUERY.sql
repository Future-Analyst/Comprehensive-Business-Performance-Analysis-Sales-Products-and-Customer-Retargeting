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