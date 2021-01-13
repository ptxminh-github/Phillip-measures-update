# This code loads table ([stage].[mcaid_claim_value_set]) to hold DISTINCT 
# claim headers that meet RDA and/or HEDIS value set definitions.
#
# It is designed to be run as part of the master Medicaid script:
# https://github.com/PHSKC-APDE/claims_data/blob/master/claims_db/db_loader/mcaid/master_mcaid_analytic.R
# 
# 2021-01-11 Revised by Minh Phan, update to 2020 versions 
# 2019-11-14 Created by: Philip Sylling, 
# 2019-12 R functions created by: Alastair Matheson, PHSKC (APDE)
# 


#message("Loading stage.mcaid_claim_value_set")
#### SET UP LIBRARY ####
library(odbc) # Read to and write from SQL
library(DBI)
library(configr) # Read in YAML files


#### SET UP FUNCTIONS, ETC. ####
if (!exists("db_claims")) {
        db_claims <- DBI::dbConnect(odbc::odbc(), "PHClaims")  
}


if (!exists("add_index")) {
        devtools::source_url("https://raw.githubusercontent.com/PHSKC-APDE/claims_data/master/claims_db/db_loader/scripts_general/add_index.R")
}

#### TRUNCATE TABLE AND REMOVE ANY INDICES ####
DBI::dbGetQuery(db_claims, "TRUNCATE TABLE [tmp].[mcaid_claim_value_set]")


#### LOAD DATA IN ####
DBI::dbGetQuery(db_claims,
"CREATE TABLE [PHClaims].[tmp].[mcaid_claim_value_set]
([value_set_group] VARCHAR(20) NULL  
,[value_set_name] VARCHAR(100) NOT NULL
,[data_source_type] VARCHAR(50) NULL
--,[sub_group] 
,[code_set] VARCHAR(50) NOT NULL
,[primary_dx_only] CHAR(1) NULL 
,[id_mcaid] VARCHAR(255) NOT NULL
,[claim_header_id] BIGINT NULL
,[service_date] DATE NULL
,[last_run] DATE NOT NULL
);

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,NULL AS [primary_dx_only]
,pr.[id_mcaid]
,pr.[claim_header_id]
,pr.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_procedure] AS pr
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('CPT', 'HCPCS', 'ICD10PCS', 'ICD-10', 'ICD9PCS', 'ICD-9', 'CPT-HCPCS')
AND pr.[procedure_code] = rda.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,NULL AS [primary_dx_only]
,hd.[id_mcaid]
,hd.[claim_header_id]
,hd.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_header] AS hd
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('DRG')
AND hd.[drvd_drg_code] = rda.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,'Y' AS [primary_dx_only]
,dx.[id_mcaid]
,dx.[claim_header_id]
,dx.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_icdcm_header] AS dx
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('ICD')
AND dx.[icdcm_version] in (9,10)
AND dx.[icdcm_number] = '01'
AND dx.[icdcm_norm] = rda.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,'N' AS [primary_dx_only]
,dx.[id_mcaid]
,dx.[claim_header_id]
,dx.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_icdcm_header] AS dx
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('ICD')
AND dx.[icdcm_version] in (9,10)
--AND dx.[icdcm_number] = '01'
AND dx.[icdcm_norm] = rda.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,NULL AS [primary_dx_only]
,ph.[id_mcaid]
,ph.[claim_header_id]
,ph.[rx_fill_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_pharm] AS ph
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('NDC')
--AND rda.[active] = 'Y'
AND ph.[ndc] = rda.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 rda.[value_set_group]
,rda.[value_set_name]
,rda.[data_source_type]
--,rda.[sub_group]
,rda.[code_set]
,NULL AS [primary_dx_only]
,ln.[id_mcaid]
,ln.[claim_header_id]
,ln.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_line] AS ln
INNER JOIN [ref].[rda_value_set_2020] AS rda
ON rda.[code_set] IN ('UBREV')
AND ln.[rev_code] = rda.[code];


--HEDIS value sets
INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,NULL AS [primary_dx_only]
,pr.[id_mcaid]
,pr.[claim_header_id]
,pr.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_procedure] AS pr
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN 
('BH Outpatient',
'Electroconvulsive Therapy',
'Hospice Intervention',
'Observation',
'Transitional Care Management Services',
'Visit Setting Unspecified',
'BH Outpatient',
'Hospice Encounter',
'Hospice Intervention',
'Partial Hospitalization or Intensive Outpatient')
AND hed.[code_system] IN ('CPT', 'HCPCS', 'ICD10PCS')
AND pr.[procedure_code] = hed.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,NULL AS [primary_dx_only]
,ln.[id_mcaid]
,ln.[claim_header_id]
,ln.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_line] AS ln
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN 
('BH Outpatient',
'Hospice Encounter',
'Inpatient Stay',
'Nonacute Inpatient Stay',
'Partial Hospitalization or Intensive Outpatient',
'Nonacute Inpatient Stay')
AND hed.[code_system] IN ('UBREV')
AND ln.[rev_code] = hed.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,NULL AS [primary_dx_only]
,hd.[id_mcaid]
,hd.[claim_header_id]
,hd.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_header] AS hd
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN 
('Nonacute Inpatient Stay')
AND hed.[code_system] = 'UBTOB' 
AND hd.[type_of_bill_code] = hed.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,NULL AS [primary_dx_only]
,hd.[id_mcaid]
,hd.[claim_header_id]
,hd.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_header] AS hd
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN 
('Ambulatory Surgical Center POS',
'Community Mental Health Center POS',
'Outpatient POS',
'Partial Hospitalization POS',
'Telehealth POS')
AND hed.[code_system] = 'POS' 
AND hd.[place_of_service_code] = hed.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,'Y' AS [primary_dx_only]
,dx.[id_mcaid]
,dx.[claim_header_id]
,dx.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_icdcm_header] AS dx
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN
('Intentional Self-Harm',
'Mental Health Diagnosis',
'Mental Illness')
AND hed.[code_system] = 'ICD10CM'
AND dx.[icdcm_version] = 10
-- Principal Diagnosis
AND dx.[icdcm_number] = '01'
AND dx.[icdcm_norm] = hed.[code];

INSERT INTO [tmp].[mcaid_claim_value_set] WITH (TABLOCK)
SELECT DISTINCT
--TOP(100)
 'HEDIS' AS [value_set_group]
,hed.[value_set_name]
,NULL AS [data_source_type]
--,NULL AS [sub_group]
,hed.[code_system]
,'N' AS [primary_dx_only]
,dx.[id_mcaid]
,dx.[claim_header_id]
,dx.[first_service_date] AS [service_date]
,CONVERT(date,GETDATE()) AS [last_run]
FROM [final].[mcaid_claim_icdcm_header] AS dx
INNER JOIN [ref].[hedis_code_system_2020] AS hed
ON [value_set_name] IN
('Intentional Self-Harm',
'Mental Health Diagnosis',
'Mental Illness')
AND hed.[code_system] = 'ICD10CM'
AND dx.[icdcm_version] = 10
--AND dx.[icdcm_number] = '01'
AND dx.[icdcm_norm] = hed.[code];")


#### ADD NEW INDEX ####
DBI::dbGetQuery(db_claims,
                "CREATE CLUSTERED COLUMNSTORE INDEX [idx_ccs_mcaid_claim_value_set]
                ON [tmp].[mcaid_claim_value_set]")
