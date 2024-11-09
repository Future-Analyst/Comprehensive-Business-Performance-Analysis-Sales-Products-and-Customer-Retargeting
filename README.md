

# Comprehensive Business Performance Analysis: Sales, Products, and Customer Retargeting

### Dashboard Link : https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSection?experience=power-bi

## Problem Statement

In today’s highly competitive retail environment, businesses face the challenge of optimizing sales performance, enhancing customer engagement, and maximizing profitability across various product offerings and locations. Despite having access to a vast multi-dimensional sales database, there is a lack of in-depth insights into key performance drivers, including customer behavior, product performance, regional profitability, and the effectiveness of sales teams. Specifically, businesses struggle to identify and retarget customers who have become inactive, optimize their product portfolio, evaluate sales team efficiency, and assess regional store performance to drive profitability.
There is also a need for a comprehensive approach to understand transaction dynamics, such as the impact of shipping and delivery status, and to determine the performance of various sales channels. Without a systematic analysis of these factors, companies may miss opportunities for re-engaging customers, optimizing product offerings, improving sales team performance, and enhancing location-based strategies.

## Goals
This analysis leverages a multi-dimensional sales database to extract key insights into customer behavior, product performance, sales team effectiveness, and location profitability. Key objectives of focus include:

1.	Customer Retargeting: Identifying opportunities for re-engaging customers by analyzing their last purchase dates and total transactions. A segment of customers who have not made a purchase in over 12 days is flagged for remarketing.
2.	Product Insights: Analyzing product performance by calculating total revenue, profit margins, and identifying the top and least performing products in terms of profitability. A detailed table highlights total transactions, sales quantities, revenue, COGS, and profit margins for each product.
3.	Location and Region Analysis: Examining store locations based on city, state, and region for profitability. It includes insights on the most profitable store types, cities, and regions, as well as the total number of stores, cities, and states. COGS and total revenue are also analyzed for each location.
4.	Sales Team Performance: Analyzing the performance of sales teams based on total revenue generated. The top-performing sales teams and regions are highlighted, with further details on transactions, revenue, COGS, and profit margins.
5.	Transaction Insights: Evaluating overall sales performance, including total quantity ordered, revenue, gross profit, and performance based on different shipping and delivery statuses (e.g., early, late, very late). It also examines the performance of different sales channels (In-Store, Online, Distributor, and Wholesale).
This comprehensive analysis provides actionable insights for enhancing sales strategies, improving customer retention, optimizing product offerings, and maximizing profitability across locations and regions.

##      Steps followed for the Navigation Visual (Home View)
•	Step 1 : Load all data into Power BI Desktop, dataset is a csv file.   
•	Step 2 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.   
•	Step 3 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".   
•	Step 4 : It was observed that in none of the columns errors & empty values were present.   
•	Step 5: Creating Data Model by creating star schema and snownflask relationship.

Data Modeling Image View
![data model](https://github.com/user-attachments/assets/93c992b3-7500-4dc6-86f7-e2e0f97c1860)

•	Step 6: calculation of Primary KPI’s such as the number of products, number of Customers, number of Store Locations, number of sales teams and number of year.

The following DAX expressions were written to execute the calculations:  

i)      number of Products (distinct number of products)

        # Products = 
        DISTINCTCOUNT(FactTable[_ProductID])

ii)	number of Customers (distinct number of Customers) 

        Customers = 
        DISTINCTCOUNT(FactTable[_CustomerID])

iii)	   number of Store Locations (distinct number of Store Location)  

        Store Location = 
        DISTINCTCOUNT(Dim_StoreLocations[State])


iv)	number of Sales Team (distinct number of Sales Team)

 	Sales Team = 
 	DISTINCTCOUNT(FactTable[_SalesTeamID]) 

v)	number of year data

 	Years = 
 	DISTINCTCOUNT('Calender'[Year]) 
        
vi)	number of Transaction

        Transaction = 
        FORMAT(COUNTROWS(FactTable) , "0,00")

The Home View is Kind of a Navigation Report which is integrated with the Primary KPI’s of the Business. We Divided this Project Into six (6) Dashboard with Strategic Insight at each category which are Customers Re-targeting, Product Insight, Store Locations, Sales Team, Order/Product and Time Range Analysis. Below is the Home View Navigation Dashboard to Every other category of this project:

image of the Home View Dashboard
![Home View](https://github.com/user-attachments/assets/63b56a56-4cdf-467f-b8ea-43513bb6efa7)

###      Steps followed for the Customer Analysis Dashboard Visual

Step 1: We design our Skeleton dashboard, design the Dashboard and import the png into power-bi.

Step 2: we create the Primary KPI’s for Customer Analysis which are the Total Customers and Total Transactions.

The following DAX expression were written:

a)  Total number of Customer

        Customers = 
        DISTINCTCOUNT(FactTable[_CustomerID])

