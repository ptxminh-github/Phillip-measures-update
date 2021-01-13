USE [PHClaims];
GO

TRUNCATE TABLE [ref].[rda_value_set_2020];

/* Mental Health Value Sets*/

-- MH-Proc1-MCG261
CREATE TABLE 
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] --VARCHAR(20)
,[value_set_name] --VARCHAR(100)
,[data_source_type] --VARCHAR(50)
,[code_set] --VARCHAR(50)
,[code] --VARCHAR(20)
,[MCG_code] --VARCHAR(20)
,[desc_1]) --VARCHAR(200)

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Proc1' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('261' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Proc1-MCG261.xlsx]

--MH-Proc2-MCG4947


INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Proc2' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('4947' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Proc2-MCG4947.xlsx];

--MH-Proc3-MCG3117
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Proc3' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3117' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Proc3-MCG3117.xlsx];

--MH-Proc4-MCG4491
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Proc4' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('4491' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Proc4-MCG4491.xlsx];

---MH-Proc5-MCG4948
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Proc5' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('4948' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Proc5-MCG4948.xlsx];

--MH-Taxonomy-MCG262
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MH-Taxonomy' AS VARCHAR(100)) AS [value_set_name]
,CAST('Taxonomy' AS VARCHAR(50)) AS [data_source_type]
,CAST('HPT' AS VARCHAR(50)) AS [code_set] -- not sure why HPT
,CAST([Taxonomy.Code] AS VARCHAR(20)) AS [code]
,CAST('262' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MH-Taxonomy-MCG262.xlsx];

---MI-Diagnosis-7MCGs
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('MI-Diagnosis' AS VARCHAR(100)) AS [value_set_name]
,CAST('Diagnosis' AS VARCHAR(50)) AS [data_source_type]
,CAST('ICD' AS VARCHAR(50)) AS [code_set] 
,CAST([ICD-9.or.ICD-10.Diagnosis.Code] AS VARCHAR(20)) AS [code]
,CAST('7MCGs' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MI-Diagnosis-7MCGs.xlsx];

---Psychotropic-NDC-5MCGs
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('MH' AS VARCHAR(20)) AS [value_set_group]
,CAST('Psychotropic-NDC' AS VARCHAR(100)) AS [value_set_name]
,CAST('Pharmacy' AS VARCHAR(50)) AS [data_source_type]
,CAST('NDC' AS VARCHAR(50)) AS [code_set] 
,CAST([NDC.Code] AS VARCHAR(20)) AS [code]
,CAST('5MCGs' AS VARCHAR(20)) AS [MCG_code]
,CAST([Long.Code.Description] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_Psychotropic-NDC-5MCGs.xlsx];



/* SUD Value Sets*/

---SUD-Dx-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-Dx-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Diagnosis' AS VARCHAR(50)) AS [data_source_type]
,CAST('ICD' AS VARCHAR(50)) AS [code_set] 
,CAST([ICD-9.or.ICD-10.Diagnosis.Code] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-Dx-Value-Set.xlsx];

--SBIRT-Proc-Value-Set (3169)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SBIRT-Proc-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3169' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SBIRT-Proc-Value-Set-MCG3169.xlsx];

