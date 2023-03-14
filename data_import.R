## DATA IMPORT AND FEATURE SELECTION SCRIPT ##
## This script imports tables of interest from the MIMIC-IV data set ##

#Importing relevant tables from data set
patients <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/patients.csv")
diagnoses <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/diagnoses_icd.csv")
admissions <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/admissions.csv")
omr <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/emar.csv")

d_icds <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/mimic-iv-2.2/hosp/d_icd_diagnoses.csv")

#Separating admissions which resulted in deaths from those that didn't
adm_not_dead <- subset(admissions, deathtime == "")
adm_dead <- subset(admissions, deathtime != "")

#Function for counting the number of days between admission and discharge (or death)
days_between <- function(df, start_col, end_col) {
  df[[start_col]] <- as.Date(df[[start_col]])
  df[[end_col]] <- as.Date(df[[end_col]])
  df$days_between <- as.numeric(difftime(df[[end_col]], df[[start_col]], units = "days"))
  return(df)
}

adm_not_dead_days <- days_between(adm_not_dead, "admittime", "dischtime")

summary(adm_not_dead_days$days_between)

#TODO: concentrate diagnoses and diagnose numbers per patient (take first or first two diagnoses per patient)