![No_Customer kpi img](https://github.com/user-attachments/assets/1fe68b9a-1a36-462c-a373-063309a4316b)

b)	Total number of Transactions

        Transaction = 
        FORMAT(COUNTROWS(FactTable) , "0,00")

![No_Transaction kpi img](https://github.com/user-attachments/assets/1f15d842-9179-44e9-811c-afe3fe594693)

Step 3:  we create a Horizontal Column chart to show customer Re-Targeting 

###     The following DAX expressions was written:

a)      Last Purchase: 	This measure calculates the most recent data.

        Last Purchase Date =	
                LASTDATE(FactTable[OrderDate])
b)	Date SLP: The overall purpose of this DAX expression is to calculate the time (in days) since the last purchase date compared to the most recent order date in the dataset.

        Date SLP =
        VALUE(CALCULATE(MAX(FactTable[OrderDate]), ALL(FactTable))-[Last Purchase Date] )

c)	The purpose of the Remarketing measure is to identify and segment customers who have not made a purchase in the last 12 days or more.

        Remarketing = 
        IF([Date SLP] >= 12, [Date SLP], BLANK())

image of remarketing visual
![marketting img](https://github.com/user-attachments/assets/e7ceae67-33b1-4658-9ff1-d8428b07b62b)

### Publishing of Customers Analysis Dashboard

link: https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSection14eb3b759309e0d6790d?experience=power-bi

![publishing Regional sales](https://github.com/user-attachments/assets/068028f3-1b3b-4fa8-a01a-906882d8aa3f)

![Customer Analysis img](https://github.com/user-attachments/assets/796c7602-8093-4e1d-814e-216e6e30e039)

###     Steps followed for the Product Analysis Dashboard Visual

Step 1:  We design our Skeleton dashboard, design the Dashboard and import the png into power-bi.  

Step 2:  we create a visual to show us the TOP-5 Products by Sales.

####    The following DAX expression were written:

a)	Total Revenue: The overall calculation thus gives the total revenue by multiplying the order quantity by the effective unit price for each transaction and summing these values across all transactions in the FactTable.

We first create a DAX expression for total revenue:

        Total Revenue = 
        SUMX(FactTable, FactTable[Order Quantity]*FactTable[Unit Price]*(1-FactTable[Discount Applied]))
 
We then create a horizontal column chart afterwards we filter the top=5 products with highest revenue. Below is the visual.

![top 5 best sales product](https://github.com/user-attachments/assets/05f9f47b-3bf7-40d6-a675-369471cfc186)

Step 2:  we create a visual to show us the TOP-5 Products by Profit.

The following DAX expression were written:

a)	Profit Margin: The purpose of this code or formula is to determine the gross profit of a business, which helps evaluate the efficiency of production and sales

We first create a DAX expression for Cost of Goods  Sold [CODS]: 

        COGS = 
        SUMX(FactTable, FactTable[Order Quantity]*FactTable[Unit Cost])

Afterwards we create a DAX expression for Profit Margin and the create a visual tha filters the top 5 Products with Highest Profits:

	Profit margin = [Total Revenue]-[COGS]

below is the visual showing the top 5 products by profit:

![top-5 product by profit](https://github.com/user-attachments/assets/f9cc2da1-e4a2-4caa-94b4-8adf18eaa906)

##      Publishing of Product Analysis Dashboard

link: https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSection055db8a1063ec4d98113?experience=power-bi

![Product Analysis Dashboard img](https://github.com/user-attachments/assets/21b35a31-a63e-49f5-a661-8bfa7b5a102f)

Steps followed for the Location Analysis Dashboard Visual 

Step 1:  We design our Skeleton dashboard, design the Dashboard and import the png into power-bi.
Step2: we first calculate the Number of Cities and the Number of States.  

The following DAX expression is written: 

        states = DISTINCTCOUNT(Dim_Regions[State])

        cities = DISTINCTCOUNT(Dim_StoreLocations[City Name]) 

Step 3:  we create a visual to show us the TOP-3 Profitable location.

Step 4: we fit the profit margin into a horizontal column of chart with type of location and then filter the Highest profitable location.

Below is the visual:

![top-3 profitable location](https://github.com/user-attachments/assets/c6255e5d-062e-442d-9f67-17ff2f403075)

Step 5:   we create a visual to show us the TOP-3 Profitable Cities. 

Step 6:     we fit the profit margin into a horizontal column chart with cities and then   filter the Highest profitable location.

Below is the visual:

![top-3 profitable location](https://github.com/user-attachments/assets/f7d03a1e-5ad0-4984-a406-c4cce7964ed8)

## Publishing the Location Analysis Dashboard

link: https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSectioncbf0259ab8e12d3623b0?experience=power-bi

![Location Analysis Dashboard](https://github.com/user-attachments/assets/2401de59-55c9-4b96-84d5-7cf59a0cda5d)


##      Steps followed for the Sales Team Analysis Dashboard Visual

Step 1:  We design our Skeleton dashboard, design the Dashboard and import the png into power-bi.

Step 2:  we design a stacked column chart visual for Sale Region . this visual takes the revenue measure and the region field in the region dimensional table.

Below is the visual:

![Top-3 sales team](https://github.com/user-attachments/assets/1ccfe1f7-1e58-4936-a8bd-beab5106421a)



## Publishing the Sales Team Analysis Dashboard

link: https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSection1245025ceb7b60c850d7?experience=power-bi

![Sales Team Analysis DashBoard](https://github.com/user-attachments/assets/78f965fc-be7e-490d-a83e-8929cd970163)

##      Steps followed for the Transaction Analysis Dashboard Visual

link:https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSection1245025ceb7b60c850d7?experience=power-bi  

Step 1:  We design our Skeleton dashboard, design the Dashboard and import the png into power-bi.

Step 2:  We design the primary KPI’s for Quantity Ordered and Revenue and Gross Profit.

Below are the DAX expression written and the Visual of the respective KPI.

i)	DAX for Total Quantity Ordered:

        Ordered Qty = 
        SUM(FactTable[Order Quantity]) 

![Quantity Ordered KPI](https://github.com/user-attachments/assets/8ddd90e3-2902-4e5b-a9f5-c90d2d897e07)

ii)     DAX for Total Revenue: 

        Total Revenue = SUMX(FactTable, FactTable[Order Quantity]*FactTable[Unit Price]*(1-FactTable[Discount Applied]))

![Total Revenue KPI](https://github.com/user-attachments/assets/08188d43-9d06-4bc0-983f-47f51e8ea1a2)

iii)    DAX for Gross Profit: 

        Profit margin = [Total Revenue]-[COGS] 

![Gross Profit kPI](https://github.com/user-attachments/assets/9537cfa9-f9ce-4eb7-9f57-16f72b01d981)

## Publishing the Transaction Analysis Dashboard

link:  https://app.powerbi.com/groups/me/reports/ee3f4514-4112-4b86-9b10-fc715e9801b5/ReportSectionbeb08234ae853e7069a6?experience=power-bi

![Transaction Analysis Dashboard](https://github.com/user-attachments/assets/a290f5ad-3243-4383-8a24-95ee566722bf)

## Summary Insight Visual

![summary insight](https://github.com/user-attachments/assets/d0992709-9037-47ae-bf89-51034580bbc9)

## Publishing Time Range Analysis Dashboard 

![Time Range Analysis Dashboard](https://github.com/user-attachments/assets/653d5882-42dc-46e1-9d1b-26f74c1019c4)

## Key Elements of the Dashboard

####    i)	First on this dashboard above we have three 
(3) main slicers which we classify as follows:

o	Active Measure Slicer:   This slicer contains the following key measures Cost of Goods (COGS), Gross Profit, Revenue, Ordered Qty and Transaction.  

o	Sales Team Slicer:  This slicer contains all the names of the sales personels in the organisation.   

o	Store Location Slicer:  This slicers contains  all the organisation Store Locations.  

####    ii)     we designed three important KPI to give us an insight based on the selected slicers we have. The  KPI’s are the Total Cost of Goods Sold (COGS), Total Revenue and Gross Profit.

####    iii)     added a Stacked Column chart to display the result based on the selected key slicers for the three(3) given years of data sales 2018, 2019 and 2020. 
Below is a simple image of this chart for Gross profit As Active mesure, Carlos Miller As Sales Team and Ada country As Store Location.

![stackedColumnsChart img](https://github.com/user-attachments/assets/2a1ec20b-1ee3-4b8b-ae3a-1572d772005d)

The above visual gives insiigh into the Gross Profit for each year 2018, 2019 and 2020 by Carlos Miller As Sales Team and Ada country As Store Location. We can also conclude that No profit was made in 2019 and 2020 made the Highest Gross profit.


####    iv)	added a pie chart to display the result based on the selected key slicers for the four.(4) quarters (i.e Q1, Q2, Q3 and Q4). Below is a simple image of this chart for Gross profit As Active mesure, Carlos Miller As Sales Team and Ada country As Store Location. Below is the image of the visual.

![Quarterly trends](https://github.com/user-attachments/assets/d50bb1c0-4aed-4cf1-883a-53906db347b5)


v)	added a column stacked chart to display weekly Trends by days based on the selected key Slicers in the Dashboard.

vi)	added a Line chart to display weekly Trends by months based on the selected key Slicers in the Dashboard.

###     Goal of the Time Range Dashboard
The primary purpose of the Time Range Dashboard is to provide insights based on the three key slicers, allowing users to analyze trends on a yearly, quarterly, monthly, and weekly basis.
















