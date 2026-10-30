SELECT 
	YEAR(orderdate) AS Annee, 
	MONTH(orderdate) AS Mois, 
	shipcountry AS Pays, 
	shipcity AS Ville,
	SUM(orderamount) AS CA
 FROM dbo.CAByOrder

GROUP BY 
-- WITH ROLLUP : Sous cumuls manquants
-- WITH CUPE : Sous cumuls non cohérents (London quel que soit le pays)
GROUPING SETS(
	-- Liste les sous-cumuls que je veux voir apparaitre dans ma selection
	(YEAR(orderdate), MONTH(orderdate), shipcountry, shipcity),
	(YEAR(orderdate), MONTH(orderdate)),
	(YEAR(orderdate)),
	(shipcountry,shipcity),
	(shipcountry),
	(YEAR(orderdate),shipcountry),
	(YEAR(orderdate), MONTH(orderdate), shipcountry),
	(YEAR(orderdate),shipcountry,shipcity),
	()
)
