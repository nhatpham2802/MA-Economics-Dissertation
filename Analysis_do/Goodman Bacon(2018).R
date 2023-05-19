# Goodman- Bacon Dianogstic test
rm(list = ls())
install.packages("bacondecomp")
library(bacondecomp)
library(haven)
library(ggplot2)
master_data<- read_dta("Desktop/Study/Fall 2021/ECON 6073/Analysis/master_data.dta")
# calculate the bacon decomposition without covariates
bacon_out <- bacon(ln_fatals_total_rate ~ RML_1,
                   data = master_data,
                   id_var = "state",
                   time_var = "year")

# plot
bacon_out %>% 
  ggplot(aes(x = weight, y = estimate, shape = factor(type), color = factor(type))) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0) +
  scale_colour_brewer(palette = 'Set1') + 
  theme_bw() + 
  labs(x = "Weight", y = "Estimate") + 
  theme(legend.position = "bottom",
        legend.title = element_blank())