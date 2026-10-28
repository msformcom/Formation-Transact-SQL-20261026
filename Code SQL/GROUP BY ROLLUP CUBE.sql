-- Pour employé 4 et 2007 a 2008

-- | Annee | Mois |NbCommandes pour employe
-- Ordonnees par annee, mois croissants



-- Paramètres de la requète
DECLARE @IdEmploye INT=4
DECLARE @AnneeDebut INT=2007
DECLARE @AnneeFin INT=2008

-- Regroupement classique 
SELECT  
	DATEPART(year,orderdate) AS Annee,
	DATEPART(month,orderdate) AS Mois,
		COUNT(orderid) AS NbCommandes
FROM Sales.Orders
WHERE empid=@IdEmploye AND 
DATEPART(year,orderdate) BETWEEN @AnneeDebut AND @AnneeFin
GROUP BY  DATEPART(year,orderdate), DATEPART(month,orderdate)
ORDER BY Annee, Mois

-- Regroupement avec emploiye et 
-- ROLLUP : Sous totaux en remontant les éléments de GROUP BY
-- CUBE : SOus totaux pour toutes les combinaisons possibles
SELECT empid, 
DATEPART(year,orderdate) AS Annee,
	DATEPART(month,orderdate) AS Mois,
		COUNT(orderid) AS NbCommandes
FROM Sales.Orders
WHERE --empid=@IdEmploye AND 
DATEPART(year,orderdate) BETWEEN @AnneeDebut AND @AnneeFin
GROUP BY  empid,DATEPART(year,orderdate), DATEPART(month,orderdate)
WITH CUBE
HAVING DATEPART(month,orderdate)=1 and empid=4 
ORDER BY empid,Annee, Mois