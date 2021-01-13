USE PHClaims;
GO
/*
Truncate [ref] schema tables and load data from temp tables into [ref] schema 
tables. (1) Adjust the temp table names in the FROM clauses based on the temp 
table destinations in load_ref.hedis_value_set.R.
*/
--TRUNCATE TABLE [REF].[HEDIS_MEASURE_2020];

/*(2) Adjust the [Measure.ID] column from the source spreadsheets so it is unique and <= 5 characters.*/
SELECT * INTO ref.hedis_measure_2020 
FROM (
SELECT DISTINCT
 2020 AS [version]
,CASE WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'CPT Code Modifiers' THEN 'GG_1'
      WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'Identifying Events/Diagnoses Using Laboratory or Pharmacy Data' THEN 'GG_2'
      WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'Members in Hospice' THEN 'GG_3'
      --WHEN [Measure.ID] = 'PCR2020' AND [Measure.Name] = 'Plan All-Cause Readmissions 2020 Version' THEN 'PCR20'
	  ELSE [Measure.ID]
 END AS [measure_id]
,[Measure.Name] AS [measure_name]
FROM [tmp].[tmp_Measures_to_ValueSets.xlsx] ) a;

/*(3) Add [Measure.ID] from the medications measures if not already included in the medical measures. */
INSERT INTO ref.hedis_measure_2020  
([version]
,[measure_id]
,[measure_name])
SELECT DISTINCT
 2020 AS [version]
,[Measure.ID] AS [measure_id]
,[Measure.Name] AS [measure_name]
FROM [tmp].[tmp_Measures_to_MedicationLists.xlsx]
WHERE [Measure.ID] NOT IN
(
SELECT DISTINCT [measure_id] FROM [ref].[hedis_measure]
);

 --TRUNCATE TABLE [ref].[hedis_value_set_2020];

SELECT * INTO [ref].[hedis_value_set_2020]
FROM (                                                         
SELECT 
 2020 AS [version]
,CASE WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'CPT Code Modifiers' THEN 'GG_1'
      WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'Identifying Events/Diagnoses Using Laboratory or Pharmacy Data' THEN 'GG_2'
      WHEN [Measure.ID] = 'GG' AND [Measure.Name] = 'Members in Hospice' THEN 'GG_3'
      --WHEN [Measure.ID] = 'PCR2020' AND [Measure.Name] = 'Plan All-Cause Readmissions 2020 Version' THEN 'PCR20'
	  ELSE [Measure.ID]
 END AS [measure_id]
,[Value.Set.Name] AS [value_set_name]
,[Value.Set.OID] AS [value_set_oid]
FROM [tmp].[tmp_Measures_to_ValueSets.xlsx]
) a ;

--TRUNCATE TABLE [ref].[hedis_medication_list_2020];

SELECT * INTO [ref].[hedis_medication_list_2020] 
FROM (
 SELECT 2020 AS [version]
,[Measure.ID] AS [measure_id]
,[Medication.List.Name] AS [medication_list_name]
FROM [tmp].[tmp_Measures_to_MedicationLists.xlsx]) a;

/* (4) Reformat codes: Remove '.' from ICD10CM, Remove '.' and right-zero-pad ICD9CM. 
*/
--TRUNCATE TABLE [ref].[hedis_code_system_2020];

SELECT * INTO [ref].[hedis_code_system_2020] 
FROM (
SELECT 
 2020 AS [version]
,[Value.Set.Name] AS [value_set_name]
,[Code.System] AS [code_system]
,CASE WHEN [Code.System] = 'ICD10CM' THEN REPLACE([Code], '.', '') 
      WHEN [Code.System] = 'ICD9CM' THEN REPLACE(CAST(REPLACE([Code], '.', '') AS CHAR(5)), ' ', '0')
	  WHEN [Code.System] = 'ICD9PCS' THEN REPLACE([Code], '.', '')
	  WHEN [Code.System] = 'UBTOB' THEN SUBSTRING([Code], 2, 3)
	  ELSE [Code] 
 END AS [code]
,[Definition] AS [definition]
,[Value.Set.Version] AS [value_set_version]
,[Code.System.Version] AS [code_system_version]
,[Value.Set.OID] AS [value_set_oid]
,[Code.System.OID] AS [code_system_oid]
FROM [tmp].[tmp_ValueSets_to_Codes.xlsx]
) a ;

--TRUNCATE TABLE [ref].[hedis_ndc_code_2020]

SELECT * INTO [ref].[hedis_ndc_code_2020]
FROM (
SELECT DISTINCT
 2020 AS [version]
,CASE WHEN [Medication.List.Name] = 'N/A' THEN NULL ELSE [Medication.List.Name] END AS [medication_list_name]
,CASE WHEN [Code] = 'N/A' THEN NULL ELSE [Code] END AS [code]
,CASE WHEN [Code.System] ='N/A' THEN NULL ELSE [Code.System] END AS [code_system]
,CASE WHEN [Brand.Name] = 'N/A' THEN NULL ELSE [Brand.Name] END AS [brand_name]
,CASE WHEN [Generic.Product.Name] = 'N/A' THEN NULL ELSE [Generic.Product.Name] END AS [generic_product_name] 
,CASE WHEN [Route] = 'N/A' THEN NULL ELSE [Route] END AS [route]
,CASE WHEN [Package.Size] = 'N/A' THEN NULL ELSE CAST([Package.Size] AS NUMERIC(18, 4)) END AS [package_size]
,CASE WHEN [Unit] = 'N/A' THEN NULL ELSE [Unit] END AS [unit]
FROM [tmp].[tmp_MedicationLists_to_Codes.xlsx]
) a;