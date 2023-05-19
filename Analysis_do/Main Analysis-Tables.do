***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

* Descriptive Statistics
set more off
clear all 

* Set path for tables and graph
	global tables "$directory/ECON 6073/Thesis/sections"
	global graphs "$directory/ECON 6073/Thesis/images"
	
cd "$directory/ECON 6073/Final_data"

use master_data
	




* check fraction BaC > 0.1 / total, BAC>0.1 / BAC >0
* Global covariates
	global X_cov beertax unemployed secondary_seat_belt primary_seat_belt hand_held_ban texting_ban speed_70 per_se_law zero_tolerance ALR bac_08 decriminalized DL VM_per_driver log_IN age 


* Table 2 - Summary stat for dependent
	eststo: estpost sum f*rate s*rate [aw=pop], 
	esttab using "$tables/table2.tex",replace label ///
	title(Dependent Variables for the Fatality Analysis Reporting System Analysis\label{tab2}) ///
	cells("mean(fmt(2)) sd") noobs
	eststo clear

* Table 3 - Summary statistics for independent
	eststo: estpost sum  MML RML MMD RMD $X_cov [aw=pop]
	esttab using "$tables/table3.tex",replace label ///
	title(Independent Variables for the Fatality Analysis Reporting System Analysis\label{tab3}) ///
	cells("mean(fmt(2)) sd") noobs
	eststo clear

* Table 4 - RML and total traffic fatalities
	* Use fractional values and not control for MML
	eststo: reghdfe ln_fatals_total_rate RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and control for MML
	eststo: reghdfe ln_fatals_total_rate MML RML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and state trend, control for MML
	eststo: reghdfe ln_fatals_total_rate MML RML $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	* Use binary indicator 
	* i. and no MML_1 
	eststo: reghdfe ln_fatals_total_rate RML_1 $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	* i. and no trend.
	eststo: reghdfe ln_fatals_total_rate MML_1 RML_1   $X_cov  [aw=pop], absorb(year state) vce(cluster state) 
	estadd local st_linear_trend "No", replace
	* i . and trend
	eststo: reghdfe ln_fatals_total_rate MML_1 RML_1  $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state) 
	estadd local st_linear_trend "Yes", replace
	
	*Table creation
	esttab using "$tables/table4.tex", replace keep(RML MML RML_1 MML_1) label b(3) se(3)  ///
	title(Recreational Marijuana Law and Total Traffic Fatalities) ///
	mlabels( ,none) ///
	s(st_linear_trend r2_within ,label("State-speific linear trend" "Within R-squared")) 
	eststo clear
	
