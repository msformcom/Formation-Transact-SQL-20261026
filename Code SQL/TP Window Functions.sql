
	-- Fonctions renvoyant les années mois pour deux dates
    CREATE OR ALTER FUNCTION Helpers.TouslesMois( @DateDebut DATE, @DateFin DATE )
    RETURNS @AnneeMois TABLE ( Annee INT, Mois INT )
    AS 
    BEGIN 
	  WHILE @DateDebut <= @DateFin
		BEGIN
		    INSERT INTO @AnneeMois (Annee, Mois )
		    VALUES(DATEPART(YEAR,@DateDebut), DATEPART(MONTH,@DateDebut))
		    -- ajouter un jour à la DateDebut
		    SET @DateDebut = DATEADD(MONTH,1,@DateDebut)
		END
	  RETURN
    END
	-- Test
	--SELECT * FROM TouslesMois('2007-01-01','2008-12-31')
 
 
    /* creation d'une vue avec des data */
    Go
    CREATE OR ALTER VIEW Sales.CAByDate AS
    SELECT
		DATEPART(YEAR, SO.orderdate) AS Annee,
		DATEPART(MONTH, SO.orderdate) AS Mois,
		SUM(SOD.qty*SOD.unitprice) AS OrderAmount
    FROM Sales.Orders AS SO
	  INNER JOIN Sales.OrderDetails AS SOD ON SO.orderid = SOD.orderid
    GROUP BY DATEPART(YEAR,SO.orderdate), DATEPART(MONTH, SO.orderdate) 



-- Avoir le ca par mois de 2006 a 2008
-- 1) Créer une fonction TousLesMois => Table | Annee | Mois |
-- 2) Jointure avec CA By Date (Voir code précédent) => with | Annee | Mois | CA
-- 3) Ajouter les données de fonction de paramétrage => Select 
-- Annee 
-- Mois 
-- CA 
-- Position du mois par rapport au CA pour l'annee
-- Difference du CA par rapport au mois precedent
-- Pourcentage du mois par rapport au CA de l'annee
-- Différence avec le même mois de l'année précédente

 ;WITH Jointure AS
    (
		SELECT
		   TLM.Annee,
		   TLM.Mois,
		   ISNULL(CBD.OrderAmount,0) AS CA
		FROM Sales.CAByDate AS CBD
		    RIGHT JOIN Helpers.TouslesMois('2006-01-01','2008-12-31') AS TLM 
			ON TLM.Annee=CBD.Annee AND TLM.Mois=CBD.Mois
		    --GROUP BY TLM.Annee, TLM.Mois
    ), fenetrage As (
	  --fenetrage avec données numériques
	  SELECT * ,
		DENSE_RANK() OVER(PARTITION BY ANNEE ORDER BY CA DESC) AS PosCA,
		--> Différence CA du mois par rapport au mois précédent -- LAG
		CA-LAG(CA) OVER(ORDER BY Annee, Mois) AS CaMoisPreced,
		--> % mois par rapport au CA de l'année
		CA / SUM(CA) OVER(PARTITION BY Annee) AS ratioAn,
		-- difference du CA / Mois  par rapport au meme mois l'annee précédente
		CA-LEAD(CA) OVER( ORDER BY Mois, Annee DESC) AS DiffCaMois,
		SUM(CA) OVER(PARTITION BY Annee ORDER BY Mois ROWS BETWEEN unbounded preceding and current row) AS CumulCA,
		AVG(CA) OVER (ORDER BY Annee,Mois ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS MoyenneGrlissante,
		-- CA mois suivants calculés sur moyenne des 6 derniers mois)
		AVG(CA) OVER (ORDER BY Annee,Mois ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) MoyenneG6, 
		AVG(CA) OVER (ORDER BY Annee,Mois ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) * (12-mois)
		-- CA Déja réalisé
		+ SUM(CA) OVER (PARTITION BY Annee ORDER BY Mois ROWS BETWEEN unbounded preceding and current row)
		AS ProjectionFinAn
		-- Pour mai
		-- Cumul du CA Jan - mai
		-- + Moyenne CA 6 derniers mois * nb mois restant année 7

	  FROM Jointure
    ) -- Affichage Client
    SELECT *,
	  CAST(RatioAn * 100 AS NVARCHAR(20)) + '%' AS '%CA'
    FROM fenetrage
    ORDER BY Annee, Mois
    --ORDER BY ratioAn