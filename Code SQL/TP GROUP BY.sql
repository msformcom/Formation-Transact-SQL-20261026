-- Par pays et region :
-- Nombre de ventes 
-- Nombre de clients
-- moyenne des frais de port
-- moyenne du temps de livraison
-- pour les ventes de 2007
-- Uniquement les dix region avec le plus grand nombre de ventes

-- COUNT(*) => nombre d'enregistrement
-- COUNT(orderid) => compte le nombre de orderid non nulles 
-- COUNT(DISTINCT custid) =>compte le nombre de orderid non nulles et différents

SELECT TOP 10
		ShipCountry AS Pays,
		ISNULL(ShipRegion,'---') AS ShipRegion,
		COUNT(orderid) AS NbVentes,
		COUNT(DISTINCT custid) AS NbClients,
		AVG(freight) AS MoyenneFraisPort,
		AVG(DATEDIFF(day,orderdate, shippeddate)) AS MoyenneTempsLivraison
FROM Sales.Orders
WHERE DATEPART(year,orderdate)=2007
GROUP BY shipcountry, shipregion 
ORDER BY NbVentes DESC

-- par Annee et mois :
-- Le nombre de ventes et de clients
-- moyenne frais de port
-- nombre de pays dans lesquels j'ai livré
-- ordonné par annee et mois decroissant

WITH PUREDATA AS 
(
-- Exctraction des données brutes
SELECT
    COUNT(orderid) AS NbVente,
    COUNT(DISTINCT custid) AS DistinctClient,
    COUNT(DISTINCT [shipcountry]) AS NbPays,
    AVG(freight) AS MoyFraisPort,
    YEAR(orderdate) AS an,
    MONTH(orderdate) As mois
FROM Sales.Orders
GROUP BY YEAR(orderdate), MONTH(orderdate)
)
-- Présentation séparée
SELECT  *,
	CASE	WHEN mois=1 THEN 'Janvier'
			WHEN mois=2 THEN 'Février'
			WHEN mois=3 THEN 'Mars'
			WHEN mois=4 THEN 'Avril'
			WHEN mois=5 THEN 'Mai'
			WHEN mois=6 THEN 'Juin'
			WHEN mois=7 THEN 'Juillet'
			WHEN mois=8 THEN 'Aout'
			WHEN mois=9 THEN 'Septembre'
			WHEN mois=10 THEN 'Octobre'
			WHEN mois=11 THEN 'Novembre'
			ELSE 'Décembre' END AS MoisToutesLettres

FROM PUREDATA
ORDER BY An DESC, Mois DESC
 