-- Par Annee et par mois, => group by
-- le nombre de commandes, count
--  le nombre de clients, count
--  CA sum
-- Moyenne du montant par client, moyenne du montant par vente
-- Pour 2007 et 2008
-- | Année | Mois | NbCommandes | NbClient | CA     |  MoyenneMontantCommande |  MoyenneDepenseClient |  

;WITH MontantCommandes AS (
-- | Orderid | Amount |
SELECT 
	orderid AS Orderid,
	SUM(qty*unitprice) as Amount
FROM Sales.OrderDetails
GROUP BY orderid)
,InfosCommandes AS (
-- | orderid | Year | Month | Custid | Amount
SELECT SO.orderid, 
		DATEPART(year,SO.orderdate) AS 'Year',
		DATEPART(month,SO.orderdate) AS 'Month',
		SO.custid,
		MC.Amount
FROM Sales.Orders AS SO INNER JOIN  MontantCommandes AS MC ON SO.orderid=MC.Orderid),
BaseData AS (
-- Regroupement par année et mois
SELECT Year AS Annee,
		Month AS Mois,
		COUNT(orderid) AS NbCommandes,
		COUNT(DISTINCT custid) AS NbClients,
		SUM(amount) AS CA
		FROM InfosCommandes
GROUP BY Year,Month
)
-- Calcul des moyennes
SELECT *,
	CA/NbCommandes AS MoyenneCAParCommande,
	CA/NbClients AS moyenneCAParClient

 FROM BaseData
 ORDER BY Annee,Mois
