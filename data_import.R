## DATA IMPORT SCRIPT ##
## This script imports tables of interest from the MIMIC-IV data set ##

# Reminder: Git for this project can be found in Arielogg/icu-insights
#Importing relevant tables from data set

# Patients dataframe
patients <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/patients.csv")

# Diagnoses dataframes
diagnoses <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/diagnoses_icd.csv")
d_icds <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/d_icd_diagnoses.csv")

# Admissions dataframe
admissions <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/admissions.csv")

# OMR dataframe
omr <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/omr.csv")
