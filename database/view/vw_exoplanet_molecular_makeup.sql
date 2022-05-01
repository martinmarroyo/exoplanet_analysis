CREATE VIEW exoplanet.vw_exoplanet_molecular_makeup AS
SELECT *
FROM CROSSTAB(
	$$
		WITH planet_molecule AS (
			SELECT
				UNNEST(STRING_TO_ARRAY(TRIM(molecules),', '))
				AS molecule
				,'t'::BOOLEAN AS is_present
				,planet_name
			FROM exoplanet.dim_planet
			WHERE row_current AND molecules IS NOT NULL
		)
		SELECT planet_name,molecule,is_present
		FROM planet_molecule
		ORDER BY planet_name
	$$
	,$$
		SELECT DISTINCT UNNEST(STRING_TO_ARRAY(TRIM(molecules),', '))
		FROM exoplanet.dim_planet
		WHERE row_current AND molecules IS NOT NULL
	$$
) AS molecules(
	planet_name TEXT
	,"N" BOOLEAN
	,"Ti+" BOOLEAN 
	,"Y" BOOLEAN
	,"TiO2" BOOLEAN
	,"O" BOOLEAN
	,"Sr" BOOLEAN
	,"V" BOOLEAN
	,"TiO" BOOLEAN
	,"AlO" BOOLEAN
	,"H2O" BOOLEAN
	,"Fe I" BOOLEAN
	,"Mg2SiO4" BOOLEAN
	,"ScH" BOOLEAN
	,"CrH" BOOLEAN
	,"Ni" BOOLEAN
	,"Si" BOOLEAN
	,"C2H2" BOOLEAN
	,"VO" BOOLEAN
	,"CN" BOOLEAN
	,"NH3" BOOLEAN
	,"Al2O3" BOOLEAN
	,"Mn" BOOLEAN
	,"SO" BOOLEAN
	,"FeH" BOOLEAN
	,"SiO" BOOLEAN
	,"Ca" BOOLEAN
	,"Fe" BOOLEAN
	,"OH" BOOLEAN
	,"N2" BOOLEAN
	,"HCN" BOOLEAN
	,"KCl" BOOLEAN
	,"CH4" BOOLEAN
	,"C2" BOOLEAN
	,"Ti" BOOLEAN
	,"SH" BOOLEAN
	,"C" BOOLEAN
	,"Cr" BOOLEAN
	,"CO2" BOOLEAN
	,"Na" BOOLEAN
	,"CO" BOOLEAN
	,"Fe II" BOOLEAN
	,"Mg" BOOLEAN
	,"H" BOOLEAN
	,"O I" BOOLEAN
	,"He" BOOLEAN
	,"Li" BOOLEAN
	,"TiH" BOOLEAN
	,"Ca+" BOOLEAN
	,"CaTiO3" BOOLEAN
	,"Fe+" BOOLEAN
	,"H2S" BOOLEAN
	,"Al" BOOLEAN
	,"K" BOOLEAN
	,"NH2" BOOLEAN
	,"H2" BOOLEAN
	,"Ag" BOOLEAN
	,"Sc" BOOLEAN
	,"O2" BOOLEAN
);

-- Comments
COMMENT ON VIEW exoplanet.vw_exoplanet_molecular_makeup
    IS 'Shows the molecules that are found on each planet that reports molecules.';