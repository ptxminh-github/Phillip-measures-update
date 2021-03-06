
/*
# HEDIS FUH (Follow-up After Hospitalization for Mental Illness) - HEDIS 2020
DENOMINATOR

# Author: Minh Phan, Philip Sylling
Updated: 2020-01-14 | MP | Update based on HEDIS 2020 (changes made in HEDIS 2019) to include Intentional Self-harm. 
Modified: 2019-09-20 | PS | Use admit/discharge dates instead of first/last service dates
Modified: 2019-08-09 | PS | Point to new [final] analytic tables
Created: 2019-04-25 | PS | Based on HEDIS 2018 specs

# This view gets inpatient stays for the FUH (Follow-up After Hospitalization for Mental Illness).
Three result sets are STACKED on each other
FIRST, for Mental Illness
SECOND, for Mental Health Diagnosis
THIRD, for Intentional Self-Harm 

LOGIC: Acute Inpatient Stays with a Mental Illness Principal Diagnosis
Principal diagnosis in Mental Illness Value Set
INTERSECT
(
Inpatient Stay Value Set
EXCEPT
Nonacute Inpatient Stay
)

UNION ALL

LOGIC: Acute Inpatient Stays with a Mental Health Diagnosis Principal Diagnosis
Principal diagnosis in Mental Health Diagnosis Value Set
INTERSECT
(
Inpatient Stay Value Set
EXCEPT
Nonacute Inpatient Stay
)
UNION ALL

LOGIC: Acute Inpatient Stays with a Intentional Self-Harm  Principal Diagnosis
Principal diagnosis in Intentional Self-Harm Value Set
INTERSECT
(
Inpatient Stay Value Set
EXCEPT
Nonacute Inpatient Stay
)


Returns:
 [value_set_name]
,[id_mcaid]
,[age]
,[claim_header_id]
,[admit_date]
,[discharge_date]
,[flag] = 1
*/

USE [PHClaims];
GO

IF OBJECT_ID('[tmp].[v_perf_fuh_inpatient_index_stay]', 'V') IS NOT NULL
DROP VIEW [tmp].[v_perf_fuh_inpatient_index_stay];
GO
CREATE VIEW [tmp].[v_perf_fuh_inpatient_index_stay]
AS
/*
SELECT [value_set_name]
      ,[code_system]
      ,COUNT([code])
FROM [ref].[hedis_code_system_2020]
WHERE [value_set_name] IN
('Mental Illness'
,'Mental Health Diagnosis'
,'Inpatient Stay'
,'Nonacute Inpatient Stay'
,'Intentional Self-Harm')
GROUP BY [value_set_name], [code_system]
ORDER BY [value_set_name], [code_system];

value_set_name	code_system
Inpatient Stay	UBREV
Mental Health Diagnosis	ICD10CM
Mental Health Diagnosis	SNOMED CT US Edition
Mental Illness	ICD10CM
Mental Illness	SNOMED CT US Edition
Nonacute Inpatient Stay	UBREV
Nonacute Inpatient Stay	UBTOB
Intentional Self-Harm	ICD10CM	
*/

WITH [mental_illness_value_set] AS
(
/*
Mental Illness Value Set does not include ICD9CM diagnosis codes 
PHCLaims doesn't have SNOMED CT US Edition code
*/
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN ('Mental Illness')
AND [code_set] = 'ICD10CM'
-- Principal Diagnosis
AND [primary_dx_only] = 'Y'

INTERSECT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Inpatient Stay')
AND [code_set] = 'UBREV'

EXCEPT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBREV'

UNION

SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBTOB'
))),

[mental_health_diagnosis_value_set] AS
(
/*
Mental Health Diagnosis Value Set does not include ICD9CM diagnosis codes
PHCLaims doesn't have SNOMED CT US Edition code
*/
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN ('Mental Health Diagnosis')
AND [code_set] = 'ICD10CM'
-- Principal Diagnosis
AND [primary_dx_only] = 'Y'

INTERSECT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Inpatient Stay')
AND [code_set] = 'UBREV'

EXCEPT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBREV'

UNION

SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBTOB'
))),

