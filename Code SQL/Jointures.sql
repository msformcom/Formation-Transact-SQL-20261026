-- Jointure 
SELECT * FROM Production.Products


-- Produit : Toutes les combinaisons
SELECT 
PP.[productname],
PP.[categoryid],
PC.[categoryid],
PC.[categoryname]
FROM Production.Products AS PP, Production.Categories AS PC


-- Limitation des résultats aux combinaisons cohérentes
SELECT 
PP.[productname],
PP.[categoryid],
PP.unitprice,
PC.[categoryid],
PC.[categoryname]
FROM Production.Products AS PP, Production.Categories AS PC
WHERE 
PP.[categoryid] = PC.[categoryid] -- Condition de jointure
AND PP.unitprice>10  -- filtre des résultats

-- Syntaxe des jointures => séparer la condition de jointure des filtres
-- J'obtiens uniquement les lignes pour laquelle la condition est vraie
 SELECT 
 PP.productid,
PP.[productname],
PP.[categoryid],
PP.unitprice,
PC.[categoryid],
PC.[categoryname]
FROM Production.Products AS PP 
INNER JOIN Production.Categories AS PC
ON PP.[categoryid] = PC.[categoryid]
WHERE PP.unitprice>10

-- Autoriser un produit sans donner la catégorie
-- Colonne CategoryId dans Products => Allow NULL
-- Mode design de la table
-- Tools => Options => Designers => Table and Database designers => Prevent saving...
UPDATE Production.Products
SET categoryid=NULL WHERE productid=4

-- Liste des produits sans categorie
-- Attention NULL=NULL => Faux
SELECT * FROM Production.Products
WHERE categoryid IS NULL

-- Liste des 
SELECT 
 PP.productid,
PP.[productname],
-- PP.[categoryid],
PP.unitprice,
-- PC.[categoryid],
ISNULL(PC.[categoryname],'---') AS Categoryname
FROM Production.Products AS PP  LEFT JOIN Production.Categories AS PC -- LEFT => on veut inclure les lignes de la table de gauche même si il n'y aucune correspondance
ON PP.[categoryid] = PC.[categoryid]
WHERE PP.unitprice>10

-- INserer une categorie
INSERT INTO Production.Categories(CategoryName,description) VALUES('Plage','Pour les vacances')

-- Liste des catégories
SELECT * FROM Production.Categories


SELECT 
 PP.productid,
PP.[productname],
-- PP.[categoryid],
PP.unitprice,
-- PC.[categoryid],
ISNULL(PC.[categoryname],'---') AS Categoryname
FROM Production.Products AS PP  RIGHT JOIN Production.Categories AS PC -- RIGHT => on veut inclure les lignes de la table de droite même si il n'y aucune correspondance
ON PP.[categoryid] = PC.[categoryid]

SELECT 
 PP.productid,
PP.[productname],
-- PP.[categoryid],
PP.unitprice,
-- PC.[categoryid],
ISNULL(PC.[categoryname],'---') AS Categoryname
FROM Production.Products AS PP  FULL JOIN Production.Categories AS PC -- FULL => on veut inclure Toutes les  lignes e même si il n'y aucune correspondance
ON PP.[categoryid] = PC.[categoryid]

-- T1 INNER JOIN T2 => les éléments de T1 et T2 seulement si il y a au moins une correspondance
-- T1 LEFT JOIN T2 => Les éléments de T1 même si pas de correspondance dans T2
-- T1 RIGHT JOIN T2 => Les éléments de T2 même si pas de correspondance dans T1
-- T1 FULL JOIN T2 => Les éléments des deux tables même si pas de correspondance