***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

* Beer Tax
clear all

import excel "$directory/ECON 6073/Raw_data/Covariate/beertax.xls",  ///
sheet("Sheet1")cellrange(C1:F61) firstrow ///


keep state beertax
drop if state == . 
save "$directory/ECON 6073/Final_data/beer_tax_state.dta", replace

