## DATA IMPORT SCRIPT ##
## This script imports tables of interest from the MIMIC-IV dataset ##

patients <- read.csv("/Users/arielguerra/Documents/MLDM/Data Mining/Project/mimic-iv-2.2/hosp/patients.csv")
diagnoses <- read.csv("/Users/arielguerra/Documents/MLDM/Data Mining/Project/mimic-iv-2.2/hosp/diagnoses_icd.csv")
procedures <- read.csv("/Users/arielguerra/Documents/MLDM/Data Mining/Project/mimic-iv-2.2/hosp/procedures_icd.csv")
hosp_cost <- read.csv("/Users/arielguerra/Documents/MLDM/Data Mining/Project/mimic-iv-2.2/hosp/hcpcsevents.csv")
omr <- read.csv("/Users/arielguerra/Documents/MLDM/Data Mining/Project/mimic-iv-2.2/hosp/emar.csv")
