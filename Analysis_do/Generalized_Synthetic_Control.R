rm(list = ls())
library(haven)
master_data<- read_dta("Desktop/Study/Fall 2021/ECON 6073/Analysis/master_data.dta")
install.packages('gsynth', type = 'source')
library(gsynth)
library(panelView)

# Generalized synthetic control
out <- gsynth(ln_fatals_total_rate ~ RML_1 + unemployed+ DL+ VM+ IN +age,data = master_data, index = c("state","year"), force = "two-way", CV = TRUE, r = c(0, 2), se = TRUE, inference = "parametric",nboots = 1000, parallel = FALSE)
plot(out)

plot(out, type = "counterfactual", raw = "none", main="estimated ATT")
print(out)
### Removing Colorado and Washington is not good for our estimates.