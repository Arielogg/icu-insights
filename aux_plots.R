## AUXILIARY PLOTS SCRIPT ##
## This script generates plots centric to the analysis of the features of interest ##

# Dependencies: 
install.packages("dplyr")
library(ggplot2)

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

  
# Plotting the top 20 diagnoses for admissions in the hospital.
  
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

# Plotting confusion matrix
plt <- as.data.frame(confMatTree1$table)
plt$Prediction <- factor(plt$Prediction, levels = rev(levels(plt$Prediction)))
ggplot(plt, aes(Prediction, Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq)) +
  scale_fill_gradient(low = "white", high = "red")