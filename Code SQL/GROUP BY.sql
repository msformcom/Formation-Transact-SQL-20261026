-- GROUP BY
SELECT * FROM Production.products

SELECT  
		-- productname => pas possible dans le select car il en existe une diversité pour le grouoe
		-- dans le select :
		-- - les colonnes du GROUP BY
		-- - Les fonctions servant à aggreger les données
		
		categoryid,
		 COUNT(*) AS NbProduits,
		AVG(unitprice) AS MoyennePrix,
		MAX(unitprice) AS PrixMax,
		MIN(unitprice) AS PrixMin
FROM Production.products
GROUP BY categoryid


-- Par product id :
-- le nombre de produits vendus, la moyenne du prix vente,  le CA généré

SELECT * FROM Sales.OrderDetails
ORDER BY productid

-- | 3 | 10  | 1000
-- | 3 | 100 | 1
-- Moyenne pure du prix de vente 55
-- Moyenne pondérée : 10.08

SELECT 
	productid AS 'Id produit',
	AVG(unitprice) AS 'Moyenne prix vente',
	ROUND(AVG(unitprice),2) AS 'Moyenne 2 chiffres après la virgule',
	SUM(unitprice*qty)/SUM(qty) AS 'Moyenne pondérée prix vente',
	SUM(qty) AS 'Quantité vendue',
	SUM(qty * unitprice) AS CA,
	'€' AS 'Unité monétaire',

	CONVERT(VARCHAR(20),SUM(qty * unitprice))+ ' €' AS 'CA généré' -- Pas bon car retourne un chaine => + - * order by non valides
 FROM Sales.OrderDetails
 -- WHERE => Condition sur les enregistrements avant le regroupement : unitprice>10
GROUP BY productid
HAVING SUM(qty * unitprice) >1000 -- => condition sur les informations après regroupement
ORDER BY CA -- Surtout pas 'CA Généré'

-- | Id produit | Quantité vendue | Moyenne prix vente | CA 

