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

