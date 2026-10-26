-- Syntaxe  SELECT + ALIAS - FROM - WHERE
-- Exécution FROM => WHERE => SELECT => ALIAS

SELECT productname AS NomProduit,
		unitprice AS PrixHT,
		unitprice * 1.2 AS PrixTTC 
FROM Production.Products
WHERE unitprice * 1.2 <50 -- ANR OR
		AND discontinued=0

WITH SEL1 AS (
SELECT productname AS NomProduit,
		unitprice AS PrixHT,
		unitprice * 1.2 AS PrixTTC 
FROM Production.Products
WHERE discontinued=0
)
SELECT * FROM SEL1
WHERE PrixTTC  <50 

-- Produits dans la categorie 1
SELECT * FROM Production.Products
WHERE categoryid=1


-- Produits dans la categorie 1, 6 , 7, 8
SELECT * FROM Production.Products
WHERE categoryid IN (1,6,7,8)



-- Commandes entre le 01/02/2006 et le 31/03/2006
SET DATEFORMAT DMY
SELECT * FROM Sales.Orders
WHERE orderdate>='01/02/2007' AND orderdate <   DATEADD(day,1,'31/03/2007') -- <= '31/03/2007'Avant le 31/03/2007 à 00:00:00

-- BETWEEN AVEC DATES => A 2viter
SELECT * FROM Sales.Orders
WHERE orderdate BETWEEN '01/02/2007' AND  DATEADD(day,1,'31/03/2007')


-- La liste des commandes de l'employe 4 du 01/01/2007 au 30/06/2007 
-- aux US ou UK ou France
SET DATEFORMAT DMY
-- Date de première commande
DECLARE @Date1 DATE ='01/01/2007'
-- Date de dernière commande
DECLARE @Date2 DATE ='30/06/2007'
-- Id Employé
DECLARE @idemploye INT=4

SELECT * 
FROM Sales.Orders
WHERE empid=@idemploye AND orderdate >=@Date1 AND orderdate<DATEADD(day,1,@Date2)
AND shipcountry IN ('USA','UK','France')

-- Liste des pays dédoublonnée
SELECT DISTINCT shipcountry
FROM Sales.Orders 