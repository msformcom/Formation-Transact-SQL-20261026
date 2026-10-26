USE TSQL
GO


-- SELECT de colonnes
-- Alias conseillé

-- SQL => Structured Query Language
-- Par design => se rapprocher du langage courant

SELECT   lastname		AS Nom,
						firstname	AS Prenom,
						FORMAT(hiredate,'yyyy-MM-dd')	AS HireDate,
						DATEDIFF(year,hiredate,GETDATE()) AS [Ancienneté (années)],
						DATEADD(year,60,birthdate) AS DateRetraite,
						DATEDIFF(week,GETDATE(),DATEADD(year,60,birthdate)) AS ResteSemainesAvantRetaitre,
						DATEDIFF(year,hiredate,DATEADD(year,60,birthdate)) AS AnneesEntreprise
						-- Nombre de semaine avant la retraite (60 ans) -- DATEPART DATEDIFF DATEADD,
						-- nombre d'années dans l'entreprise au moment de leur retraite
			 FROM HR.Employees
-- Ordre de la syntaxe => SELECT + ALIAS => FROM
-- Ordre exécution => FROM => SELECT => ALIAS



-- Première sélection comme base de la deuxième => Sous requete
SELECT Nom,
		Prenom,
		DateRetraite,
		DATEDIFF(week,GETDATE(),DateRetraite) AS SemainesAvantLaRetraite,
		DATEDIFF(year,DateEntree, DateRetraite) AS AnneesEntreprise

FROM (

					SELECT   lastname		AS Nom,
							 firstname	AS Prenom,
							 hiredate AS DateEntree,
							 birthdate AS DateNaissance,
							 DATEADD(year,60,birthdate) AS DateRetraite
							 FROM HR.Employees
		 ) AS SEL1

-- CTE Common Table Expressions

WITH SEL1 AS (
					SELECT   lastname		AS Nom,
							 firstname	AS Prenom,
							 hiredate AS DateEntree,
							 birthdate AS DateNaissance,
							 DATEADD(year,60,birthdate) AS DateRetraite
							 FROM HR.Employees
							 )
SELECT 
		Nom,
		Prenom,
		DateRetraite,
		DATEDIFF(week,GETDATE(),DateRetraite) AS SemainesAvantLaRetraite,
		DATEDIFF(year,DateEntree, DateRetraite) AS AnneesEntreprise 
FROM SEL1