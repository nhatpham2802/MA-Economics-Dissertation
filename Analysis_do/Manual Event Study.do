
clear all
* Event Study by h
use master_data
	global X_cov beertax unemployed secondary_seat_belt primary_seat_belt hand_held_ban texting_ban speed_70 per_se_law zero_tolerance ALR bac_08 decriminalized DL VM_per_driver log_IN age 

replace TOT_RML = 0 if missing(TOT_RML)

gen treat_state = inlist(state,2,6,8,11,23,25,26,32,50,53)

sum TOT_RML 
g shifted_ttt = TOT_RML - r(min)
summ shifted_ttt if TOT_RML == -1
local true_neg1 = r(mean)

reghdfe ln_fatals_total_rate ib`true_neg1'.shifted_ttt $X_cov, a(state year) vce(cluster state)
reghdfe ln_s_fatals_bac_pos_rate ib`true_neg1'.shifted_ttt $X_cov , a(stfips year) vce(cluster stfips)
reghdfe ln_s_fatals_bac_10_rate ib`true_neg1'.shifted_ttt $X_cov , a(stfips year) vce(cluster stfips)

g coef = .
g se = .
levelsof shifted_ttt, l(times)
foreach t in `times' {
	replace coef = _b[`t'.shifted_ttt] if shifted_ttt == `t'
	replace se = _se[`t'.shifted_ttt] if shifted_ttt == `t'
}

* Make confidence intervals
g ci_top = coef+1.96*se
g ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per quarter
* now switch back to time_to_treat to get original timing
keep TOT_RML coef se ci_*
duplicates drop

sort TOT_RML

* Create connected scatterplot of coefficients
* with CIs included with rcap
* and a line at 0 both horizontally and vertically
summ ci_top
local top_range = r(max)
summ ci_bottom
local bottom_range = r(min)

twoway (sc coef TOT_RML, connect(line)) ///
	(rcap ci_top ci_bottom TOT_RML)	///
	(function y = 0, range(TOT_RML)) ///
	(function y = 0, range(`bottom_range' `top_range') horiz), ///
	xtitle("Time to Treatment") caption("95% Confidence Intervals Shown")
