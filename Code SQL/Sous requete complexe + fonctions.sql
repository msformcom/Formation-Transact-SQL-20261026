-- Par pays :
-- - Le nom prenom commercial (pays client) qui a généré le plus gros CA + %CA sur le pays
-- - Le nom du shipper qui a livré en moyenne le plus rapidement (pays destination) + Moyenne du temps de livraison
-- - le nom produit le plus vendu + CA (pays client)
-- - le nom du plus gros client (pays du client)

WITH InfosPays AS (
SELECT shipcountry,
		SUM(CBO.OrderAmount) AS CAParLivraison

		FROM dbo.CAByOrder CBO
GROUP BY CBO.shipcountry)
SELECT * FROM InfosPays IP
CROSS APPLY (
	-- Liste des employes avec CA dans le pays par ordre de CA décroissant
	SELECT TOP 1 * FROM CommercialParPays(IP.shipcountry)
	ORDER BY CAEmploye DESC
	) AS ICommercial
CROSS APPLY (
	-- Liste des shipper avec temps moyen de livraison decroissant
	SELECT TOP 1 * FROM ShipperInfoParPays(IP.shipcountry)	 
	ORDER BY TempsLivraisonMoyenHour ASC
	) AS IShipper



-- CA généré  par commercial pour un pays donné
CREATE OR ALTER FUNCTION CommercialParPays(
@pays NVARCHAR(50)
)
RETURNS TABLE AS 
RETURN 
SELECT  E.empid, 
				E.firstname, 
				E.lastname,
		SUM(OrderAmount) AS CAEmploye
		FROM dbo.CAByOrder CBO 
		INNER JOIN HR.Employees E ON E.empid=CBO.empid
		-- Pour avoir le pays du client
		INNER JOIN SAles.Customers SC ON CBO.custid=SC.custid
		-- Limitation du clacul aux ventes dont le client est dans le pays de IP
	WHERE SC.country=@pays
	GROUP BY E.empid, E.firstname, E.lastname
	--ORDER BY CAEmploye DESC

SELECT * FROM CommercialParPays('France')

-- Liste des shipper avec temps moyen de livraison pour un pays donné
CREATE FUNCTION ShipperInfoParPays(
@PAys NVARCHAR(50)
) 
RETURNS TABLE
RETURN
SELECT  SS.shipperid,SS.companyname, 
				
		AVG(DATEDIFF(hour,CBO.orderdate,CBO.shippeddate )) AS TempsLivraisonMoyenHour
		FROM dbo.CAByOrder CBO 
		INNER JOIN Sales.Shippers SS ON SS.shipperid=CBO.shipperid
		
		-- Limitation du clacul aux ventes dont le client est dans le pays de IP
	WHERE CBO.shipcountry=@pays
	GROUP BY SS.shipperid,SS.companyname

SELECT * FROM ShipperInfoParPays('France')