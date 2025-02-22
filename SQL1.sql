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


/*
15.From the following table write a query in SQL to find the contacts who are designated as a manager in various departments.
Returns ContactTypeID, name. Sort the result set in descending order.
*/

Select 
	p.ContactTypeID as contactType,
	p.Name as Names
From 
	Person.ContactType as p

Where
	p.Name Like'%manager%'
Order by
	p.Name DESC;

/*
16.From the following tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'.
Return BusinessEntityID, LastName, and FirstName columns.
Sort the result set in ascending order of LastName, and FirstName.
*/
Select
	p.BusinessEntityID as businessEntity,
	FirstName as firstname,
	LastName as lastname
From   Person.BusinessEntityContact as pb
INNER JOIN Person.ContactType AS pc
            ON pc.ContactTypeID = pb.ContactTypeID
        -- Joining Person.BusinessEntityContact with Person.Person based on BusinessEntityID
        INNER JOIN Person.Person AS p
            ON p.BusinessEntityID = pb.PersonID
where  pc.Name='Purchasing Manager'
Order by p.FirstName,p.LastName;

/*
17.From the following tables write a query in SQL to retrieve the salesperson for each PostalCode who belongs to a territory and SalesYTD is not zero.
Return row numbers of each group of PostalCode, last name, salesytd, postalcode column.
Sort the salesytd of each postalcode group in descending order. Shorts the postalcode in ascending order
*/
SELECT 
    
    ROW_NUMBER() OVER (PARTITION BY a.PostalCode ORDER BY sp.SalesYTD DESC) "Row Number",
    p.LastName, 
    sp.SalesYTD, 
   
    a.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS p
        ON sp.BusinessEntityID = p.BusinessEntityID
    INNER JOIN Person.BusinessEntityAddress AS pba
        ON sp.BusinessEntityID = pba.BusinessEntityID
    INNER JOIN Person.Address AS a
        ON pba.AddressID = a.AddressID

WHERE sp.TerritoryID IS NOT NULL
    AND sp.SalesYTD != 0
Order by a.PostalCode;