---Detox-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('Detox-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([Code] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_Detox-Value-Set.xlsx]
where CodeSet='HCPC';

INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('Detox-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('ICD-9' AS VARCHAR(50)) AS [code_set]
,CAST([Code] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_Detox-Value-Set.xlsx]
where CodeSet='ICD-9 procedure code';

INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('Detox-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('ICD-10' AS VARCHAR(50)) AS [code_set]
,CAST([Code] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_Detox-Value-Set.xlsx]
where CodeSet='ICD-10 procedure code';

INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('Detox-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Billing' AS VARCHAR(50)) AS [data_source_type]
,CAST('UBREV' AS VARCHAR(50)) AS [code_set]
,CAST(FORMAT(CAST([Code] AS INT), '0000') AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_Detox-Value-Set.xlsx]
where CodeSet='revenue code';

---SUD-OP-Tx-Proc-Value-Set (3156)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-OP-Tx-Proc-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3156' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-OP-Tx-Proc-Value-Set-MG3156.xlsx];

---SUD-OST-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-OST-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3148' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-OST-Value-Set-MCG3148.xlsx];

---SUD-IP-RES-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-IP-RES-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST(CASE WHEN [CodeSet] = 'DRG' THEN 'Diagnosis'
			WHEN [CodeSet] = 'HCPC' THEN 'Procedure'
			END AS VARCHAR(50)) AS [data_source_type]
,CAST(CASE WHEN [CodeSet] = 'DRG' THEN 'DRG'
			WHEN [CodeSet] = 'HCPC' THEN 'HCPCS' 
			END AS VARCHAR(50)) AS [code_set]
,CAST([Code] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-IP-RES-Value-Set.xlsx];

---SUD-ASMT-Value-Set (3149)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-ASMT-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3149' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-ASMT-Value-Set-MCG3149.xlsx];

---SUD-Taxonomy-Value-Set (3170)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('SUD-Taxonomy-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Taxonomy' AS VARCHAR(50)) AS [data_source_type]
,CAST('HPT' AS VARCHAR(50)) AS [code_set]
,CAST([Taxonomy.Code] AS VARCHAR(20)) AS [code]
,CAST('3170' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_SUD-Taxonomy-Value-Set-MCG3170.xlsx];

---proc-w-prim-SUD-Dx-vs (3324)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('proc-w-prim-SUD-Dx-vs' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('3324' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_proc-w-prim-SUD-Dx-vs-MCG3324.xlsx];

---proc-w-any-SUD-Dx-vs (4881)
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('proc-w-any-SUD-Dx-vs' AS VARCHAR(100)) AS [value_set_name]
,CAST('Procedure' AS VARCHAR(50)) AS [data_source_type]
,CAST('CPT-HCPCS' AS VARCHAR(50)) AS [code_set]
,CAST([CPT.or.HCPC.Procedure.Code] AS VARCHAR(20)) AS [code]
,CAST('4881' AS VARCHAR(20)) AS [MCG_code]
,CAST([CodeDescription] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_proc-w-any-SUD-Dx-vs-MCG4881.xlsx];

---MOUD-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('MOUD-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Pharmacy' AS VARCHAR(50)) AS [data_source_type]
,CAST('NDC' AS VARCHAR(50)) AS [code_set] 
,CAST([NDCExpansion] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([NDCLabel] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MOUD-Value-Set.xlsx];

---MAUD-Value-Set
INSERT INTO [ref].[rda_value_set_2020]
([value_set_group] 
,[value_set_name] 
,[data_source_type] 
,[code_set] 
,[code] 
,[MCG_code] 
,[desc_1] )

SELECT 
 CAST('SUD' AS VARCHAR(20)) AS [value_set_group]
,CAST('MAUD-Value-Set' AS VARCHAR(100)) AS [value_set_name]
,CAST('Pharmacy' AS VARCHAR(50)) AS [data_source_type]
,CAST('NDC' AS VARCHAR(50)) AS [code_set] 
,CAST([NDC] AS VARCHAR(20)) AS [code]
,CAST('na' AS VARCHAR(20)) AS [MCG_code]
,CAST([NDCLabel] AS VARCHAR(200)) AS [desc_1]
FROM [tmp].[tmp_MAUD-Value-Set.xlsx];

/*DROP TEMPS TABLE*/
DROP TABLE [Tmp].[tmp_MH-Proc1-MCG261.xlsx];
DROP TABLE [tmp].[tmp_MH-Proc2-MCG4947.xlsx];
DROP TABLE [tmp].[tmp_MH-Proc3-MCG3117.xlsx];
DROP TABLE [tmp].[tmp_MH-Proc4-MCG4491.xlsx];
DROP TABLE [tmp].[tmp_MH-Proc5-MCG4948.xlsx];
DROP TABLE [tmp].[tmp_MH-Taxonomy-MCG262.xlsx];
DROP TABLE [tmp].[tmp_MI-Diagnosis-7MCGs.xlsx];
DROP TABLE [tmp].[tmp_Psychotropic-NDC-5MCGs.xlsx];
DROP TABLE [tmp].[tmp_SUD-Dx-Value-Set.xlsx];
DROP TABLE [tmp].[tmp_SBIRT-Proc-Value-Set-MCG3169.xlsx];
DROP TABLE [tmp].[tmp_Detox-Value-Set.xlsx];
DROP TABLE [tmp].[tmp_SUD-OP-Tx-Proc-Value-Set-MG3156.xlsx];
DROP TABLE [tmp].[tmp_SUD-OST-Value-Set-MCG3148.xlsx];
DROP TABLE [tmp].[tmp_SUD-IP-RES-Value-Set.xlsx];
DROP TABLE [tmp].[tmp_SUD-ASMT-Value-Set-MCG3149.xlsx];
DROP TABLE [tmp].[tmp_SUD-Taxonomy-Value-Set-MCG3170.xlsx];
DROP TABLE [tmp].[tmp_proc-w-prim-SUD-Dx-vs-MCG3324.xlsx];
DROP TABLE [tmp].[tmp_proc-w-any-SUD-Dx-vs-MCG4881.xlsx];
DROP TABLE [tmp].[tmp_MOUD-Value-Set.xlsx];
DROP TABLE [tmp].[tmp_MAUD-Value-Set.xlsx];


