## AUXILIARY PLOTS SCRIPT ##
## This script generates plots centric to the analysis of the features of interest ##

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
