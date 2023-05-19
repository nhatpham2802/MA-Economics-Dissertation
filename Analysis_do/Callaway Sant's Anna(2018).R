#install.packages("did")
##### Callaway(2018)
rm(list = ls())
library(haven)
library(did)
master_data<- read_dta("Desktop/Study/Fall 2021/ECON 6073/Analysis/master_data.dta")
# Set missing = 0  
master_data[is.na(master_data)] <- 0
# Create varlist
varlist <- c("ln_fatals_total_rate",  
             "ln_s_fatals_bac_0_rate",
             "ln_s_fatals_bac_pos_rate",
             "ln_s_fatals_bac_10_rate"
)

out_1 <- att_gt(yname = "ln_fatals_total_rate",
                gname = "RML_year",
                idname = "state",
                tname = "year",
                xformla = ~1,
                data = master_data,
                est_method = "reg"
)
out_2 <- att_gt(yname = "ln_s_fatals_bac_0_rate",
                gname = "RML_year",
                idname = "state",
                tname = "year",
                xformla = ~1,
                data = master_data,
                est_method = "reg"
)

out_3 <- att_gt(yname = "ln_s_fatals_bac_pos_rate",
                gname = "RML_year",
                idname = "state",
                tname = "year",
                xformla = ~1,
                data = master_data,
                est_method = "reg"
)

out_4 <- att_gt(yname = "ln_s_fatals_bac_10_rate",
                gname = "RML_year",
                idname = "state",
                tname = "year",
                xformla = ~1,
                data = master_data,
                est_method = "reg"
)
#### Graph 
ggdid(out_1)
es_1 <- aggte(out_1, type = "dynamic")
ggdid(es_1)

ggdid(out_3)
es_3<- aggte(out_3, type = "dynamic")
ggdid(es_3)

ggdid(out_4)
es_4<- aggte(out_4, type = "dynamic")
ggdid(es_4)


