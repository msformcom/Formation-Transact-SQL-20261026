-- Bonne pratique: spécifier systématiquement le contexte de la BDD
USE TSQL
GO -- Indique au server d'exécuter les lignes avant de passer à la suite (BATCH)

SELECT 1
SELECT 1+(5+2)*5 -- Calcul
SELECT GETDATE() -- Fonction Getdate() => Renvoit la date courante
SELECT Cos(10) -- Fonctions mathématiques classqiues
SELECT 2,6 -- Plusieurs colonnes
SELECT 'Dominique' -- Chaine délimitées par '
SELECT 'C''est super' -- Deux apostrtophes 

-- Nommer lezs colonnes + organiser les tab + retour ligne pour la lisibilité
-- Instructions (clauses) en Majuscule (convention => pas sensible à la casse)
SELECT		'Dominique' AS Nom, 
			58 AS Age 

SELECT 1 + '1' -- Attention => addition d'un nombre avec une chaine => nombre

SELECT '1'+1 -- Attention => addition d'un nombre avec une chaine => nombre

SELECT '2'+'1' -- Concaténation si deux chaines

SELECT 1 + 'A' -- Erreur si incompatibilité

SELECT NULL -- NULL représente le vide => information non connue

SELECT 'Dominique' + ' ' + NULL  -- + = concaténation => une info null => null

SELECT CONCAT('Dominique',' ', null,' est le meilleur') 

-- IIF => Fonction qui choisit une valeur selon une condition
SELECT IIF(1=1,'Juste','Faux') -- Juste
SELECT IIF(1=2,'Juste','Faux') -- Faux

-- IF Instruction qui exécuté un code ou un auitre selon une condition
-- BEGIN END => Permet d'indiquer explicitement les blocs => Bonne pratique => BEGIN END Toujours présents
IF YEAR(GETDATE())=2025
	BEGIN
		PRINT 'Nous sommes en 2025'
	END
ELSE
	BEGIN
		PRINT 'Nous ne sommes pas en 2025'
	END

-- Déclaration de paramètre avec @ => Donner un nom a une valeur
-- Types classqiues INT FLOAT DECIMAL CHAR
DECLARE @date_courante INT = YEAR(GETDATE());

SELECT CASE WHEN @date_courante =2026 THEN 'Cette année'
		WHEN @date_courante =2025 THEN 'L''an dernier'
		ELSE 'Il y a très longtemps' END

SELECT DATEPART(minute,GETDATE()) --Partie minute de l'heure courante
SELECT DATEPART(month,GETDATE()) 
SELECT DATEPART(day,GETDATE()) 
SELECT DATEPART(week,GETDATE()) 
SELECT DATEPART(quarter,GETDATE()) 
SELECT DATEPART(dayofyear,GETDATE()) 
SELECT DATEPART(weekday,GETDATE()) 

DECLARE @date DATE ='10/02/2025'
-- SELECT 
-- | Annee | Mois | Trimestre			| Avancée      |
-- | 2025  | Mois | Premier trimestre   | Avant le 15  |