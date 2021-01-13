
#### Call in libraries ####
library("dplyr")
library("dbplyr")
library("DBI")
library("odbc")
library("openxlsx")
library(readxl) #Read Excel files

library(writexl) #Export Excel files
library("tidyr")
library("glue")
library("devtools")
library("medicaid")

library("lubridate")
library("janitor")

#### Set up Database Connection ####
#dsn <- "DCHS"
dsn <- "PHClaims"
db.connection <- dbConnect(odbc(), dsn)


##### MENTAL HEALTH MEASURES
mh.file.dir <- "L:/DCHSPHClaimsData/P4P Measure code/RDA specs 2020/"

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 1)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Proc1-MCG261.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 2)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Proc2-MCG4947.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 3)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Proc3-MCG3117.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 4)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Proc4-MCG4491.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 5)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Proc5-MCG4948.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 6)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MH-Taxonomy-MCG262.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 7)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MI-Diagnosis-7MCGs.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(mh.file.dir, "MHSP-value-sets-2020-10-27 - MP.xlsx"), sheet = 8)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_Psychotropic-NDC-5MCGs.xlsx"), value=input, overwrite=TRUE)

##### SUD MEASURES
sud.file.dir <- "L:/DCHSPHClaimsData/P4P Measure code/RDA specs 2020/"

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 1)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-Dx-Value-Set.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 2)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SBIRT-Proc-Value-Set-MCG3169.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 3)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_Detox-Value-Set.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 4)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-OP-Tx-Proc-Value-Set-MG3156.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 5)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-OST-Value-Set-MCG3148.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 6)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-IP-RES-Value-Set.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 7)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-ASMT-Value-Set-MCG3149.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 8)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_SUD-Taxonomy-Value-Set-MCG3170.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 9)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_proc-w-prim-SUD-Dx-vs-MCG3324.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 10)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_proc-w-any-SUD-Dx-vs-MCG4881.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 11)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MOUD-Value-Set.xlsx"), value=input, overwrite=TRUE)

input <- read.xlsx(paste0(sud.file.dir, "SUD-Tx-Penetration-Rate-Value-Sets-2020-10-27 - MP.xlsx"), sheet = 12)
dbWriteTable(db.connection, name=Id(schema="tmp", table="tmp_MAUD-Value-Set.xlsx"), value=input, overwrite=TRUE)