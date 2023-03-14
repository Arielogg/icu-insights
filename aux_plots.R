## AUXILIARY PLOTS SCRIPT ##
## This script generates plots centric to the analysis of the features of interest ##

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

