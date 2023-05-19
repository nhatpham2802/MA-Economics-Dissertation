***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

set more off
*Using person data, 

clear all
cd "$directory/ECON 6073/Final_data/"

use person_10_19_raw


* Gen Year and Keep useful columns
	keep per_typ inj_sev  alc_res age county sex drugres1 drugres2  drugres3 drugres state  st_case id
	keep if inj_sev == 4 // Keep only dead people
	gen year = real(subinstr(id, "person_", "", .))
	tab year
	tab id
* Create BAC, no BAC, BAC > 0.1 with at least one driver involved indicator
	*2010-2014
		recode alc_res (0/10 95 96 97 98 99 = 0 "BAC < 0.1") (10/94  = 1 "BAC > 0.1") if (inrange(year,2010,2014) & per_typ == 1), gen (bac_10_10_14) // BAC > 0.1
		recode alc_res (0 95 96 97 99 = 0 "BAC = 0") (1/94 98 = 1 "BAC >0") if (inrange(year,2010,2014)& per_typ == 1),		 gen (bac_10_14) //BAC > 0
		gen bac_0 = (bac_10_14 == 0)
		
	*2015-2019
		recode alc_res (0/100 995 996 997 998 999 = 0 "BAC < 0.1") (100/940  = 1 "BAC > 0.1") if (inrange(year,2015,2019)& 		  per_typ == 1), ///
		gen (bac_10_15_19) // BAC>0.1
		
		recode alc_res (0 995 996 997 999 = 0 "BAC = 0") (1/940 998 = 1 "BAC >0") if (inrange(year,2015,2019)& per_typ == 1),		 gen (bac_15_19) //BAC > 0
		
		replace bac_0 = 1 if bac_15_19 == 0 // BAC = 0 
		
	* 2010 -2019
		gen bac_10  = (bac_10_10_14 ==1 | bac_10_15_19 == 1)
		gen bac_pos = (bac_10_14 == 1 | bac_15_19 == 1) 
	
* Create Pot indicator
	*2010-2017
		recode drugres1 drugres2 drugres3 (600/695 = 1 ) (else = 0) if (inrange(year,2010,2017)), gen(new_drugres1 new_drugres2 new_drugres3) 
		gen pot_related = (new_drugres1 ==1 | new_drugres2 ==1 |new_drugres3 == 1) & (per_typ == 1)
	
	*2018-2019
		recode drugres (600/695 = 1 ) (else = 0 ), gen(new_drugres)
		replace pot_related = ((new_drugres == 1) & (per_typ == 1))

* Global for year_loop
	global year_loop 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019

* Fatalities by age group, sex, total
	foreach i in $year_loop {
		* Fatalities by age group by year
		egen fatals_15_19`i'	= count(age) if (age >= 15 & age <= 19  & year == `i'), by(state)
		egen fatals_20_29`i'    = count(age) if (age >= 20 & age <= 29  & year == `i'), by(state)
		egen fatals_30_39`i'	= count(age) if (age >= 30 & age <= 39  & year == `i'), by(state)
		egen fatals_40_49`i'	= count(age) if (age >= 40 & age <= 49  & year == `i'), by(state)
		egen fatals_50_59`i'	= count(age) if (age >= 50 & age <= 59  & year == `i'), by(state)
		egen fatals_60plus`i'	= count(age) if (age >= 60			    & year == `i'), by(state)
		
		* Fatalities by sex by year
		egen fatals_male`i' = count(sex)   if (sex == 1 & year == `i'), by(state) // male 
		egen fatals_female`i' = count(sex) if (sex == 2 & year == `i'), by(state) // female
		
		*Fatality for male 20_29 
		egen fatals_male_20_29`i' = count(sex) if (sex == 1 & year == `i' & age >= 20 & age <= 29), by(state)
		

		
		* Total Fatality
		egen fatals_total`i' = count(inj_sev) if (year == `i'),by (state)
		
		* Total fatalities by st_case by year
		egen fatal_`i' = count(inj_sev) if (year == `i'), by(st_case)
		
		* Fatalities by BAC status and pot by year
		gen s_fatals_bac_pos`i' = bac_pos * fatal_`i'
		gen s_fatals_bac_0`i'   = bac_0   * fatal_`i'
		gen s_fatals_bac_10`i'  = bac_10  * fatal_`i'
		gen s_fatals_420`i'      = pot_related * fatal_`i'

	}
	
* Collapse to state data
	collapse (sum) s_fatals* (mean) fatals*, by(state)

	
* Reshape data
	reshape long fatals_15_19 fatals_20_29 fatals_30_39 fatals_40_49 fatals_50_59 fatals_60plus fatals_male fatals_female fatals_total s_fatals_bac_pos s_fatals_bac_0 s_fatals_bac_10 s_fatals_420 fatals_male_20_29 , i(state) j(year)
	sort state
	

save "$directory/ECON 6073/Final_data/person_10_19_state.dta",replace


	

	
	

set more on
