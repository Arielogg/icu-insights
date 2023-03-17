## FEATURE SELECTION SCRIPT ##
## This script selects features and relationships of interest from the MIMIC IV dataset ##

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

# Labeling days by length of stay.
categorize_days <- function(days) {
  if (days <= 7) {
    return("0")
  } else if (days <= 30) {
    return("1")
  } else {
    return("2")
  }
}

# Add new column to dataframe with categorized days
adm_not_dead_days$stay_length <- sapply(adm_not_dead_days$days_between, categorize_days)

# Getting most relevant diagnosis from diagnoses table, associated to admissions table.

extract_priority_diagnoses <- function(df1, df2) {
  # Extracting the list of unique subject IDs from admissions dataframe
  patient_list <- df2$subject_id
  
  # Filtering rows in diagnosis dataframe to keep only patients in patient list
  df1 %>%
    group_by(subject_id) %>%
    filter(seq_num == min(seq_num)) %>%
    slice(1) %>%
    group_by(subject_id) %>%
    filter(n() == 1) %>%
    filter(subject_id %in% patient_list)
}

priority_diagnoses <- extract_priority_diagnoses(diagnoses, adm_not_dead)

add_gender_age <- function(df1, df2) {
  df1 %>%
    left_join(df2 %>% select(subject_id, gender, anchor_age), by = "subject_id")
}

priority_diagnoses_age_g <- add_gender_age(priority_diagnoses, patients)

# Getting patient's blood pressure and BMI.

blood_press_bmi <- function(df) {
  # Filtering the dataframe to only include rows where result_name is "Blood Pressure" or "BMI (kg/m2)"
  df <- df[df$result_name %in% c("Blood Pressure", "BMI (kg/m2)"), ]
  
  # Ordering the dataframe by subject_id and seq_num
  df <- df[order(df$subject_id, df$seq_num), ]
  
  # Removing duplicate subject_id and result_name combinations, keeping only the first occurrence
  df <- df[!duplicated(df[, c("subject_id", "result_name")]), ]
  
  # Reshaping the data from long to wide format
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

# Merging everything in a single dataframe.

combine_dataframes <- function(adm_not_dead_days, priority_diagnoses_age_g, omr_BMI_BP) {
  # Select the columns of interest from each dataframe
  adm_not_dead_days <- adm_not_dead_days[, c("subject_id", "hadm_id", "admission_type", "insurance", "language", "marital_status", "race", "stay_length")]
  priority_diagnoses_age_g <- priority_diagnoses_age_g[, c("subject_id", "hadm_id", "icd_code", "gender", "anchor_age")]
  omr_BMI_BP <- omr_BMI_BP[, c("subject_id", "Blood_Pressure", "BMI")]
  
  # Fill missing values in race and marital_status columns with 'UNKNOWN'
  adm_not_dead_days$marital_status[is.na(adm_not_dead_days$marital_status)] <- 'UNKNOWN'
  
  # Merge the dataframes by subject_id and hadm_id
  df_merged <- merge(adm_not_dead_days, priority_diagnoses_age_g, by = c("subject_id", "hadm_id"), all = TRUE)
  df_merged <- merge(df_merged, omr_BMI_BP, by = c("subject_id"), all = TRUE)
  
  # Drop rows containing missing values
  df_merged <- na.omit(df_merged)
  
  return(df_merged)
}

final_merged_df <- combine_dataframes(adm_not_dead_days, priority_diagnoses_age_g, omr_BMI_BP)

# Exporting main table as a csv.

write.csv(final_merged_df, file = "final_merged_df.csv", row.names = FALSE)