[intentional_selfharm] AS
(
/*
Intentional Self-Harm only not includes ICD10CM diagnosis codes
*/
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN ('Intentional Self-Harm')
AND [code_set] = 'ICD10CM'
-- Principal Diagnosis
AND [primary_dx_only] = 'Y'

INTERSECT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Inpatient Stay')
AND [code_set] = 'UBREV'

EXCEPT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBREV'

UNION

SELECT 
 [id_mcaid]
,[claim_header_id]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBTOB'
))),

[age_x_year_old] AS
(
SELECT 
 'Mental Illness' AS [value_set_name]
,cl.[id_mcaid]
,elig.[dob]
,DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])), elig.[dob]) > COALESCE(hd.[dschrg_date], hd.[last_service_date]) THEN 1 ELSE 0 END AS [age]
,cl.[claim_header_id]
,hd.[admsn_date] AS [admit_date]
,hd.[dschrg_date] AS [discharge_date]
,hd.[first_service_date]
,hd.[last_service_date]
,cl.[flag]
FROM [mental_illness_value_set] AS cl
INNER JOIN [final].[mcaid_elig_demo] AS elig
ON cl.[id_mcaid] = elig.[id_mcaid]
INNER JOIN [final].[mcaid_claim_header] AS hd
ON cl.[claim_header_id] = hd.[claim_header_id]

UNION ALL

SELECT 
 'Mental Health Diagnosis' AS [value_set_name]
,cl.[id_mcaid]
,elig.[dob]
,DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])), elig.[dob]) > COALESCE(hd.[dschrg_date], hd.[last_service_date]) THEN 1 ELSE 0 END AS [age]
,cl.[claim_header_id]
,hd.[admsn_date] AS [admit_date]
,hd.[dschrg_date] AS [discharge_date]
,hd.[first_service_date]
,hd.[last_service_date]
,cl.[flag]
FROM [mental_health_diagnosis_value_set] AS cl
INNER JOIN [final].[mcaid_elig_demo] AS elig
ON cl.[id_mcaid] = elig.[id_mcaid]
INNER JOIN [final].[mcaid_claim_header] AS hd
ON cl.[claim_header_id] = hd.[claim_header_id]

UNION ALL

SELECT 
 'Intentional Self-Harm' AS [value_set_name]
,cl.[id_mcaid]
,elig.[dob]
,DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, elig.[dob], COALESCE(hd.[dschrg_date], hd.[last_service_date])), elig.[dob]) > COALESCE(hd.[dschrg_date], hd.[last_service_date]) THEN 1 ELSE 0 END AS [age]
,cl.[claim_header_id]
,hd.[admsn_date] AS [admit_date]
,hd.[dschrg_date] AS [discharge_date]
,hd.[first_service_date]
,hd.[last_service_date]
,cl.[flag]
FROM [intentional_selfharm] AS cl
INNER JOIN [final].[mcaid_elig_demo] AS elig
ON cl.[id_mcaid] = elig.[id_mcaid]
INNER JOIN [final].[mcaid_claim_header] AS hd
ON cl.[claim_header_id] = hd.[claim_header_id]
)

SELECT *
FROM [age_x_year_old];
GO


/*SELECT DISTINCT [value_set_name]
FROM [tmp].[v_perf_fuh_inpatient_index_stay]

SELECT *
FROM [tmp].[v_perf_fuh_inpatient_index_stay]
WHERE [value_set_name] = 'Mental Illness';

SELECT DISTINCT
 [value_set_name]
,[id_mcaid]
,[dob]
,[age]
,[claim_header_id]
,[admit_date]
,[discharge_date]
,[first_service_date]
,[last_service_date]
,[flag]
FROM [tmp].[v_perf_fuh_inpatient_index_stay]
WHERE [value_set_name] = 'Mental Illness';

SELECT 
 [year_quarter]
,COUNT(*)
FROM [tmp].[v_perf_fuh_inpatient_index_stay] AS a
INNER JOIN [ref].[date] AS b
ON a.[discharge_date] = b.[date]
WHERE [value_set_name] = 'Mental Illness'
GROUP BY [year_quarter]
ORDER BY [year_quarter];
*/