-- Liste des clients + Trois produits qu'ils ont le plus achete en 2007 (en ca)
-- | custid		| Raison sociale	| product id	| CA Genere |
-- | 1			| Microsoft			| 6				| 76576576  |
-- | 1			| Microsoft			| 98			| 789686	|
-- | 1			| Microsoft			| 12 			| 675		|
-- | 2			| Apple				| 9				| 76576576  |

/*
	SELECT * FROM Sales.Customers
	JOINTURE AVEC CROSS APPLY

*/

/*
    liste des clients + 3 produits preferes en 2007 en CA
    custid, raisonsocial, producid , productname, CA, annee
    jointure  - Cross APPLY
    pour client 1 --> trois plus grosse vente 
*/
 
SELECT 
    sc.custid,
    sc.companyname,
    Top3.*
from sales.Customers Sc
CRoSS APPLY( 
    SELECT TOP (3) 
    SOD.productid As Prodid, 
    PP.productname AS NomProd,
    SUM(SOD.qty * SOD.unitprice) AS CA 
    FROM Sales.orderDetails SOD
	  INNER JOIN sales.orders SO ON SO.orderid = SOD.orderid
	  INNEr JOIN [Production].[Products] PP ON PP.[productid]=SOD.productid
    WHERE SO.custid = sc.custid  AND DATEPART(Year,So.orderdate)=2007
    GROUP BY SOD.productid, PP.productname
) AS top3
ORDER BY custid ASc, CA DESC
 
 
-- SOUS REQUETE integre CUSTOMERS
--pour client 1 --> trois plus grosse vente 
SELECT TOP (3) 
SOD.productid As Prodid, 
PP.productname AS NomProd,
SUM(SOD.qty * SOD.unitprice) AS CA 
FROM Sales.orderDetails SOD
    INNER JOIN sales.orders SO ON SO.orderid = SOD.orderid
    INNEr JOIN [Production].[Products] PP ON PP.[productid]=SOD.productid
WHERE SO.custid = 1 AND DATEPART(Year,So.orderdate)=2007
GROUP BY SOD.productid, PP.productname
ORDER BY CA DESC