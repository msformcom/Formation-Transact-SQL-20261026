

-- TP
-- Liste des ventes avec :
-- Date vente
-- Nombre de jours de retard  
-- Freignt * le nombre de jours de retard => Remboursemùent frais livraisons
-- Pour toutes les ventes des 6 derniers mois ordonnées par frais livraisons descendants
-- Avec 1 jour de retard au moins
-- Plus de 10 jours => 10 fois les faris de livraison pas plus
-- remboursements > 10 €

SELECT orderdate,
DATEDIFF(day,requireddate,shippeddate) AS NombreJourRetard, -- Nombre positif = retard,
freight,
freight*IIF(DATEDIFF(day,requireddate,shippeddate)<=10,DATEDIFF(day,requireddate,shippeddate),10) AS Montant
FROM Sales.Orders
WHERE DATEDIFF(day,requireddate,shippeddate)>=1
AND 
freight*IIF(DATEDIFF(day,requireddate,shippeddate)<=10,DATEDIFF(day,requireddate,shippeddate),10)>+10
-- AND orderdate >= DATEADD(month,-6,GETDATE())
-- AND DATEADD(month,6,orderdate) >= GETDATE()
ORDER BY Montant DESC


WITH Etape1 AS (
-- Liste des commandes en retard avec les jours de retard
SELECT orderdate,
		freight,
		DATEDIFF(day,requireddate,shippeddate) as NbJoursRetard
		FROM Sales.Orders
		-- WHERE orderdate >= DATEADD(month,-6,GETDATE())
), Etape2 AS (
-- calcul de l'indemnite Limitatee à 10 jours
SELECT orderdate AS DateCommande,
		freight*IIF(NbJoursRetard<=10,NbJoursRetard,10) AS Montant
	 FROM Etape1
WHERE NbJoursRetard>0
)
-- Montant indemnisé si supérieur à 10 
SELECT * FROM Etape2 WHERE Montant>=10
ORDER BY Montant DESC