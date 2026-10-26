-- Order by

-- Syntaxe : SELECT + ALIAS - FROM - WHERE - ORDER BY
-- Exécution FROM => WHERE => SELECT => ALIAS => ORDER BY

DECLARE @tauxTVA DECIMAL(18,2)=0.2  -- 18 chiffres significatifs dont 2 après la virgule

SELECT productname AS NomProduit,
	unitprice AS PrixHT,
	unitprice*(1+@tauxTVA) AS PrixTTC
FROM Production.Products
ORDER BY PrixTTC ASC  -- ou DESC Dans le OrderBY on peut utiliser le nom des alias


-- TP
-- Liste des ventes avec :
-- Date vente
-- Nombre de jours de retard  
-- Freignt * le nombre de jours de retard => Remboursemùent frais livraisons
-- Pour toutes les ventes des 6 derniers mois ordonnées par frais livraisons descendants
-- Avec 1 jour de retard au moins
-- Plus de 10 jours => 10 fois les faris de livraison pas plus
-- remboursements > 10 €