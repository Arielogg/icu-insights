## FEATURE SELECTION SCRIPT ##
## This script selects features and relationships of interest from the MIMIC IV dataset ##

#Dependencies on this script
install.packages("reshape2") # If not installed
install.packages("dplyr") # If not installed
library(reshape2)
library(dplyr)

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

# Adding number of days for each admission
adm_not_dead <- days_between(adm_not_dead, "admittime", "dischtime")

# Labeling days by length of stay.
categorize_days <- function(days) {
  if (days <= 7) {
    return("0") # Short stays
  } else if (days <= 30) {
    return("1") # Medium stays
  } else {
    return("2") # Long stays
  }
}

# Add new column to dataframe with categorized days
adm_not_dead$stay_length <- sapply(adm_not_dead$days_between, categorize_days)


# Getting the 10 most important diagnoses per admission
get_top_diag <- function(diagnoses, adm_not_dead) {
  top_diag <- diagnoses %>%
    group_by(hadm_id) %>%
    arrange(seq_num) %>%
    slice_head(n = 10) %>%
    ungroup()
  
  result <- adm_not_dead %>%
    left_join(top_diag, by = c("subject_id", "hadm_id")) %>%
    select(hadm_id, subject_id, icd_code, seq_num, days_between)
  return(result)
}

# Assigning target coding to each admission based on icd_codes/length of stay
encode_admissions <- function(top_diagnoses) {
  icd_means <- top_diagnoses %>%
    group_by(icd_code) %>%
    summarise(mean_stay = mean(days_between)) %>%
    ungroup()
  
  df_encoded <- top_diagnoses %>%
    left_join(icd_means, by = "icd_code") %>%
    group_by(hadm_id, subject_id) %>%
    summarise(encoded_admission = sum(mean_stay)) %>%
    ungroup()

  return(df_encoded)
}

top_10_diagnoses <- get_top_diag(diagnoses, adm_not_dead_days)
encoded_admissions <- encode_admissions(top_10_diagnoses)

# Adding gender and age from patients table
add_gender_age <- function(encoded_admissions, patients) {
  encoded_admissions %>%
    left_join(patients %>% select(subject_id, gender, anchor_age), by = "subject_id")
}

priority_diagnoses_age_g <- add_gender_age(encoded_admissions, patients)

# Getting patient's blood pressure and BMI.

blood_press_bmi <- function(df) {
  # Filtering the dataframe to only include rows where result_name is "Blood Pressure" or "BMI (kg/m2)"
  df <- df[df$result_name %in% c("Blood Pressure", "BMI (kg/m2)"), ]
  df <- df[order(df$subject_id, df$seq_num), ]
  df <- df[!duplicated(df[, c("subject_id", "result_name")]), ]
  
  df_wide <- reshape(df,
                     idvar = "subject_id",
                     timevar = "result_name",
                     direction = "wide")
  
  # Renaming columns
  colnames(df_wide)[colnames(df_wide) == "result_value.Blood Pressure"] <- "Blood_Pressure"
  colnames(df_wide)[colnames(df_wide) == "result_value.BMI (kg/m2)"] <- "BMI"
  
  # Dropping rows containing empty cells
  df_wide <- na.omit(df_wide)
  
  return(df_wide)
}

omr_BMI_BP <- blood_press_bmi(omr)

# Splitting blood pressure into systolic and diastolic

split_BP <- function(df, column_name) {
  df[["systolic"]] <- as.integer(sapply(strsplit(as.character(df[[column_name]]), "/"), "[", 1))
  df[["diastolic"]] <- as.integer(sapply(strsplit(as.character(df[[column_name]]), "/"), "[", 2))
  df[[column_name]] <- NULL
  return(df)
}

omr_BMI_BP <- split_BP(omr_BMI_BP, "Blood_Pressure")

# Merging everything in a single dataframe.

combine_dataframes <- function(adm_not_dead_days, priority_diagnoses_age_g, omr_BMI_BP) {
  # Here I combine all the previously extracted data
  adm_not_dead_days <- adm_not_dead_days[, c("subject_id", "hadm_id", "admission_type", "insurance", "language", "marital_status", "race", "stay_length", "days_between")]
  priority_diagnoses_age_g <- priority_diagnoses_age_g[, c("subject_id", "hadm_id", "encoded_admission", "gender", "anchor_age")]
  omr_BMI_BP <- omr_BMI_BP[, c("subject_id", "systolic", "diastolic", "BMI")]
  
  adm_not_dead_days$marital_status[is.na(adm_not_dead_days$marital_status)] <- 'UNKNOWN'
  df_merged <- merge(adm_not_dead_days, priority_diagnoses_age_g, by = c("subject_id", "hadm_id"), all = TRUE)
  df_merged <- merge(df_merged, omr_BMI_BP, by = c("subject_id"), all = TRUE)
  df_merged <- na.omit(df_merged)
  
  return(df_merged)
}

final_merged_df <- combine_dataframes(adm_not_dead_days, priority_diagnoses_age_g, omr_BMI_BP)

# Exporting main table as a csv.

write.csv(final_merged_df, file = "encoded_admissions_df.csv", row.names = FALSE)
