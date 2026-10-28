-- Creation de vue - Objectif => Enregistrer une requète de façon à la réutiliser plus tard
-- dans d'autres requètes
-- ici : avoir en plus des infos d'une commande le CA
CREATE OR ALTER VIEW CAByOrder AS
SELECT	SO.orderid, 
		SO.orderdate,
		SO.custid,
		SO.empid,
		SO.shipperid,
		SO.shipcountry,
		SO.shipregion,SO.shipcity,
		SUM(SOD.qty*SOD.Unitprice) AS OrderAmount
 FROM Sales.Orders AS SO 
INNER JOIN Sales.OrderDetails AS SOD ON SOD.orderid=SO.orderID
GROUP BY SO.orderid, SO.orderdate, SO.custid,SO.empid,SO.shipperid,SO.shipcountry,SO.shipregion,SO.shipcity
