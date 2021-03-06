
/*
# HEDIS FUH (Follow-up After Hospitalization for Mental Illness)-  HEDIS 2020
NUMERATOR 

# Author: Minh Phan, Philip Sylling
Updated: 2021-1-14 | MP | Updated based on HEDIS 2020 specs
Modified: 2019-08-09 | PS | Point to new [final] analytic tables
Created: 2019-04-24 | PS 

# This view gets follow-up visits (numerator) for the FUH measure:
Follow-up Hospitalization for Mental Illness: 7 days
Follow-up Hospitalization for Mental Illness: 30 days

Returns:
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date] = [first_service_date]
,[flag] = 1 for claim meeting FUH follow-up visits criteria
,[only_30_day_fu], 
        if 'Y' claim only meets requirement for 30-day follow-up, 
        if 'N' claim meets requirement for 7-day and 30-day follow-up. 
        For HEDIS 2020, there is no exclusive requirement for 30 day, 
        so this field is always =N
*/

USE [PHClaims];
GO

IF OBJECT_ID('[tmp].[v_perf_fuh_follow_up_visit]', 'V') IS NOT NULL
DROP VIEW [tmp].[v_perf_fuh_follow_up_visit];
GO
CREATE VIEW [tmp].[v_perf_fuh_follow_up_visit]
AS
/*
SELECT a.[value_set_name]
      ,a.[code_system]
      ,COUNT(a.[code])
FROM [ref].[hedis_code_system_2020] AS a
INNER JOIN [ref].[hedis_value_set_2020] AS b
ON a.[value_set_name]=b.[value_set_name]
WHERE b.[measure_id] = 'FUH'
GROUP BY a.[value_set_name], [code_system]
ORDER BY a.[value_set_name], [code_system];
*/

WITH [get_claims] AS
(
/*
Condition 1:
An outpatient visit (Visit Setting Unspecified Value Set) with (Outpatient POS Value Set) 
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Visit Setting Unspecified')
AND [code_set] IN ('CPT')

INTERSECT

SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Outpatient POS')
AND [code_set] IN ('POS')

)

UNION
/*
Condition 2:
An outpatient visit (BH Outpatient Value Set) 
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('BH Outpatient')
AND [code_set] IN ('CPT','HCPCS','UBREV')

)

UNION
/*
Condition 3:
 An intensive outpatient encounter or partial hospitalization (Visit Setting Unspecified Value Set) 
 with (Partial Hospitalization POS Value Set) 
 with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Visit Setting Unspecified')
AND [code_set] IN ('CPT')

INTERSECT

SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Partial Hospitalization POS')
AND [code_set] = 'POS'
)

UNION
/*
Condition 4:
An intensive outpatient encounter or partial hospitalization (Partial Hospitalization or Intensive Outpatient Value Set)
 with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Partial Hospitalization or Intensive Outpatient')
AND [code_set] IN ('UBREV', 'HCPCS')
)

UNION
/*
Condition 5:
A community mental health center visit (Visit Setting Unspecified Value Set) 
with (Community Mental Health Center POS Value Set)
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Visit Setting Unspecified')
AND [code_set] = 'CPT'

INTERSECT

SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Community Mental Health Center POS')
AND [code_set] = 'POS'

)

UNION
/*
Condition 6:
TElectroconvulsive therapy (Electroconvulsive Therapy Value Set) 
with (Ambulatory Surgical Center POS Value Set; Community Mental Health Center POS Value Set; 
Outpatient POS Value Set; Partial Hospitalization POS Value Set) 
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Electroconvulsive Therapy')
AND [code_set] IN ('CPT','ICD10PCS')

INTERSECT

SELECT 
[id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Ambulatory Surgical Center POS','Community Mental Health Center POS','Outpatient POS','Partial Hospitalization POS')
AND [code_set] IN ('POS')
)

UNION
/*
Condition 7:
A telehealth visit: (Visit Setting Unspecified Value Set) 
with (Telehealth POS Value Set) 
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Visit Setting Unspecified')
AND [code_set] IN ('CPT')

INTERSECT

SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Telehealth POS')
AND [code_set] IN ('POS')
)

UNION
/*
Condition 8:
 An observation visit (Observation Value Set)
with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Observation')
AND [code_set] IN ('CPT')
)

UNION
/*
Condition 9:
 Transitional care management services (Transitional Care Management Services Value Set),
  with a mental health practitioner (Mental Health Practitioner Value Set).
*/
(
SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,1 AS [flag]
,'N' AS [only_30_day_fu]

--SELECT COUNT(*)
FROM [tmp].[mcaid_claim_value_set]
WHERE 1 = 1
AND [value_set_group] = 'HEDIS'
AND [value_set_name] IN 
('Transitional Care Management Services')
AND [code_set] IN ('CPT')
)

)

SELECT 
 [id_mcaid]
,[claim_header_id]
,[service_date]
,[flag]
,MAX([only_30_day_fu]) AS [only_30_day_fu] 

FROM [get_claims]
GROUP BY [id_mcaid], [claim_header_id], [service_date], [flag]
GO

/*
-- 8,098,388
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
DROP TABLE #temp;
SELECT * 
INTO #temp
FROM [stage].[v_perf_fuh_follow_up_visit]
WHERE [service_date] BETWEEN '2016-01-01' AND '2018-12-31';

-- 2,617,306
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
DROP TABLE #temp;
SELECT * 
INTO #temp
FROM [stage].[v_perf_fuh_follow_up_visit]
WHERE [service_date] BETWEEN '2017-01-01' AND '2017-12-31';
*/