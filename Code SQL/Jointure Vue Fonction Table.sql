-- View Sales.CABYDate  => Utiliser CAByOrder comme base
-- | Date    | CA      | Nombre de commandes |




-- Les données précédentes mais avec tous les jours entre le premier jour et le dernier jour des commandes
DECLARE @Date1 DATE --=(SELECT Min(orderdate) FROM Sales.orders)
DECLARE @Date2 DATE --=(SELECT MAX(orderdate) FROM Sales.orders)
SELECT @Date1=MIN(orderdate), @Date2=MAX(orderdate) FROM Sales.Orders
--SELECT @Date1,@DAte2

;WITH CAByDate AS (
-- CA Par date mais avec dates non contigues
SELECT CAST(orderdate AS DATE) AS 'Date',
SUM(OrderAmount) AS 'CA',
COUNT(orderid) AS 'NbCommandes'

FROM CAByOrder
GROUP  BY  CAST(orderdate AS DATE)
)
SELECT 
	D.Annee,
	D.Mois,
	D.Jour,
	ISNULL(CBD.CA,0) AS CA,
	ISNULL(CBD.NbCommandes,0) AS NbCOmmandes

 FROM TousLesJours(@Date1,@Date2) D LEFT JOIN CAByDate CBD
ON D.dateJour = CBD.Date
ORDER BY D.DateJour ASC
