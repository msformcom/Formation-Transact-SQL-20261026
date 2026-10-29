-- CA de Annee 2008 Mois 2
--SELECT SUM (Orderamount) FROM CAByOrder
--WHERE DATEPART(year, orderdate)=2008 AND 
--DATEPART(month, orderdate)=2

SELECT ISNULL(SUM (Orderamount),0) AS CA,
		ISNULL(Count (orderid),0) AS NbCommandes FROM CAByOrder
			WHERE DATEPART(year, orderdate)=2008 AND 
			DATEPART(month, orderdate)=2

SELECT TLM.Annee,
		TLM.Mois,
		-- Sous requete 1
	(SELECT ISNULL(SUM (Orderamount),0) FROM CAByOrder
			WHERE DATEPART(year, orderdate)=TLM.Annee AND 
			DATEPART(month, orderdate)=TLM.Mois) AS CA,
	-- Sous requete 2 
	(SELECT ISNULL(count (orderid),0) FROM CAByOrder
			WHERE DATEPART(year, orderdate)=TLM.Annee AND 
			DATEPART(month, orderdate)=TLM.Mois) ASNbCommandes
FROM Helpers.TouslesMois('2006-01-01','2008-12-31') TLM


SELECT TLM.Annee,
		TLM.Mois,
		T.CA,
		T.NbCommandes
		-- Utiliser CROSS Apply pour projeter plusieurs colonnes d'une même sous requete
FROM Helpers.TouslesMois('2006-01-01','2008-12-31') TLM
CROSS APPLY (
SELECT ISNULL(SUM (Orderamount),0) AS CA,
		ISNULL(Count (orderid),0) AS NbCommandes FROM CAByOrder
			WHERE DATEPART(year, orderdate)=TLM.Annee AND 
			DATEPART(month, orderdate)=TLM.Mois) AS T

GO
CREATE FUNCTION Sales.InfosVentesByMois(
@Annee INT,
@Mois INT)
RETURNS TABLE 
AS
RETURN 
SELECT ISNULL(SUM (Orderamount),0) AS CA,
		ISNULL(Count (orderid),0) AS NbCommandes FROM CAByOrder
			WHERE DATEPART(year, orderdate)=@Annee AND 
			DATEPART(month, orderdate)=@Mois
SELECT * FROM Sales.InfosVentesByMois(2008,2)


SELECT TLM.Annee,
		TLM.Mois,
		T.CA, -- Calculée et extraite de la fonction du cross apply
		T.NbCommandes  -- Calculée et extraite de la fonction du cross apply
		-- Utiliser CROSS Apply pour projeter plusieurs colonnes d'une même sous requete
FROM Helpers.TouslesMois('2006-01-01','2008-12-31') TLM
CROSS APPLY  Sales.InfosVentesByMois(TLM.annee,TLM.Mois) T


---Categories qui ont au moins un produits en rupture de stock
SELECT *,
	(SELECT COUNT(*) FROM Production.Products
	WHERE categoryid=PC.categoryid AND discontinued=1) as NbRuptures
 FROM Production.Categories PC
WHERE EXISTS(
SELECT * FROM Production.Products
WHERE categoryid=PC.categoryid AND discontinued=1
)

-- Pour la categorie 4 => Liste des produits en rupture de stock
SELECT * FROM Production.Products
WHERE categoryid=5 AND discontinued=1


-- Exercice Trouver les clients qui ont acheté une imprimante (produit 6) en 2007
-- sans acheter le produit 7 (cartouche) en 2008
-- Liste des clients qui ont achete le produit 6 en 2007 
-- 	sans acheter le produit 7 en 2008
-- 
-- SELECT custid, companyname FROM Sales.Customers
-- WHERE EXISTS(SELECT ... ACHAT DE Produit 6 en 2007 pour le customer)
-- AND NOT EXISTS( SELECT ... ACHAT DE Produit 7 en 2008 pour le customer)


-- Achats du produit 6 en 2007 Pour le client 4
-- Achats du produit 7 en 2008 Pour le client 4

SELECT SC.custid, 
		SC.companyname
FROM Sales.Customers AS SC
WHERE 
	EXISTS(
	-- Ceux qui ont acheté le produit 6 en 2007
		SELECT * FROM Sales.OrderDetails SOD 
		INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
		WHERE SOD.productid=6 AND DATEPART(year,SO.orderdate)=2007 AND SO.custid=SC.custid)
	AND 
	NOT EXISTS(
		SELECT * FROM Sales.OrderDetails SOD 
		INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
		WHERE SOD.productid=7 AND DATEPART(year,SO.orderdate)=2008 AND SO.custid=SC.custid
	)

ORDER BY SC.custid

WITH Ventes AS (
SELECT SC.custid, 
		SC.companyname,
		-- Nomùbre de ventes du produit 6 en 2007 pour le client SC.custid
		(SELECT ISNULL(SUM(SOD.qty),0) FROM Sales.OrderDetails SOD 
		INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
		WHERE SOD.productid=6 AND DATEPART(year,SO.orderdate)=2007 AND SO.custid=SC.custid) AS NbVentesProduit6En2007,
		-- Nombre de ventes du produit 7 en 2008
		(SELECT ISNULL(SUM(SOD.Qty),0) FROM Sales.OrderDetails SOD 
		INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
		WHERE SOD.productid=7 AND DATEPART(year,SO.orderdate)=2008 AND SO.custid=SC.custid) AS nbVentesProduit7en2008
		FROM Sales.Customers SC)
SELECT * FROM Ventes 
WHERE NbVentesProduit6En2007>0 AND nbVentesProduit7en2008<100
ORDER BY Custid







-- Achats du produit 6 en 2007 Pour le client 4
SELECT * FROM Sales.OrderDetails SOD 
INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
WHERE SOD.productid=6 AND DATEPART(year,SO.orderdate)=2007 AND SO.custid=51

SELECT * FROM Sales.OrderDetails SOD 
INNER JOIN Sales.Orders SO ON SO.orderid=SOD.OrderID
WHERE SOD.productid=7 AND DATEPART(year,SO.orderdate)=2008 AND SO.custid=51