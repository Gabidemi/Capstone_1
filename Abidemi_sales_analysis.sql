USE sample_sales;

SELECT * FROM store_locations WHERE State = 'Connecticut'; -- Shows the Store Locations and store IDs of the stores in Connecticut
SELECT * FROM inventory_categories; -- Dsplays the CategoryID and categories of the types of items they sell
SELECT * FROM inventory_subcategories; -- Displays the subcategory ID, categoryID and subcategories of the items they sell
SELECT * FROM management; -- This data shows the sales manager, Region as well as an ID and REGION reference
SELECT * FROM online_sales; -- This data shows the ID, salestotal, product_number and date of items
SELECT * FROM products; -- Data shows the Category ID, subcategory ID, Productname and productnumber
SELECT * FROM shipper_list; -- Data shows the ID, preferredShipper and discount for orders shipped to Connecticut
SELECT * FROM store_sales; -- Shows the product number, sale amount and storeID as well as the id of the stores 

/*
What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers?
*/
-- Total in-store Connecticut sales
SELECT store_locations.State AS State, SUM(Sale_Amount) AS TotalSales, MIN(Transaction_Date) AS StartDate, MAX(Transaction_Date) AS EndDate 
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE store_locations.State = 'Connecticut'
ORDER BY Sale_Amount DESC, Transaction_Date DESC;


-- What is the revenue breakdown by year and month for the sales territory
-- In store sales
SELECT SUM(Sale_Amount) AS CombinedSales, MONTHNAME(Transaction_Date) AS TransactionMonth, YEAR(Transaction_Date) AS TransactionYear 
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE store_locations.State = 'Connecticut'
GROUP BY TransactionYear, MONTH(Transaction_Date), TransactionMonth
ORDER BY MONTH(Transaction_Date) ASC, TransactionYear ASC;

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to
-- Total Connecticut Revenue
SELECT SUM(Sale_Amount) 
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE store_locations.State = 'Connecticut';
    
-- Total in store EAST region revenue
SELECT SUM(store_sales.Sale_Amount) AS RegionRevenue 
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
JOIN management
ON store_locations.State = management.State
WHERE management.Region = 'EAST';

-- Put each side by side and add the totals
SELECT (
	SELECT SUM(Sale_Amount) 
	FROM store_sales
	JOIN store_locations
	ON store_sales.Store_ID = store_locations.StoreID
	WHERE store_locations.State = 'Connecticut') AS TotalConnecticutSale 
    ,
	(SELECT SUM(store_sales.Sale_Amount) FROM store_sales
	JOIN store_locations
	ON store_sales.Store_ID = store_locations.StoreID
	JOIN management
	ON store_locations.State = management.State
	WHERE management.Region = 'EAST'
) AS TotalRegionRevenue;

/*
What is the number of transactions per month and average transaction amount by product
category for the sales territory?
*/
SELECT MONTHNAME(store_sales.Transaction_Date) AS SalesMonth, products.CategoryID, inventory_categories.Category, COUNT(*) AS TransactionCount, 
CONCAT('$', ROUND(AVG(store_sales.Sale_Amount),2)) AS Average
FROM store_sales 
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreId
JOIN products
ON store_sales.Prod_Num = Products.ProdNum
JOIN inventory_categories
ON products.Categoryid = inventory_categories.Categoryid
WHERE store_locations.State = 'Connecticut'
GROUP BY SalesMonth, products.CategoryID, inventory_categories.Category;


/*
Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
ranking of online sales performance by state within an online sales territory?
*/
SELECT SUM(store_sales.Sale_Amount) AS 'Sales', store_sales.Store_ID, store_locations.Storelocation, store_locations.State
FROM store_sales
JOIN store_locations
ON store_sales.Store_ID = store_locations.StoreID
WHERE store_locations.State = 'Connecticut'
GROUP BY store_sales.Store_ID, store_locations.State, store_locations.StoreLocation
ORDER BY Sales DESC;






