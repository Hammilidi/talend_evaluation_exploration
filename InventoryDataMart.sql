CREATE DATABASE InventoryDataMart;

USE SprintTalendDW;

--Création des tables et copie des données dans les tables 
--Tables de dimension
SELECT * INTO InventoryDataMart.dbo.I_Dates 
FROM DimDates;

SELECT * INTO InventoryDataMart.dbo.I_Products 
FROM DimProducts;

SELECT SupplierID, SupplierName, SupplierLocation INTO InventoryDataMart.dbo.I_Suppliers
FROM DimSuppliers;

SELECT * INTO InventoryDataMart.dbo.I_Shippers 
FROM DimShippers;

--Table de fait
SELECT * INTO InventoryDataMart.dbo.I_Fact_Inventory 
FROM Fact_Inventory;


---En cas d'erreurs, exécuter ce code avant de réexécuter celui ci-dessus en raison des contraintes
--USE InventoryDataMart;

--DROP TABLE I_Dates;
--DROP TABLE I_Products;
--DROP TABLE I_Suppliers;
--DROP TABLE I_Shippers;
--DROP TABLE I_Fact_Inventory;


USE InventoryDataMart;

--Définition des contraintes 
--Clés Primaires
ALTER TABLE I_Dates
ADD PRIMARY KEY (DateID);

ALTER TABLE I_Products
ADD PRIMARY KEY (ProductID);

ALTER TABLE I_Suppliers
ADD PRIMARY KEY (SupplierID);

ALTER TABLE I_Shippers
ADD PRIMARY KEY (ShipperID);

ALTER TABLE I_Fact_Inventory 
ADD PRIMARY KEY (InventoryID);

--Clés étrangères
ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventoryDate FOREIGN KEY (DateID) REFERENCES I_Dates(DateID);

ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventoryProduct FOREIGN KEY(ProductID) REFERENCES I_Products (ProductID);

ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventorySpplier FOREIGN KEY (SupplierID) REFERENCES I_Suppliers (SupplierID);

ALTER TABLE I_Fact_Inventory
ADD CONSTRAINT FK_InventoryShipper FOREIGN KEY (ShipperID) REFERENCES I_Shippers (ShipperID);


--Optimisations
--Indexation


--Partitionnement
