-- Paramètres de la requète
DECLARE @IdEmploye INT=5
DECLARE @AnneeDebut INT=2007
DECLARE @AnneeFin INT=2008

-- Regroupement classique 


-- Toutes combinaisons d'annéé (entre 2007 et 2008)
-- Avec les mois (entre 1 et 12)
;WITH 
Years AS (
		SELECT n AS Annee FROM Nums WHERE n BETWEEN 2007 AND 2008
	),
Months AS (
		SELECT n AS Mois FROM Nums WHERE n BETWEEN 1 AND 12
	),
YM AS (
		-- Annee | Mois (toutes les combinaisons pour 2007 et 2008
		SELECT * FROM Years CROSS JOIN Months
		),
Data AS (
		-- Annee | Mois | NbCommandes => Attention il manque des mois / années
		SELECT  
			DATEPART(year,orderdate) AS Annee,
			DATEPART(month,orderdate) AS Mois,
				COUNT(orderid) AS NbCommandes
		FROM Sales.Orders
		WHERE empid=@IdEmploye AND 
		DATEPART(year,orderdate) BETWEEN @AnneeDebut AND @AnneeFin
		GROUP BY  DATEPART(year,orderdate), DATEPART(month,orderdate)
)
SELECT YM.Annee,
		YM.Mois,
		ISNULL(D.NbCommandes,0) AS NbCommandes
 FROM
YM LEFT JOIN Data D ON YM.Annee=D.Annee AND YM.Mois=D.Mois
ORDER BY Annee,Mois