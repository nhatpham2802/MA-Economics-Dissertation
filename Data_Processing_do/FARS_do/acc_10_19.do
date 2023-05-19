***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

set more off

* Use accident data
	clear all
cd "$directory/ECON 6073/Final_data/"
use acc_10_19_raw
	
* Keep useful data
	keep year state st_case day_week hour fatals
	sort year st_case
* Generate time of the day, day of the wweek	
	gen daytime     =  .
	replace daytime = 1 if inrange(hour,6,17)
	replace daytime = 0 if (hour < 6 | hour > 17)
	replace daytime = 99 if hour == 99
	
	gen nightime     = .
	replace nightime = 1  if daytime == 0 
	replace nightime = 0  if daytime == 1
	replace nightime = 99 if daytime == 99

	gen weekday = (inrange(day_week,2,6))
	gen weekend = (weekday == 0)

* Create data
	global year_loop 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
	
	foreach i in $year_loop {
		
		* Day_week, hour by year
		gen day_week`i' = day_week if year == `i'
		gen hour`i'    = hour if year == `i'
		
		
		* Number of accident, Total Fatalities.
		egen acc_count`i' = count(st_case) if year ==`i', by(state)
		egen fatals`i'    = sum(fatals)    if year ==`i', by(state)
		
		* TOD Fatalities
		gen fatals_daytime`i'   = fatals * daytime   if (daytime  != 99) & year == `i' 
		gen fatals_nighttime`i' = fatals * nightime  if (nightime != 99) & year == `i' 
		
		* DOW Fatalities
		gen fatals_weekday`i' = fatals * weekday if year == `i' 
		gen fatals_weekend`i' = fatals * weekend if year == `i' 
		
		* Friday night Fatalities
		gen fatals_F_night`i' = fatals if ((day_week`i' == 6) & (inrange(hour`i',22,24))) | (((day_week`i' == 7) & (inrange(hour`i',0,4)))) 
		
		* Saturday night Fatalities 
		gen fatals_S_night`i' = fatals if ((day_week`i' == 7) & (inrange(hour`i',22,24))) | (((day_week`i' == 1) & (inrange(hour`i',0,4)))) 
		
	}
	
* Collapse and drop unnecessary column
	qui collapse (mean) acc_count*  fatals2* (sum) fatals_*, by(state)
	

* Reshape data
	qui reshape long acc_count fatals fatals_daytime fatals_nighttime fatals_weekday fatals_weekend fatals_F_night fatals_S_night,i(state) j(year)
	
save acc_10_19_state,replace

* Create final data for FARS_10_19
qui merge 1:1 state year using person_10_19_state, keep(3) nogen

save "$directory/ECON 6073/Final_data/FARS_10_19.dta",replace	



set more on
