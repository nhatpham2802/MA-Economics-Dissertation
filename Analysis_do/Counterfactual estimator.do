***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************
set more on

* Counterfacutal estimator: 
clear all
cd "$directory/ECON 6073/Final_data"
use master_data
global X_cov beertax unemployed secondary_seat_belt primary_seat_belt hand_held_ban texting_ban speed_70 per_se_law zero_tolerance ALR bac_08 decriminalized DL VM_per_driver log_IN age 
* Install fect package, if Professor have any problems while installing, check this link: https://yiqingxu.org/packages/fect/stata/fect_md.html 

	net install fect, from(https://raw.githubusercontent.com/xuyiqing/fect_stata/master/) replace

* Counterfactual Estimator
	* Total traffic fatalities
	fect ln_fatals_total_rate, treat(RML_1) unit(state) time(year) cov(	$X_cov) method("fe") force("two-way")
	*BAC > 0
	fect ln_s_fatals_bac_pos_rate, treat(RML_1) unit(state) time(year) cov($X_cov) method("fe") force("two-way")
	*BAC > 0.1
		fect ln_s_fatals_bac_10_rate, treat(RML_1) unit(state) time(year) cov($X_cov) method("fe") force("two-way")

*Histogram shows the number of treated units for each period.



* Leave- one - out analysis
replace stname = "DC" if state == 11
	local state_loo Alaska California Colorado DC Maine Massachusetts Michigan Nevada Vermont Washington

	foreach x in `state_loo' {
		
		* total traffic fatalities
		
		qui reghdfe ln_fatals_total_rate MML RML $X_cov [aw=pop] if stname !="`x'", /// 
		absorb(year state) vce(cluster state)
		eststo total_`x'
		*BAC > 0
		qui reghdfe ln_s_fatals_bac_pos_rate MML RML $X_cov [aw=pop] if stname !="`x'", /// 
		absorb(year state) vce(cluster state)
		eststo BAC_`x'
		*BAC > 0.1 
		qui eststo: reghdfe ln_s_fatals_bac_10_rate MML RML $X_cov [aw=pop] if stname !="`x'", /// 
		absorb(year state) vce(cluster state)
		eststo BAC01_`x'
	
	}
	* Without dropping any state:
	qui reghdfe ln_fatals_total_rate MML RML $X_cov [aw=pop], /// 
		absorb(year state) vce(cluster state)
	eststo total_none
	
	qui reghdfe ln_s_fatals_bac_pos_rate MML RML $X_cov [aw=pop], /// 
		absorb(year state) vce(cluster state)
	eststo BAC_none
	
	qui reghdfe ln_s_fatals_bac_10_rate MML RML $X_cov [aw=pop], /// 
		absorb(year state) vce(cluster state)
	eststo BAC01_none
	
	* Graph loo analysis for total fatalities
coefplot total_*, vertical keep(RML) yline(0.0148421 ) ///
title("Total traffic fatalities")
	* Graph loo analysis for fatalities > 0 
coefplot BAC_*, vertical keep(RML) yline(0.0959911 ) ///
title("Fatalities BAC > 0")
	* Graph loo analysis for fatalities >0.1
coefplot BAC01_*, vertical keep(RML) yline(0.1777597) ///
title("Fatalities BAC > 0.1")

* No graph export here 

eststo clear 


set more off 
