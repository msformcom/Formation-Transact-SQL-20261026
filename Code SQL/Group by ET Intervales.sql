-- je veux le chiffre d'affaire par trance de prix
/*
| Min    | MaxExclu		| CA		| Qty    |
| 0      | 10			| 10000		| 2000   |
| 10     | 20			| 20000		| 1500   |
| 20     | 50			| 657657	| 1500   |
| 50     | 100			| 987979	| 1500   |


| 1000     | 5000		| 3000		| 1500   |


0 10 20 50 100 200 500 1000 100000
-- Une table d'intervales
| Min		| MaxExclu		
| 0			| 10			
| 10		| 20			
| 20		| 50			
| 50		| 100			
| 100		| 200			
| 200       | 500		
| 500		| 1000	
| 1000		| 100000			
-- Jointure avec la table Sales.Orderdetail SOD => Unitprice > Min AND unitprice < max
SELECT  * FROM Sales.Orderdetails

*/
WITH Intervales AS (
-- Ensemble des intervales 
SELECT * FROM	(
					VALUES 
					(0,10),
					(10,20),
					(20,50),
					(50,100),
					(100,200),
					(200,500),
					(500,1000),
					(1000,1000000)
				) 
				T(Min,MaxExclu)
)
SELECT Min,
		MaxExclu ,
		ISNULL(SUM(qty*unitprice),0) AS CA,
		ISNULL(SUM(qty),0) AS nbProduitsVendus
		
		FROM Intervales AS I 
LEFT JOIN Sales.OrderDetails AS SOD ON SOD.unitprice >=I.Min AND SOD.unitprice<I.Maxexclu
GROUP BY Min,MaxExclu




