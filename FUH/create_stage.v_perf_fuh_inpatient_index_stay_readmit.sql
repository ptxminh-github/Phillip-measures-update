/*
# HEDIS FUH (Follow-up After Hospitalization for Mental Illness) - HEDIS 2020
DENOMINATOR EXCLUSION

# Author: Minh Phan, Philip Sylling 
Updated: 2021-01-13 | Minh Phan | Update to 2020 specs. Include Self harm. Add Last_run
Modified: 2019-09-20 | Philip Sylling | Use admit/discharge dates instead of first/last service dates
Modified: 2019-08-09 | Philip Sylling | Point to new [final] analytic tables 
Created: 2019-04-25 | Philip Sylling | Based on 2018 specs

#This view gets non-acute inpatient stays as DENOMINATOR EXCLUSION for the 
FUH (Follow-up After Hospitalization for Mental Illness).

From HEDIS 2020 Guide:

(1)
Exclude discharges followed by readmission or direct transfer 
to a nonacute inpatient care setting within the 30-day follow-up period,
regardless of principal diagnosis for the readmission. 

To identify readmissions and direct transfers to a nonacute inpatient care setting:
1.	Identify all acute and nonacute inpatient stays (Inpatient Stay Value Set).
2.	Confirm the stay was for nonacute care based on the presence of a nonacute code 
(Nonacute Inpatient Stay Value Set) on the claim. 
3.	Identify the admission date for the stay.
These discharges are excluded from the measure because rehospitalization or 
direct transfer may prevent an outpatient follow-up visit from taking place. 

(2)
If the readmission/direct transfer to the acute inpatient care setting was for any other principal diagnosis 
(use only the principal diagnosis on the discharge claim) of mental illness or intentional self-harm 
exclude both the original and the readmission/direct transfer discharge.

Identify readmissions and direct transfers to an acute inpatient care setting during the 30-day follow-up period:
1.	Identify all acute and nonacute inpatient stays (Inpatient Stay Value Set).
2.	Exclude nonacute inpatient stays (Nonacute Inpatient Stay Value Set). 
3.	Identify the admission date for the stay.


LOGIC:
(
Inpatient Stay
INTERSECT
Nonacute Inpatient Stay
)
UNION
((
Inpatient Stay
EXCEPT
Nonacute Inpatient Stay
)
EXCEPT
Mental Health Diagnosis
Intentional Self-Harm
)

Returns:
 [id_mcaid]
,[age]
,[claim_header_id]
,[admit_date]
,[discharge_date]
,[flag] = 1
*/

USE [PHClaims];
GO

IF OBJECT_ID('[tmp].[v_perf_fuh_inpatient_index_stay_readmit]', 'V') IS NOT NULL
DROP VIEW [tmp].[v_perf_fuh_inpatient_index_stay_readmit];
GO
CREATE VIEW [tmp].[v_perf_fuh_inpatient_index_stay_readmit]
AS
/*
SELECT 
[value_set_name]
,[code_system]
,count([code])
FROM [PHClaims].[ref].[hedis_code_system_2020]
WHERE [value_set_name] IN
('Mental Illness'
,'Mental Health Diagnosis'
,'Inpatient Stay'
,'Nonacute Inpatient Stay'
,'Intentional Self-Harm')
GROUP BY [value_set_name], [code_system]
ORDER BY [value_set_name], [code_system];
*/


WITH [non_acute] AS
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,'Nonacute' AS [acuity]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Inpatient Stay')
AND [code_set] = 'UBREV'

INTERSECT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,'Nonacute' AS [acuity]
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
,'Nonacute' AS [acuity]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBTOB'
)),

[acute] AS
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,'Acute' AS [acuity]
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
,'Acute' AS [acuity]
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
,'Acute' AS [acuity]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Nonacute Inpatient Stay')
AND [code_set] = 'UBTOB'
)

EXCEPT

(
SELECT 
 [id_mcaid]
,[claim_header_id]
,'Acute' AS [acuity]
,1 AS [flag]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN ('Mental Health Diagnosis','Intentional Self-Harm')
AND [code_set] = 'ICD10CM'
-- Principal Diagnosis
AND [primary_dx_only] = 'Y'
)),

[readmit] AS
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[flag]
,[acuity]
FROM [non_acute]

UNION

SELECT 
 [id_mcaid]
,[claim_header_id]
,[flag]
,[acuity]
FROM [acute]
)

SELECT 
 re.[id_mcaid]
,re.[claim_header_id]
,hd.[admsn_date] AS [admit_date]
,hd.[dschrg_date] AS [discharge_date]
,hd.[first_service_date]
,hd.[last_service_date]
,[acuity]
,[flag]
FROM [readmit] AS re
INNER JOIN [final].[mcaid_claim_header] AS hd
ON re.[claim_header_id] = hd.[claim_header_id]
GO

/*
-- 84,893 (2018 specs)
-- 68,162 (2020 specs)
SELECT COUNT(*) 
FROM [tmp].[v_perf_fuh_inpatient_index_stay_readmit]
WHERE [admit_date] BETWEEN '2017-01-01' AND '2017-12-31';

SELECT DISTINCT
 [id_mcaid]
,[claim_header_id]
,[admit_date]
,[discharge_date]
,[first_service_date]
,[last_service_date]
,[acuity]
,[flag]
FROM [tmp].[v_perf_fuh_inpatient_index_stay_readmit]
WHERE [admit_date] BETWEEN '2017-01-01' AND '2017-12-31';
*/