* Table 5: Daytime Nighttime Weekdays Weekends
	foreach var of varlist ln_fatals_daytime_rate ln_fatals_nighttime_rate ln_fatals_S_F_rate ln_fatals_weekend_rate ln_fatals_weekday_rate{
		eststo: reghdfe `var' MML RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	
	}
	*Table creation
	esttab using "$tables/table5.tex", replace keep (MML RML) label b(3) se(3) ///
	title(Recreational Marijuana Law and Traffic Fatalities by Day and Time) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	s(r2_within, label("Within R-squared"))
	eststo clear

		

* Table 6 :Male Female
	foreach var of varlist ln_fatals_male_rate ln_fatals_female_rate ln_fatals_male_20_29_rate {
	eststo: reghdfe `var' MML RML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	}
	*Table creation
	esttab using "$tables/table7.tex", replace keep (MML RML) label b(3) se(3) ///
	title(Recreational Marijuana Law and Traffic Fatalities by Sex) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	s(r2_within, label("Within R-squared"))
	eststo clear

* Table 7 - RML and the role of alcohol , use with binary indicator
	* No alcohol 
	eststo: reghdfe ln_s_fatals_bac_0_rate  RML_1 $X_cov [aw=pop] , absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo: reghdfe ln_s_fatals_bac_0_rate MML_1 RML_1 $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo: reghdfe ln_s_fatals_bac_0_rate MML_1 RML_1 $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	* Positive BAC
	eststo: reghdfe ln_s_fatals_bac_pos_rate RML_1 $X_cov [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	eststo: reghdfe ln_s_fatals_bac_pos_rate MML_1 RML_1 $X_cov [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	eststo: reghdfe ln_s_fatals_bac_pos_rate MML_1 RML_1 $X_cov i.state#c.year [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	*BAC > 0.1 
	eststo:reghdfe ln_s_fatals_bac_10_rate  RML_1 $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo:reghdfe ln_s_fatals_bac_10_rate MML_1 RML_1 $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo:reghdfe ln_s_fatals_bac_10_rate MML_1 RML_1 $X_cov i.state#c.year [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	*Table creation
	esttab using "$tables/table7.tex", replace keep (MML_1 RML_1) label	b(3) se(3) ///
	title(Recreational Marijuana Laws and Traffic Fatalities: The Role of Alcohol) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels( ,none) ///
	s(st_linear_trend r2_within,label("State-specific linear trend" "Within R-squared"))
	eststo clear
* Table 8 - RML and the role of alcohol , use with fractional indicator
	* No alcohol 
	eststo: reghdfe ln_s_fatals_bac_0_rate  RML $X_cov [aw=pop] , absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo: reghdfe ln_s_fatals_bac_0_rate MML RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo: reghdfe ln_s_fatals_bac_0_rate MML RML $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	* Positive BAC
	eststo: reghdfe ln_s_fatals_bac_pos_rate RML $X_cov [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	eststo: reghdfe ln_s_fatals_bac_pos_rate MML RML $X_cov [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	eststo: reghdfe ln_s_fatals_bac_pos_rate MML RML $X_cov i.state#c.year [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	*BAC > 0.1 
	eststo:reghdfe ln_s_fatals_bac_10_rate  RML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo:reghdfe ln_s_fatals_bac_10_rate MML RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	eststo:reghdfe ln_s_fatals_bac_10_rate MML RML $X_cov i.state#c.year [aw=pop],  absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	*Table creation
	esttab using "$tables/table8.tex", replace keep (MML RML) label	b(3) se(3) ///
	title(Recreational Marijuana Laws and Traffic Fatalities: The Role of Alcohol) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	mlabels( ,none) ///
	s(st_linear_trend r2_within,label("State-specific linear trend" "Within R-squared"))
	eststo clear

	
	
* Table 9: RML and age group

foreach var of varlist ln_fatals_15_19_rate ln_fatals_20_29_rate ln_fatals_30_39_rate ln_fatals_40_49_rate ln_fatals_50_59_rate ln_fatals_60plus_rate {
	eststo: reghdfe `var' MML RML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
}
	esttab using "$tables/table9.tex", replace keep (MML RML) label b(3) se(3) ///
	title(Recreational Marijuana Law and Traffic Fatalities by Age Group) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	s(r2_within, label("Within R-squared"))
	eststo clear
	
* Table 10: Selective Migration check
	foreach var of varlist pop pop_male pop_female pop_female_20_29 pop_male_20_29 pop_male_30_39  DL VM {
	eststo: reghdfe `var' MML RML, absorb(year state) vce(cluster state)
	}
	esttab using "$tables/table10.tex", replace label keep (MML RML) b(0) t ///
	title(Selective Migration Check) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	s(r2_within, label("Within R-squared"))
	eststo clear 
	
* Robustness checks
	* Table 11: Using RMD and MMD instead of RML and MML 

	* Use fractional values and not control for MMD
	eststo: reghdfe ln_fatals_total_rate RMD $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and control for MMD
	eststo: reghdfe ln_fatals_total_rate MMD RMD $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and state trend, control for MMD
	eststo: reghdfe ln_fatals_total_rate MMD RMD $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	* Use binary indicator 
	* i. and no MMD_1 
	eststo: reghdfe ln_fatals_total_rate RMD_1 $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	* i. and no trend.
	eststo: reghdfe ln_fatals_total_rate MMD_1 RMD_1   $X_cov  [aw=pop], absorb(year state) vce(cluster state) 
	estadd local st_linear_trend "No", replace
	* i . and trend
	eststo: reghdfe ln_fatals_total_rate MMD_1 RMD_1  $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state) 
	estadd local st_linear_trend "Yes", replace
	
	*Table creation
	esttab using "$tables/table11.tex", replace keep(RMD MMD MMD_1 RMD_1) label b(3) se(3)  ///
	title(Recreational Marijuana Dispensary and Total Traffic Fatalities) ///
	mlabels( ,none) ///
	s(st_linear_trend r2_within ,label("State-speific linear trend" "Within R-squared")) 
	eststo clear

* Table 12:  Using different total traffic fatalities definition
	* traffic fatalities/ number of licensed driver 
	gen ln_fatals_total_DL = ln(fatals_total/DL)
	* Use fractional values and not control for MML
	eststo: reghdfe ln_fatals_total_DL RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and control for MML
	eststo: reghdfe ln_fatals_total_DL RML MML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	* Use fractional values and state trend, control for MML
	eststo: reghdfe ln_fatals_total_DL RML MML $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace

	
	
	* traffic fatalites/ miles driven 
	gen ln_fatals_total_VM = ln(fatals_total/VM*1000)
	* Use fractional values and not control for MML
	eststo: reghdfe ln_fatals_total_VM RML $X_cov [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace

	* Use fractional values and control for MML
	eststo: reghdfe ln_fatals_total_VM RML MML $X_cov  [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "No", replace
	
	* Use fractional values and state trend, control for MML
	eststo: reghdfe ln_fatals_total_VM RML MML $X_cov i.state#c.year [aw=pop], absorb(year state) vce(cluster state)
	estadd local st_linear_trend "Yes", replace
	
	*Table creation
	esttab using "$tables/table12.tex", replace keep(MML RML) label b(3) se(3)  ///
	title(Recreational Marijuana and Total Traffic Fatalities by different definitions) ///
	mlabels( ,none) ///
	s(st_linear_trend r2_within ,label("State-speific linear trend" "Within R-squared")) 
	eststo clear
	
	

	

