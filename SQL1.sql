/*
SQL Queries of AdventureWorks Database
*/

--1.From the following table write a query in SQL to retrieve all rows and columns from the employee table in the Adventureworks database. 
--Sort the result set in ascending order on jobtitle.
Select *
From 
	HumanResources.Employee
ORDER BY 
	HumanResources.Employee.JobTitle 

--2. From the following table write a query in SQL to return all rows and a subset of the columns (FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. 
--The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.
Select 
	p.FirstName,
	p.LastName,
	p.BusinessEntityID AS Employee_id	
From Person.Person AS p
Order by p.LastName;

/*
3.From the following table write a query in SQL to return only the rows for product that have a sellstartdate that is not NULL and a productline of 'T'. 
Return productid, productnumber, and name. Arranged the output in ascending order on name.
*/

Select
	p.productid,
	p.productnumber,
	p.name

From production.Product AS p

Where
	p.productline='T' AND
	p.sellstartdate is not null
Order by p.name;
/*
4. From the following table write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database.
Return jobtitle column and arranged the resultset in ascending order.
*/

Select DISTINCT 
	e.JobTitle
From 
	HumanResources.Employee AS e
Order by e.JobTitle;

/*
5.From the following table write a query in SQL to return all rows from the salesorderheader table in Adventureworks database and calculate the percentage of tax on the subtotal have decided.
Return salesorderid, customerid, orderdate, subtotal, percentage of tax column.
Arranged the result set in ascending order on subtotal
*/
SELECT
	s.SalesOrderID,
	s.CustomerID,
	s.OrderDate,
	s.SubTotal,
	(s.TaxAmt*100)/s.SubTotal as Tax
FROM 
	Sales.salesorderheader as s
Order by s.SubTotal DESC;

/*
6.From the following table write a query in SQL to calculate the total freight paid by each customer.
Return customerid and total freight. Sort the output in ascending order on customerid.
*/
Select 
	s.CustomerID,
	sum(s.Freight) as Total_Freight
From 
	Sales.salesorderheader as s
Group BY s.CustomerID
Order by s.CustomerID ASC
/*
 8.From the following table write a query in SQL to find the average and the sum of the subtotal for every customer.
 Return customerid, average and sum of the subtotal.
 Grouped the result on customerid and salespersonid. Sort the result on customerid column in descending order
*/
Select
	s.CustomerID,
	AVG(s.SubTotal) AS Average_Total,
	Sum(s.SubTotal) AS SubTotal
From sales.salesorderheader AS s
Group by s.CustomerID, s.SalesPersonID
Order by s.CustomerID DESC;


/*
 9. From the following table write a query in SQL to retrieve total quantity of each productid which are in shelf of 'A' or 'C' or 'H'.
 Filter the results for sum quantity is more than 500.
 Return productid and sum of the quantity. Sort the results according to the productid in ascending order.
*/

Select
	p.ProductID,
	sum(p.Quantity) AS Total_Quantity
From production.productinventory AS p
where
	(p.Shelf='A' or p.Shelf='C' or p.Shelf='H') --(where IN ('A','C','H')
Group BY p.ProductID
Having sum(p.Quantity) >500
Order by p.ProductID ASC;

/*
10.From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10.
*/
Select 
	(sum(p.Quantity)) as total_quantity
From production.productinventory AS p
Group by p.LocationID*10;


/*
	11.From the following table write a query in SQL to find the sum of subtotal column. Group the sum on distinct salespersonid and customerid.
	Rolls up the results into subtotal and running total.
	Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
*/
Select
	s.SalesPersonID,
	s.CustomerID, 
	sum(s.SubTotal) as sum_subtotal

From sales.salesorderheader AS s
Group by ROLLUP(s.SalesPersonID,s.CustomerID)

/*
 12. From the following table write a query in SQL to find the sum of the quantity of all combination of group of distinct locationid and shelf column.
 Return locationid, shelf and sum of quantity as TotalQuantity.
*/
Select 
	DISTINCT p.LocationID,p.Shelf,
	sum(P.Quantity) as total_quantity
	
From production.productinventory as p
Group by RollUp(p.LocationID,p.Shelf)

/*
13.From the following table write a query in SQL to retrieve the number of employees for each City.
Return city and number of employees. Sort the result in ascending order on city.
*/

SELECT a.City, COUNT(b.AddressID) employees 
FROM Person.BusinessEntityAddress AS b   
    INNER JOIN Person.Address AS a  
        ON b.AddressID = a.AddressID  
GROUP BY a.City  
ORDER BY a.City;

/*
14.From the following table write a query in SQL to retrieve the total sales for each year.
Return the year part of order date and total due amount. Sort the result in ascending order on year part of order date.
*/
Select 
	YEAR(s.OrderDate)  as years,
	sum(s.TotalDue) as total

From Sales.SalesOrderHeader as s
group by YEAR(s.OrderDate) 
Order by YEAR(s.OrderDate);