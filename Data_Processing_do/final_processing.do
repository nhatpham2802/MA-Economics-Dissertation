***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************
set more off
clear all

cd "$directory/ECON 6073/Final_data"

*Merge with righ-hand side data to create master data
	use X_cov
	merge 1:1 state year using FARS_10_19, keep(3) nogen




* Gen fatality rates per 100,000 population
	local var_pop_100 fatals_total s_fatals_bac_pos s_fatals_bac_0 s_fatals_bac_10 s_fatals_420 fatals_weekend fatals_weekday fatals_F_night fatals_S_night fatals_daytime fatals_nighttime
	
	foreach var in `var_pop_100' {
		gen `var'_rate= `var' * 100000/pop
	}
	
* Gen fatality rates for male and female 
	gen fatals_male_rate = fatals_male * 100000/ pop_male
	gen fatals_female_rate = fatals_female * 100000 /pop_female
	gen fatals_male_20_29_rate = fatals_male_20_29 * 100000 / pop_male_20_29
	
* Gen fatality rates for age group
	gen fatals_15_19_rate = fatals_15_19 * 100000 /pop_15_19
	gen fatals_20_29_rate = fatals_15_19 * 100000 /pop_20_29
	gen fatals_30_39_rate = fatals_15_19 * 100000 /pop_30_39
	gen fatals_40_49_rate = fatals_15_19 * 100000 /pop_40_49
	gen fatals_50_59_rate = fatals_15_19 * 100000 /pop_50_59
	gen fatals_60plus_rate = fatals_60plus * 100000 /pop_60_plus

* Gen fatality by S and F
	gen fatals_S_F_rate = fatals_F_night_rate +fatals_S_night_rate
	
* gen log
	foreach var of varlist *_rate{
		gen ln_`var' = ln(`var')
	}

* gen log_in
	gen log_IN = ln(IN)

* Gen MML_1 , RML_1, MMD_1 ,RMD_1 binary indicator
	gen MML_1 = 0 
	replace MML_1 = 1 if MML > 0
	
	gen RML_1 = 0
	replace RML_1 = 1 if RML > 0 
	
	gen MMD_1 = 0
	replace MMD_1 = 1 if MMD > 0 
	
	gen RMD_1 = 0
	replace RMD_1 = 1 if RMD > 0
* Gen year of MML, RML, MMD , RMD 
	egen MML_y = min(year) if MML_1 == 1, by (state)
	egen MML_year = min(MML_y), by(state)
	
	egen RML_y = min(year) if RML_1 == 1, by (state)
	egen RML_year = min(RML_y), by(state)
	
	egen MMD_y = min(year) if MMD_1 == 1, by (state)
	egen MMD_year = min(MMD_y), by(state)
	
	egen RMD_y = min(year) if RMD_1 == 1, by (state)
	egen RMD_year = min(RMD_y), by(state)
	drop MML_y RML_y MMD_y RMD_y
	
* Gen time to treat 
	gen TOT_MML = year - MML_year
	gen TOT_RML = year - RML_year
	gen TOT_MMD = year - MMD_year
	gen TOT_RMD = year - RMD_year
* label data for later use
label var s_fatals_bac_pos_rate "Fatalities (BAC > 0) "
label var s_fatals_bac_0_rate "Fatalities (No alcohol)"
label var s_fatals_420_rate "Fatalities Marijuana"
label var s_fatals_bac_10_rate "Fatalities (BAC >0.1) "
label var fatals_weekend_rate "Fataliteis Weekends"
label var fatals_weekday_rate "Fatalities Weekdays"
label var fatals_male_rate "Fatalities Male"
label var fatals_female_rate "Fatalities Female"
label var fatals_male_20_29_rate "Fatalities Male,20-29"
label var fatals_15_19_rate "Fatalities, 15-19"
label var fatals_20_29_rate "Fatalities, 20-29"
label var fatals_30_39_rate "Fatalities, 30-39"
label var fatals_40_49_rate "Fatalities, 40-49"
label var fatals_50_59_rate "Fatalities, 40-49"
label var fatals_60plus_rate "Fatalities, 60+"
label var fatals_S_F_rate 	"Fatalities F-S night"
label var fatals_total_rate "Total Fatalities"
* label log
label var ln_fatals_total_rate "Total Fatalities"
label var ln_s_fatals_bac_pos_rate "Fatalities (BAC>0)" 
label var ln_s_fatals_bac_0_rate "Fatalities (No alcohol)"
label var ln_s_fatals_bac_10_rate "Fatalities (BAC >0.1)"
label var ln_s_fatals_420_rate "Fatalities 420"
label var ln_fatals_weekend_rate "Fatalities Weekends"
label var ln_fatals_weekday_rate "Fatalities Weekdays"
label var ln_fatals_F_night_rate "Fatalities Friday night"
label var ln_fatals_S_night_rate "Fatalities Saturday night"
label var ln_fatals_daytime_rate "Fatalities Daytime"
label var ln_fatals_nighttime_rate "Fatalities Nighttime"
label var ln_fatals_male_rate "Fatalities Male"
label var ln_fatals_female_rate "Fatalities Female"
label var ln_fatals_male_20_29_rate "Fatalities Male,20-29"
label var ln_fatals_15_19_rate "Fatalities, 15-19"
label var ln_fatals_20_29_rate "Fatalities, 20-29"
label var ln_fatals_30_39_rate "Fatalities, 30-39"
label var ln_fatals_40_49_rate "Fatalities, 40-49"
label var ln_fatals_50_59_rate "Fatalities, 40-49"
label var ln_fatals_60plus_rate "Fatalities, 60+"
label var ln_fatals_S_F_rate "Fatalities F-S night"

*label independent variables
label var beertax "Beer Tax"
label var unemployed "Unemployment"
label var secondary_seat_belt "Secondary Seat Belt"
label var primary_seat_belt  "Primary Seat Belt"
label var hand_held_ban "Handheld Ban"
label var texting_ban  "Texting Ban"
label var speed_70  "Speed 70"
label var per_se_law "Drug Per Se"
label var zero_tolerance "Zero Tolerance"
label var ALR "ALR"
label var bac_08 "BAC .08"
label var decriminalized "Decriminalized"
label var DL "Driver License"
label var VM "Miles Driven not rate"
label var log_IN "Income"
label var age "Median Age"

save master_data, replace
	

set more on
