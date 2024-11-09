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


