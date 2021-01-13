### SET UP LIBRARY
library("dplyr")
library("dbplyr")
library("DBI")
library("odbc")
library("openxlsx")

### SET UP CONNECTION
dsn <- "PHClaims"
db.connection <- dbConnect(odbc(), dsn)

# HEDIS Measures 2020

file.dir <- "L:/DCHSPHClaimsData/HEDIS/2020/HEDIS_2020_Volume_2_10.1.19/"

input <- read.xlsx(paste0(file.dir, "N. HEDIS 2020 Volume 2 Value Set Directory 10-01-2019.xlsx"), sheet = 2)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_Measures_to_ValueSets.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(file.dir, "N. HEDIS 2020 Volume 2 Value Set Directory 10-01-2019.xlsx"), sheet = 3)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_ValueSets_to_Codes.xlsx"), value=input, overwrite=TRUE)

# HEDIS Medications 2020
file.dir <- "L:/DCHSPHClaimsData/HEDIS/2020/HEDIS MY 2020 Medication List Directory.11.02.20/"

input <- read.xlsx(paste0(file.dir, "HEDIS MY 2020 Medication List Directory 2020-11-02.xlsx"), sheet = 2)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_Measures_to_MedicationLists.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(file.dir, "HEDIS MY 2020 Medication List Directory 2020-11-02.xlsx"), sheet = 3)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MedicationLists_to_Codes.xlsx"), value=input, overwrite=TRUE)