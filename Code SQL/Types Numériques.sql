-- Types Alphanumérique
-- CHAR(5) Chaine de 5 caractères exactement
DECLARE @s1 CHAR(5)='D'
SELECT @s1+@s1 -- 'D    D    '

-- VARCHAR(5) Chaine de 5 caractères max
DECLARE @s2 VARCHAR(5)='D'
SELECT @s2+@s2  -- 'DD'

SET @s2='волыэ'
SELECT @s2

-- NHAR(5) Chaine de 5 caractères max unicode
-- Encodage ASCII => 1 caractère => 1 octet 
-- é => Page de code nationale (FR) => octet 123  => Page de code nationale (FR) => é
--										octet 123  => Page de code nationale (DK) => ô
-- Ren@ va trôs bien.
-- N => Encodage unicode / international => 1 car => 1,2,3,4 octet suivant la nationalité
DECLARE @s3 NVARCHAR(50)=N'волыэ'
SELECT @s3+@s3  -- 'волыэволыэ'