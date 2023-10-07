CREATE DATABASE SalesDataMart;

USE SprintTalendDW;
------------------------------------------------------------------------------
--SalesDataMart
SELECT * INTO SalesDataMart.dbo.S_Dates
FROM DimDates;

SELECT * INTO SalesDataMart.dbo.S_Products
FROM DimProducts;

SELECT CustomerID, CustomerName, CustomerSegment  
INTO SalesDataMart.dbo.S_Customers 
FROM DimCustomers;

SELECT * INTO SalesDataMart.dbo.S_Fact_Sales 
FROM Fact_Sales;



---En cas d'erreurs, exécuter ce code avant de réexécuter celui ci-dessus en raison des contraintes
--USE InventoryDataMart

--DROP TABLE S_Dates;
--DROP TABLE S_Customers;
--DROP TABLE S_Products;
--DROP TABLE S_Fact_Sales;



USE SalesDataMart;

--Définition des contraintes dans SalesDataMart
--Clés Primaires
ALTER TABLE S_Dates
ADD PRIMARY KEY (DateID);

ALTER TABLE S_Products
ADD PRIMARY KEY (ProductID);

ALTER TABLE S_Customers
ADD PRIMARY KEY (CustomerID);

ALTER TABLE S_Fact_Sales
ADD PRIMARY KEY (SaleID);

--Clés étrangères
ALTER TABLE S_Fact_Sales
ADD CONSTRAINT FK_SalesDate FOREIGN KEY (DateID) REFERENCES S_Dates(DateID);

ALTER TABLE S_Fact_Sales
ADD CONSTRAINT FK_SalesCustomer FOREIGN KEY (CustomerID) REFERENCES S_Customers(CustomerID);

ALTER TABLE S_Fact_Sales
ADD CONSTRAINT FK_SalesProduct FOREIGN KEY (ProductID) REFERENCES S_Products(ProductID);



--Optimisations
--Indexation



--Partitionnement

