CREATE DATABASE SalesDataMart;
CREATE DATABASE InventoryDataMart;

USE SprintTalendDW;
USE SalesDataMart;
USE InventoryDataMart;
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



---------------------------------------------------------------------------------
SELECT * INTO InventoryDataMart.dbo.I_Dates 
FROM DimDates;

SELECT * INTO InventoryDataMart.dbo.I_Products 
FROM DimProducts;

SELECT SupplierID, SupplierName, SupplierLocation INTO InventoryDataMart.dbo.I_Suppliers
FROM DimSuppliers;

SELECT * INTO InventoryDataMart.dbo.I_Fact_Inventory 
FROM Fact_Inventory;


--Définition des contraintes dans le datamart InventoryDataMart
--Clés Primaires
ALTER TABLE I_Dates
ADD PRIMARY KEY (DateID);

ALTER TABLE I_Products
ADD PRIMARY KEY (ProductID);

ALTER TABLE I_Suppliers
ADD PRIMARY KEY (SupplierID);

ALTER TABLE I_Fact_Inventory 
ADD PRIMARY KEY (InventoryID);

--Clés étrangères
ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventoryDate FOREIGN KEY (DateID) REFERENCES I_Dates(DateID);

ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventoryProduct FOREIGN KEY(ProductID) REFERENCES I_Products (ProductID);

ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventorySpplier FOREIGN KEY (SupplierID) REFERENCES I_Suppliers (SupplierID);

