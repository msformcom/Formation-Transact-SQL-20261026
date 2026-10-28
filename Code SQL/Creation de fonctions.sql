-- | Date    | CA      | Nombre de commandes | mais pas contigu

-- | DAte   | Annee | Mois | Jour | sans CA mais toutes les dates d'une annee


-- Insérer dans une table les dates entre @DateDebu et @Datefin
CREATE OR ALTER FUNCTION TousLesJours( 
	@DateDebut DATE,
	@DateFin DATE)
 RETURNS @JoursComplets TABLE(
	DateJour DATE,
	Annee INT,
	Mois INT,
	Jour INT)
AS
	BEGIN
		-- On insère DateDebut dans la table tant que on ne dépasse pas DateFin
		WHILE @DateDebut<=@DateFin
			BEGIN
				INSERT INTO @JoursComplets(DateJour,Annee,Mois,Jour)
				VALUES(@DateDebut,DATEPART(year,@DateDebut),DATEPART(month,@DateDebut),DATEPART(day,@DateDebut))
				-- Ajouter un jour à la datedebut
				SET @DateDebut=DATEADD(day,1,@DateDebut)
			END
		RETURN
	END 

SELECT * FROM TousLesJours('2007-01-01','2007-06-30')

-- Utiliser le code précédent sous la forme d'une fonction
SELECT * FROM TousLesJours('2007-01-01','2007-12-31') J


-- Notion Fonction 
-- Fonction scalaire : Paramètres => valeur
SELECT dbo.Mois(3) => 'Mars'


GO
-- Creation de fonction scalaire => renvoit une seule valeur
CREATE OR ALTER FUNCTION Mois(@n INT)
RETURNS NVARCHAR(50) -- Chaine unicode de longueur max 50
AS 
BEGIN 
	RETURN case 
		when @n = 1 then 'Janvier'
		when @n = 2 then 'février'
		when @n = 3 then 'Mars'
		when @n = 4 then 'Avril'
		when @n = 5 then 'Mai'
		when @n = 6 then 'Juin'
		when @n = 7 then 'Juillet'
		when @n = 8 then 'Aout'
		when @n = 9 then 'Septembre'
		when @n = 10 then 'Octobre'
		when @n = 11 then 'Novembre'
	ELSE 'Décembre' END
END

GO
-- Fonction table => Vue paramétré
CREATE OR ALTER FUNCTION GetSalesByEmployee(@empid INT=null)
RETURNS TABLE AS
RETURN
-- Toutes les produits vendu par  de l'employé numéro 4
SELECT SOD.productid,
	SUM(SOD.qty) AS Quantite,
	SUM(SOD.qty*unitprice) AS CA
 FROM 
Sales.orders SO INNER JOIN Sales.OrderDetails SOD ON SO.orderid=SOD.orderid
WHERE SO.empid=@empid OR @empid IS null
GROUP BY SOD.productid

-- Comparaison vue (sans paramètre)

SELECT * FROM GetSalesByEmployee(null) 


