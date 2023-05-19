***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************
set more on

* Event Study
clear all
global graphs "$directory/ECON 6073/Thesis/images"
cd "$directory/ECON 6073/Final_data"

use master_data 

global X_cov beertax unemployed secondary_seat_belt primary_seat_belt hand_held_ban texting_ban speed_70 per_se_law zero_tolerance ALR bac_08 decriminalized DL VM_per_driver log_IN age 
* Event DD
	* Total Traffic Fatalities no trend
	qui eventdd ln_fatals_total_rate MML $X_cov , hdfe absorb(i.state i.year) cluster(state) timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
	 	graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Total Traffic Fatalities"))
	graph export "$graphs/fig3.png", replace
		
	* Total Traffic fatalities with trend
	qui eventdd ln_fatals_total_rate MML $X_cov i.state#c.year,hdfe absorb(i.state i.year) cluster(state) timevar(TOT_RML) ///
		ci(rcap) ///
		accum leads(4) lags(3) ///
	 	graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Total Traffic Fatalities with state trend"))
	graph export "$graphs/fig4.png",replace
	
	* Role of Alcohol
		* No alcohol
		qui eventdd ln_s_fatals_bac_0_rate  $X_cov , hdfe absorb(i.state i.year) cluster(state) ///
		timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Fatalites, No Alcohol"))
	graph export "$graphs/fig5.png",replace
	
		* No alcohol with trend
		qui eventdd ln_s_fatals_bac_0_rate  $X_cov i.state#c.year , hdfe absorb(i.state i.year) cluster(state) ///
		timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Fatalites, No Alcohol state trend"))
	graph export "$graphs/fig6.png",replace
			
		* BAC > 0
		qui eventdd ln_s_fatals_bac_pos_rate $X_cov , hdfe absorb(i.state i.year) cluster(state) ///
		timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Fatalites, BAC > 0"))
	graph export "$graphs/fig7.png",replace
	
		*BAC > 0 with trend
		qui eventdd ln_s_fatals_bac_pos_rate $X_cov i.state#c.year , hdfe absorb(i.state i.year) cluster(state) ///
		timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Fatalites, BAC > 0 with trend"))
	graph export "$graphs/fig8.png",replace
		
		* BAC > 0.1 
	qui eventdd ln_s_fatals_bac_10_rate $X_cov , hdfe absorb(i.state i.year) cluster(state) timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title("Fatalites, BAC > 0.1"))
	graph export "$graphs/fig9.png",replace
	
		* BAC >0.1 with trend
	qui eventdd ln_s_fatals_bac_10_rate $X_cov i.state#c.year,hdfe absorb(i.state i.year) cluster(state) ///
		timevar(TOT_RML) ci(rcap) ///
		accum leads(4) lags(3) ///
		graph_op(ytitle("Log Fatality Rate") xlabel(-5(1)5) title(" Fatalites, BAC > 0.1 with trend"))
	graph export "$graphs/fig10.png"	,replace
		
	
	
	* Event study full leads and lags 
	qui eventdd ln_fatals_total_rate MML $X_cov , hdfe absorb(i.state i.year) cluster(state) timevar(TOT_RML) ci(rcap) ///
	 graph_op(ytitle("Log Fatality Rate") xlabel(-10(1)10) title("Total Traffic Fatalities"))
		
	* Event study full leads and lags no control
	qui eventdd ln_fatals_total_rate, hdfe absorb(i.state i.year) cluster(state) timevar(TOT_RML) ci(rcap) ///
	 graph_op(ytitle("Log Fatality Rate") xlabel(-10(1)10) title("Total Traffic Fatalities"))	
	 
	 








	
	
	
set more off	
		

	

