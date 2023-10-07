CREATE DATABASE InventoryDataMart;

USE SprintTalendDW;

--Cr�ation des tables et copie des donn�es dans les tables 
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


---En cas d'erreurs, ex�cuter ce code avant de r�ex�cuter celui ci-dessus en raison des contraintes
--USE InventoryDataMart;

--DROP TABLE I_Dates;
--DROP TABLE I_Products;
--DROP TABLE I_Suppliers;
--DROP TABLE I_Shippers;
--DROP TABLE I_Fact_Inventory;


USE InventoryDataMart;

--D�finition des contraintes 
--Cl�s Primaires
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

--Cl�s �trang�res
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
