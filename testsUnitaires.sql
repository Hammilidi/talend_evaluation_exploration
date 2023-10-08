USE SprintTalendDW;

----------------------------------------------------Tests SQL
--V�rification s'il y a des valeus n�gatives dans les colonnes TotalAmount, NetAmount et DiscountAmount
SELECT * FROM Fact_Sales WHERE TotalAmount<0;
SELECT * FROM Fact_Sales WHERE NetAmount<0;
SELECT * FROM Fact_Sales WHERE DiscountAmount<0;

--V�rification si les colonnes CustomerEmail et SupplierContact n'ont pas de valeurs manquantes
SELECT * FROM DimCustomers
WHERE CustomerEmail = NULL;

SELECT * FROM DimSuppliers
WHERE SupplierContact = NULL;

--Requetes SQL
SELECT SUM(TotalAmount) AS CA, AVG(QuantitySold) AS Mean_QuantitySold
FROM Fact_Sales; 

SELECT DiscountAmount,
CASE
	WHEN DiscountAmount > 0 THEN 'OUI'
	ELSE 'NON'
END AS R�duction
FROM Fact_Sales;


SELECT StockOnHand,
    CASE
        WHEN StockOnHand < 10 THEN 'Stock Bientot �puis�'
        ELSE 'En stock'
    END AS StockOnHand_State
FROM Fact_Inventory;


--TotalAmount by ProductCategory
SELECT ProductCategory, SUM(TotalAmount) AS TotalAmount
FROM Fact_Sales JOIN DimProducts ON Fact_Sales.ProductID=DimProducts.ProductID
GROUP BY DimProducts.ProductCategory
ORDER BY TotalAmount DESC;

--Mean QuantitySold by ProductSubCategory
SELECT AVG(Fact_Sales.NetAmount) AS MeanAmount, YEAR(DimDates.Date) AS Year
FROM Fact_Sales JOIN DimDates ON Fact_Sales.DateID = DimDates.DateID
GROUP BY YEAR(DimDates.Date)
ORDER BY MeanAmount DESC;

--Classification
SELECT ShippingMethod, AVG(StockSold) AS Mean_StockSold
FROM Fact_Inventory JOIN DimShippers ON Fact_Inventory.ShipperID = DimShippers.ShipperID
GROUP BY ShippingMethod
ORDER BY Mean_StockSold;

SELECT AVG(QuantitySold) AS Mean_QuantitySold, CustomerSegment 
FROM Fact_Sales JOIN DimCustomers ON Fact_Sales.CustomerID = DimCustomers.CustomerID
GROUP BY CustomerSegment;



------------------------------------------Tests Unitaires avec tSQLt

-----V�rification de l'installation de tSQLt
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'tSQLt';
-----Liste des objects contenus dans tSQLt
SELECT *
FROM tSQLt.TestClasses;

SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME = 'GetTestResult';


--Cr�ation d'une classe (sch�ma nomm�)
EXEC tSQLt.NewTestClass 'DW_Tests';

CREATE PROCEDURE DW_Tests.[TestAllTotalAmountArePositive]
AS
BEGIN
	-- Arrange (Pr�paration) : Aucune pr�paration n�cessaire ici

    -- Act (Action) : V�rifiez si toutes les valeurs de la colonne "Age" sont positives
    DECLARE @NegativeTotalAmount INT;
    
    SELECT @NegativeTotalAmount = COUNT(*)
    FROM Fact_Sales
    WHERE TotalAmount <= 0;

    -- Assert (V�rification) : V�rifiez que le nombre de valeurs n�gatives est �gal � z�ro
    EXEC tSQLt.AssertEquals 0, @NegativeTotalAmount;
END;

--Ex�cution du test
EXEC tSQLt.Run 'DW_Tests.[TestAllTotalAmountArePositive]';



---Test pour v�rifier si le Format de date est uniforme
CREATE PROCEDURE DW_Tests.[CheckDateFormat]
AS
BEGIN
    -- D�claration des variables
    DECLARE @RowCount INT;
    DECLARE @InvalidDates INT;
	DECLARE @DateValue DATE;

    -- Initialisation des variables
    SET @RowCount = 0;
    SET @InvalidDates = 0;

    -- Parcourez la table DimDates
    DECLARE cur CURSOR FOR
    SELECT Date
    FROM DimDates;

    OPEN cur;

    FETCH NEXT FROM cur INTO @DateValue;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- V�rifiez si la date a le format "dd-MM-yyyy"
        IF ISDATE(CONVERT(NVARCHAR(10), @DateValue, 104)) <> 1
        BEGIN
            SET @InvalidDates = @InvalidDates + 1;
        END

        SET @RowCount = @RowCount + 1;

        FETCH NEXT FROM cur INTO @DateValue;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    -- V�rifiez si aucune date n'a un format invalide
    EXEC tSQLt.AssertEquals @RowCount, @InvalidDates, 'Les dates ont un format non conforme.';
END;


--R�sultat
EXEC tSQLt.Run 'CheckDateFormat';


---Valeurs manquantes
CREATE PROCEDURE DW_Tests.[TestMissingCustomerEmails] 
AS
BEGIN
    -- Act (Action) : S�lectionnez toutes les valeurs de la colonne "Email" o� le champ est NULL
    DECLARE @MissingEmails INT;

    SELECT @MissingEmails = COUNT(*)
    FROM DimCustomers
    WHERE CustomerEmail IS NULL;

    -- Assert (V�rification) : V�rifiez que le nombre de valeurs manquantes est �gal � z�ro
    EXEC tSQLt.AssertEquals 0, @MissingEmails;
END;

--R�sultat
EXEC tSQLt.Run 'TestMissingCustomerEmails';


CREATE PROCEDURE DW_Tests.[TestMissingSupplierContacts] 
AS
BEGIN
    -- Act (Action) : S�lectionnez toutes les valeurs de la colonne "Email" o� le champ est NULL
    DECLARE @MissingContacts INT;

    SELECT @MissingContacts = COUNT(*)
    FROM DimSuppliers
    WHERE SupplierContact IS NULL;

    -- Assert (V�rification) : V�rifiez que le nombre de valeurs manquantes est �gal � z�ro
    EXEC tSQLt.AssertEquals 0, @MissingContacts;
END;


---R�sultat
EXEC tSQLt.Run 'TestMissingSupplierContacts';

--Ex�cution de tous les tests
EXEC tSQLt.RunAll;
EXEC tSQLt.Private_OutputTestResults;

