## DATA IMPORT SCRIPT ##
## This script imports tables of interest from the MIMIC-IV dataset ##

patients <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/patients.csv")
diagnoses <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/diagnoses_icd.csv")
procedures <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/procedures_icd.csv")
hosp_cost <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/hcpcsevents.csv")
omr <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/emar.csv")
