## AUXILIARY PLOTS SCRIPT ##
## This script generates plots centric to the analysis of the features of interest ##

# Dependencies: 
library(ggplot2)
library(caret)
library(reshape2)

## Probability density plot for hospital stays.
plot(density(adm_not_dead_days$days_between),
     main = "Probability Density of Hospital Stay Lenghts",
     xlab = "Stay lengths (days)")
abline(v = mean(adm_not_dead_days$days_between), col = "red", lwd = 1)
rug(adm_not_dead_days$days_between)
grid(lty = "dashed")

## Probability density plot for hospital stays, focused.
plot(density(adm_not_dead_days$days_between),
     main = "Probability Density of Hospital Stay Lenghts",
     xlab = "Stay lengths (days)",
     xlim = c(0, 50))
abline(v = mean(adm_not_dead_days$days_between), col = "red", lwd = 1)
rug(adm_not_dead_days$days_between)
grid(lty = "dashed")

# Doing a count plot of the labeled stay lengths
labels <- c("Short", "Medium", "Long")

ggplot(adm_not_dead_days, aes(x = stay_length, fill = stay_length))  +
  geom_bar() +
  labs(title = "Length of Stay Distribution",
       x = "Length of Stay",
       y = "Count") +
  scale_y_log10() +
  scale_x_discrete(labels = labels)
  scale_fill_manual(values = c("blue", "red","green" ), name = "Length of Stay")

  
## To plot the top 20 primary diagnoses for admissions in the hospital.
  
diagnosis_counts <- priority_diagnoses %>%
  group_by(icd_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

top_20_diagnoses <- head(diagnosis_counts, 20)
diag_labels <- c('Chest pain', 'Coronary atherosclerosis', 'Other chest pain', 'Alcohol abuse', 'Depressive disorder', 'Major depressive disorder', 'Subendocardial infarction', 'Syncope', 'NSTEMI', 'Pneumonia','Sepsis','Atrial fibrilation','Alcohol intoxication','Unspecified septicemia','Acute appendicitis','Chest pain','Kidney failure','Aortic valve disorders','UTI','Pancreatitis')

ggplot(top_20_diagnoses, aes(x = reorder(icd_code, -count), y = count)) +
  geom_bar(stat = "identity") +
  xlab("Diagnosis") +
  ylab("Count") +
  scale_x_discrete(labels = diag_labels) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

### Confusion matrix of RF
# Melt the confusion matrix into a long format
cmNorm_rf <- conf_mat_rf$table / rowSums(conf_mat_rf$table)
cmMelted_rf <- melt(cmNorm_rf)

# Plot the confusion matrix as a heatmap

ggplot(cmMelted_rf, aes(x = Prediction, y = Reference, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme_minimal() +
  ggtitle(paste("Confusion Matrix for the RF Classifier, Accuracy =", round(conf_mat_rf$overall["Accuracy"], 2)))


### Confusion matrix of DT
# Melt the confusion matrix into a long format
cmNorm_dt <- conf_mat_dt$table / rowSums(conf_mat_dt$table)
cmMelted_dt <- melt(cmNorm_dt)

# Plot the confusion matrix as a heatmap

ggplot(cmMelted_dt, aes(x = Prediction, y = Reference, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme_minimal() +
  ggtitle(paste("Confusion Matrix for the DT Classifier, Accuracy =", round(conf_mat_dt$overall["Accuracy"], 2)))


### Confusion matrix of XGB
# Melt the confusion matrix into a long format
cmNorm <- conf_mat_xgb$table / rowSums(conf_mat_xgb$table)
cmMelted <- melt(cmNorm)

# Plot the confusion matrix as a heatmap
colnames(cmMelted)

ggplot(cmMelted, aes(x = Prediction, y = Reference, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme_minimal() +
  ggtitle(paste("Confusion Matrix for the XGB Classifier, Accuracy =", round(conf_mat_xgb$overall["Accuracy"], 2)))
