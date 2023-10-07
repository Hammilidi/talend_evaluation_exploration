--Datawarehouse 


--SalesDataMart
USE SalesDataMart;

SELECT MAX(Date) as M_Date, MIN(Date) as m_Date FROM S_Dates;
--Indexation



--Partitionnement
--Cr�ation de la fonction de partitionnement
--Fact_Sales
CREATE PARTITION FUNCTION PF_SalesDate (DATE)
AS RANGE LEFT FOR VALUES 
    ('2021-09-28','2021-12-28', '2022-03-28', '2022-06-28', '2022-09-28','2022-12-28', '2023-03-28', '2023-06-28', '2023-09-28');


-- Cr�ez un sch�ma de partition pour Fact_Slales
CREATE PARTITION SCHEME PS_SalesDate
AS PARTITION PF_SalesDate 
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);


-- Modifiez la table Fact_Sales pour utiliser le partitionnement
ALTER TABLE S_Fact_Sales
DROP CONSTRAINT [PK__S_Fact_S__1EE3C41F601B78F5]; -- Supprimez la contrainte de cl� primaire existante

-- Ajoutez une nouvelle contrainte de cl� primaire en sp�cifiant la colonne de partition
ALTER TABLE S_Fact_Sales
ADD CONSTRAINT [PK_Fact_Sales] PRIMARY KEY (SaleID, DateID)
ON PS_SalesDate(DateID); -- Utilisez DateID pour le partitionnement



-- Cr�ez la table Partionned_Fact_Sales partitionn�e
/*CREATE TABLE Partionned_Fact_Sales
(
    SaleID INT PRIMARY KEY,
	TotalAmount REAL,
	NetAmount REAL,
	DiscountAmount REAL,
	QuantitySold  INT,
    DateID INT,
    ProductID INT,
	CustomerID INT,
    FOREIGN KEY (DateID) REFERENCES S_Dates(DateID),
    FOREIGN KEY (ProductID) REFERENCES S_Products(ProductID), 
    FOREIGN KEY (CustomerID) REFERENCES S_Customers(CustomerID))
ON PS_SalesDate(DateID);
*/

/*
--Copier les donn�es de la tble originale dans la table partionn�e
SELECT * INTO Partionned_Fact_Sales FROM S_Fact_Sales;

--Renommer la table Partionned_Fact_Sales--> Fact_Sales
EXEC sp_rename 'Partionned_Fact_Sales', 'Fact_Sales';
*/

/*
DECLARE @sys_usr CHAR(30);  
SET @sys_usr = SYSTEM_USER;  
SELECT 'The current system user is: '+ @sys_usr;  
GO

*/