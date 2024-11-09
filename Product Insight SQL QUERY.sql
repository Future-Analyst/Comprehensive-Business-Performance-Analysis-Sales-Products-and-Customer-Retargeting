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
