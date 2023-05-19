rm(list = ls())
library(gsynth)
library(haven)
master_data<- read_dta("Desktop/Study/Fall 2021/ECON 6073/Analysis/master_data.dta")

library(panelView)
panelView(fatals ~ RML_1, data = master_data,  index = c("stname","year"),xlab = "Year", ylab= "State ", by.timing = TRUE ,pre.post = TRUE, legend.labs = c("Control States", "Treated States (before RML)", "Treated States (after RML)"))
panelView(fatals ~ RML_1, data = master_data,  index = c("state","year"), type = "outcome")
out <- gsynth(ln_fatals_total ~ RML_1 +unemployed+ DL+ VM+ IN +age, data +MML_1,data = master_data, index = c("state","year"), force = "two-way", CV = TRUE, r = c(0, 2), se = TRUE, inference = "parametric", nboots = 1000, parallel = FALSE)


