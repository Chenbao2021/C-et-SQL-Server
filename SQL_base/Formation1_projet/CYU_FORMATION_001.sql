-- =============================================
-- 1)
-- Une proc�dure stock�e pour obtenir la liste des X villes ayant la plus faible superficie 
-- Param�tres :
--   @X : D�crire nombre des villes qu'on veut afficher
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectSmallestSurface_001
GO
CREATE PROCEDURE CYU_SQL1_SelectSmallestSurface_001
	@X int
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT TOP(@X)
		vf.ville_nom as nom,
		vf.ville_surface as surface
	FROM
		villes_france_free AS vf
	ORDER BY
		vf.ville_surface ASC;
END
GO

-- =============================================
-- 2)
-- Une proc�dure stock�e pour obtenir la liste des d�partements d�outre-mer, c�est-�-dire ceux dont le num�ro de d�partement commence par �97� 
-- Param�tres :
--   
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectOutreMer_002
GO
CREATE PROCEDURE CYU_SQL1_SelectOutreMer_002
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT 
		d.departement_nom 'Departement Nom',
		d.departement_code 'Departement Code'
	FROM 
		departement d
	WHERE
		d.departement_code LIKE '97%';
END
GO

-- =============================================
-- 3)
-- Une proc�dure stock�e pour obtenir le nom des X villes les plus peupl�es en YYYY, ainsi que le nom du d�partement associ�.
-- R�alis� avec CASE mot cl�es.
-- Param�tres :
--   @X		: D�crire nombre des villes qu'on veut afficher
--	 @YYYY	: L'ann�e qu'on va s'int�rroger
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectPlusPeuplee_003
GO
CREATE PROCEDURE CYU_SQL1_SelectPlusPeuplee_003
	@X INT,
	@YYYY VARCHAR(20)
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT TOP(
		CASE
			WHEN COL_LENGTH('villes_france_free', 'ville_population_' + @YYYY) IS NOT NULL THEN @X
			ELSE 0
		END
	)
        v.ville_nom AS nom,
        d.departement_nom AS 'departement nom'
    FROM
        villes_france_free v
    LEFT JOIN
        departement d
        ON v.ville_departement = d.departement_code
    ORDER BY
        CASE
			WHEN @YYYY = '1999' THEN v.ville_population_1999
			WHEN @YYYY = '2010' THEN v.ville_population_2010
			WHEN @YYYY = '2012' THEN v.ville_population_2012
		END DESC
END
GO

-- =============================================
-- 4)
-- Une proc�dure stock�e pour obtenir la liste du nom de chaque d�partement, 
-- associ� � son code et du nombre de commune au sein de ces d�partements, 
-- en triant afin d�obtenir en priorit� les d�partements qui poss�dent le plus de communes.
-- Param�tres :
--   
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectPLusGrandDepartements_004
GO
CREATE PROCEDURE CYU_SQL1_SelectPlusGrandDepartements_004
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT
		d.departement_nom as 'name',
		d.departement_code as 'code',
		COUNT(DISTINCT vf.ville_code_commune) as 'nombre communes'
	FROM
		departement d
	LEFT JOIN
		villes_france_free vf
		ON d.departement_code = vf.ville_departement
	GROUP BY
		d.departement_code,
		d.departement_nom
	ORDER BY
		COUNT(DISTINCT vf.ville_code_commune) desc;		
END
GO

-- =============================================
-- 5)
-- Une proc�dure stock�e pour obtenir la liste des X plus grands d�partements, en termes de superficie
-- Param�tres :
--   @X : D�crire nombre des villes qu'on veut afficher
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectXPlusGrandDepartement_005
GO
CREATE PROCEDURE CYU_SQL1_SelectXPlusGrandDepartement_005
	@X INT
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT TOP(@X)
		d.departement_nom as 'name',
		d.departement_code as 'code',
		SUM(vf.ville_surface) as 'surface departement'
	FROM
		departement d
	LEFT JOIN
		villes_france_free vf
		ON d.departement_code = vf.ville_departement
	GROUP BY
		d.departement_code,
		d.departement_nom
	ORDER BY
		SUM(vf.ville_surface) desc;
END
GO

-- =============================================
-- 6)
-- Une proc�dure stock�e pour compter le nombre de villes dont le nom commence par �<une_chaine_de_caract�res>�
-- Param�tres :
--   @input : Une cha�ne de caract�re.
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectCountCityWithName_006
GO
CREATE PROCEDURE CYU_SQL1_SelectCountCityWithName_006
	@input varchar(255)
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT
	COUNT(distinct vf.ville_code_postal) as "Nombre de villes dont le nom commence par :"
	FROM
		villes_france_free vf
	WHERE
		vf.ville_nom LIKE @input + '%';
END
GO

-- =============================================
-- 7)
-- Une proc�dure stock�e pour obtenir la liste des villes qui ont un nom existants plusieurs fois, 
-- et trier afin d�obtenir en premier celles dont le nom est le plus souvent utilis� par plusieurs villes
-- Param�tres :
--   
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectNomExistantMultipleFois_007
GO
CREATE PROCEDURE CYU_SQL1_SelectNomExistantMultipleFois_007
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT
		vf.ville_nom as 'Ville Name',
		COUNT(vf.ville_code_postal) as 'Frequence'
	FROM
		villes_france_free vf
	GROUP BY
		vf.ville_nom
	HAVING
		COUNT(vf.ville_code_postal) > 1
	ORDER BY
		COUNT(vf.ville_code_postal) DESC
END
GO

-- =============================================
-- 8)
-- Une proc�dure stock�e pour obtenir en une seule requ�te SQL la liste des villes dont la superficie est sup�rieure � la superficie moyenne
-- Param�tres :
--   
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectPlusQueLaMoyenne_008
GO
CREATE PROCEDURE CYU_SQL1_SelectPlusQueLaMoyenne_008
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT 
	vf.ville_nom as 'nom de la ville',
	vf.ville_surface as 'surface de la ville'
	FROM
		villes_france_free vf
	WHERE
		vf.ville_surface > (
			SELECT 
				Round(AVG(vf.ville_surface), 2) 
			FROM
				villes_france_free	vf
	)
	ORDER BY
		vf.ville_surface DESC
END
GO

-- =============================================
-- 9)  Comme l'ann�e n'est pas indiqu� , j'ai prit l'ann�e la plus r�c�nt.
-- Une proc�dure stock�e pour obtenir la liste des d�partements qui poss�dent plus de X millions d�habitants
-- Param�tres :
--   @X : Le nombre des milliosn d'habitants.
-- =============================================
DROP PROCEDURE CYU_SQL1_SelectPlusQueMillions_009
GO
CREATE PROCEDURE CYU_SQL1_SelectPlusQueMillions_009
	@X INT
AS -- D:\tuto_SQL\CYU_FORMATION_001.sql
BEGIN
	SELECT
		d.departement_code as 'Departement Code',
		d.departement_nom as 'Departement Nom',
		SUM(vf.ville_population_2012) as 'ville Population en 2012'
	FROM
		departement d
	LEFT JOIN
		villes_france_free vf
	ON
		d.departement_code = vf.ville_departement
	GROUP BY
		d.departement_code,
		d.departement_nom
	HAVING
		SUM(vf.ville_population_2012) > @X * 1000000;
END
GO