***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

set more off
clear all 
cd "$directory/ECON 6073/Final_data"
* Add number of licensed drivers, Vehicle miles, Income covariates.

import excel "$directory/ECON 6073/Raw_data/Covariate/Licensed Drivers.xls", sheet("Licensed Driver") firstrow

* Reshape data from wide to long

	drop if state > 56
	drop POP*
	reshape long DL VM IN , i(state) j(year)
* Merge data
	merge 1:m state year using pop_median_age,keep(3) nogen
	merge 1:m state year using pop_by_age_group,keep(3) nogen
	merge 1:m state year using unemployed_by_state, keep(3) nogen
	merge m:1 state using beer_tax_state, keep(3) nogen


* Gen MML 
* MML = 1 if legalized before 2010

gen MML = inlist(state,2,6,8,15,23,26,30,32,35,41,44,50,53)


replace MML = (1/12) if (state == 4 & year == 2010) //Arizona 11/29/2010
replace MML = 1 	if (state == 4 & year  > 2010) //Arizona 11/29/2010

replace MML = (1/6) if (state == 5 & year == 2016) //Arkansas 11/9/2016
replace MML = 1 	if (state == 5 & year  > 2016) //Arkansas 11/9/2016

replace MML = (3/12) if (state == 9 & year == 2012) //Connecticut 10/1/2012
replace MML = 1 if (state == 9 & year > 2012 ) 	  //Connecticut 10/1/2012

replace MML = 1/2 if (state == 10 & year == 2011) // Delaware 7/1/2011
replace MML = 1 if (state == 10 & year > 2011)
 
replace MML = 5/12 if (state == 11 & year == 2010 ) //DC 7/27/2010
replace MML = 1 if (state == 11 & year > 2010)

replace MML = 1 if (state == 12 & year >= 2017) //FL 1/3/2017

replace MML = 1 if (state == 17 & year >= 2014 ) //IL 1/1/2014

replace MML = 7/12 if (state == 22 & year == 2016 ) // LA 5/19/2016


replace MML = 7/12 if (state == 24  & year == 2014 ) //MD 6/1/2014
replace MML = 1 if (state == 24 & year > 2014  ) 

replace MML = 1 if (state == 25 & year >= 2013) // MA 1/1/2013

replace MML = 7/12 if (state == 27 & year == 2014 )  // MN 5/30/2014
replace MML = 1 if (state == 27 & year > 2014 ) 

replace MML = 1/12 if (state == 29  & year == 2018 ) //MO 12/6/2018

replace MML = 1 if (state == 29 & year > 2018 ) 

replace MML = 5/12 if (state == 33 & year == 2013 ) //NH 7/23/2013
replace MML = 1 if (state == 33 & year > 2013 ) 

replace MML = 7/12 if (state == 34 & year == 2010  ) //NJ 6/1/2010
replace MML = 1 if (state == 34 & year > 2010 ) 

replace MML = 6/12 if (state == 36 & year ==2014) // NY 7/5/2014
replace MML = 1 if (state == 36 & year > 2014 ) 

replace MML = 1/12 if (state == 38 & year == 2016) // ND 12/8/2016
replace MML = 1 if (state == 38 & year > 2016)

replace MML = 4/12 if (state == 39 & year == 2016) //OH 39 9/8/2016
replace MML = 1 if (state == 39 & year > 2016)
 
replace MML = 5/12 if (state == 40 & year > 2018) // OK 40 7/26/2018
replace MML = 1 if (state ==40 & year > 2018)

replace MML = 7/12 if (state == 42 & year == 2016) // PA 42 5/17/2016
replace MML = 1 if (state == 42 & year > 2016)
		
replace MML = 1/12 if (state == 49 & year == 2018) // UT 49 12/3/2018
replace MML = 1 if (state == 49 & year > 2018)

replace MML = 6/12 if (state == 54 & year == 2019) // WV 54 7/1/2019

*Gen RML 
gen RML = 0

replace RML = 10/12 if (state == 2 & year == 2015) // AK 2 2/24/2015
replace RML = 1 if (state == 2 & year > 2015 )

replace RML = 2/12 if (state == 6 & year == 2016 ) // CA 6 11/9/2016
replace RML = 1 if (state == 6 & year > 2016 )

replace RML = 1/12 if (state == 8 & year == 2012) // CO 8 12/10/2012
replace RML = 1 if (state == 8 & year >2012)

replace RML = 10/12 if (state == 11 & year == 2015 ) // DC 11 2/26/2015
replace RML = 1 if (state == 11 & year > 2015 )

replace RML = 11/12 if (state == 23 & year == 2017) // ME 23 1/30/2017
replace RML = 1 if (state == 23 & year > 2017)

replace RML = 1/12 if (state == 25 & year == 2016 ) //MA 25 12/15/2016
replace RML = 1 if (state == 25 & year > 2016 )

replace RML = 1/12 if (state == 26 & year == 2018 ) // MI 26 12/6/2018
replace RML = 1 if (state == 26 & year >2018 )

replace RML = 1 if (state == 32 & year >= 2017) // NV 32 1/1/2017


replace RML = 1/2 if (state == 50 & year == 2018 ) // VT 50 7/1/2018
replace RML = 1 if (state == 50 & year > 2018 )

replace RML = 1/12 if (state == 53 & year == 2012) // WA 12/6/2012
replace RML = 1 if (state == 53 & year > 2012)

* Gen MMD
gen MMD = inlist(state,6,8,26,30,35,49)

replace MMD = 2/12 if (state == 2 & year == 2016) // AK 2 10/29/2016
replace MMD = 1 if (state == 2 & year > 2016)

replace MMD = 1/12 if (state == 4 & year == 2012) // AZ 4 12/6/2012
replace MMD = 1    if (state == 4 & year > 2012)

replace MMD = 8/12 if (state == 5 & year == 2019) // AR 5 5/11/2012

replace MMD = 3/12 if (state == 9 & year == 2014) // CT 9 9/22/2014
replace MMD = 1 	if (state == 9 & year > 2014)

replace MMD = 6/12 if (state == 10 & year == 2015) // DE 10 6/26/2015
replace MMD = 1 if (state == 10 & year > 2015)

replace MMD = 5/12 if (state == 11 & year == 2013) // DC 11 7/29/2013
replace MMD = 1 if (state == 11 & year > 2013)

replace MMD = 1/12 if (state == 12 & year == 2018) // FL 12 12/19/2018
replace MMD = 1 if (state == 12 & year > 2018)

replace MMD = 5/12 if (state == 15 & year == 2015) // HI 15 8/8/2017
replace MMD = 1    if (state == 15 & year > 2015)

replace MMD = 5/12 if (state == 22 & year == 2019) // LA 22 8/6/2019

replace MMD = 9/12 if (state == 23 & year == 2011) // ME 23 4/1/2011
replace MMD = 1 if (state == 23 & year > 2011)

replace MMD = 1/12 if (state == 24 & year == 2017) // MD 24 12/1/2017
replace MMD = 1 if (state == 24 & year > 2017)

replace MMD = 7/12 if (state == 25 & year == 2015) // MA 25 6/4/2015
replace MMD = 1 if (state == 25 & year > 2015)

replace MMD = 6/12 if (state == 27 & year == 2015) // MN 27 7/1/2015
replace MMD = 1 if (state == 27 & year > 2015)

replace MMD = 5/12 if (state == 32 & year == 2015) // NV 32 7/31/2015
replace MMD = 1 if (state == 32 & year > 2015)

replace MMD = 8/12 if (state == 33 & year == 2016) // NH 33 4/30/2016
replace MMD = 1 if (state == 33 & year > 2016)

replace MMD = 6/12 if (state == 36 & year == 2016) // NY 36 1/7/2016
replace MMD = 1 if (state == 36 & year > 2016)

replace MMD = 10/12 if (state == 38 & year == 2019) // ND 38 3/1/2019

replace MMD = 11/12 if (state == 39 & year == 2019) // OH 39 1/16/2019

replace MMD = 2/12 if (state == 40 & year == 2018) // OK 40 10/26/2018
replace MMD = 1 if (state == 40 & year > 2018)

replace MMD = 11/12 if (state == 42 & year == 2018) // PA 42 1/17/2018
replace MMD = 1 if (state == 42 & year > 2018)

replace MMD = 8/12 if (state == 44 & year == 2013) // RI 44 4/19/2013
replace MMD = 1 if (state == 44 & year > 2013)

replace MMD = 7/12 if (state == 50 & year == 2013) // VT 50 6/1/2013
replace MMD = 1 if (state == 50 & year > 2013)

* Gen RMD

gen RMD = 0

replace RMD = 2/12 if (state == 2 & year == 2016) // AK 2 10/29/2016
replace RMD = 1 if (state == 2 & year > 2016)

replace RMD = 1 if (state == 6 & year >= 2018) // CA 6 1/1/2018

replace RMD = 1 if (state == 8 & year == 2014) // CO 8 1/1/2014

replace RMD = 1/12 if (state ==25 & year == 2018) // MA 25 11/20/2018
replace RMD = 1 if (state == 25 & year > 2018)

replace RMD = 1/12 if (state == 26 & year == 2019 ) // MI 26 12/1/2019

replace RMD = 6/12 if (state == 32 & year == 2017) // NV 32 7/1/2017
replace RMD = 1 if (state == 32& year > 2017)

replace RMD = 6/12 if (state == 53 & year == 2014) // WA 53 7/8/2014
replace RMD = 1 if (state == 53 & year > 2014) 

* Primary, Secondary Seat Belt Law
	gen secondary_seat_belt = (inlist(state,4,8,32,29,51,16,30,56,46,31,38,39,42,25,50))
	gen primary_seat_belt = (secondary_seat_belt == 0 & state != 33 )
	
	
	replace primary_seat_belt = 1/2 if (state == 54 & year == 2013 ) // WV 54 07/01/2013
	replace primary_seat_belt = 1 if (state == 54 & year > 2013 ) // WV 54 07/01/2013
	replace primary_seat_belt = 0 if (state == 54 & year < 2013 ) // WV 54 07/01/2013
	
	replace primary_seat_belt = 7/12 if (state == 20 & year == 2010 ) // KS 20 06/10/2010
	replace primary_seat_belt = 1 if (state == 20 & year > 2010 ) // KS 20 06/10/2010



* Gen hand-held bans
	
	
	gen hand_held_ban = inlist(state,6,36,41,49,9,53,34,11) // CA, NY, OR, UT, MD,CT, WA, DC
	
	replace hand_held_ban = 3/12 if (state == 24 & year == 2010) // MD 10/1/2010
	replace hand_held_ban = 1 if (state == 24 & year > 2010)
	
	replace hand_held_ban = 1 if (state == 10 & year >= 2011 ) // DE 10 1/2/2011
	
	replace hand_held_ban = 1/2 if (state == 15 & year == 2013)	// HI 15 7/1/2013
	replace hand_held_ban = 1 if (state == 15 & year > 2013)
	
	replace hand_held_ban = 1 if (state == 17 & year >= 2014 )  // IL 1/1/2014
	
	replace hand_held_ban = 1 if (state == 32 & year >= 2012) // NV 32 1/1/2012
	
	replace hand_held_ban = 1/2 if (state == 33 & year == 2015) // NH 33 7/1/2015
	replace hand_held_ban = 1 if (state == 33 & year > 2015)
	
	replace hand_held_ban = 3/12 if (state == 50 & year == 2014 ) // VT 50 10/1/2014
	replace hand_held_ban = 1 if (state == 50 & year > 2014)
	
	replace hand_held_ban = 1/2 if (state == 13 & year == 2018 ) //GA 13 7/1/2018
	replace hand_held_ban = 1 if (state == 13 & year >2018)
	
	replace hand_held_ban = 3/12 if (state == 23 & year == 2019) // ME 23 9/19/2019
	
	replace hand_held_ban = 5/12 if (state == 27 & year == 2019) // MN 27 8/1/2019
	
	replace hand_held_ban = 7/12 if (state == 44 & year == 2018) // RI 44 6/1/2018
	replace hand_held_ban = 1 if (state == 44 & year > 2018)
	
	replace hand_held_ban = 6/12 if (state == 47 & year == 2019) // TN 47 7/1/2019
	
* Gen texting bans( can't take fractional values since no data available )
	gen texting_ban = hand_held_ban
	replace texting_ban = 1 if inlist(state,5,19,21,22,25,26,31,33,37,44,47,50,51,55,56) // ,AK, IO, KY, LA, MA, MI, NH, NC, NE, RI, TN,  VT, VA, WI WY
	
	replace texting_ban = 1 if (state == 1  & year >= 2012 ) // AL 2012
	replace texting_ban = 1 if (state == 2  & year >= 2012 ) // AK 2012
	replace texting_ban = 1 if (state == 12 & year >= 2013 ) // FL 2013
	replace texting_ban = 1 if (state == 16 & year >= 2012 ) // ID 2012
	replace texting_ban = 1 if (state == 18 & year >= 2011 ) // IN 2011
	replace texting_ban = 1 if (state == 20 & year >= 2011 ) // KS 2011
	replace texting_ban = 1 if (state == 23 & year >= 2011 ) // ME 2011
	replace texting_ban = 1 if (state == 28 & year >= 2015 ) // MS 2015
	replace texting_ban = 1 if (state == 35 & year >= 2014 ) // NM 2014
	replace texting_ban = 1 if (state == 38 & year >= 2011 ) // ND 2011
	replace texting_ban = 1 if (state == 39 & year >= 2012 ) // OH 2012 
	replace texting_ban = 1 if (state == 40 & year >= 2015 ) // OK 2015
	replace texting_ban = 1 if (state == 42 & year >= 2012 ) // PA 2012
	replace texting_ban = 1 if (state == 45 & year >= 2014 ) // SC 2014
	replace texting_ban = 1 if (state == 46 & year >= 2014 ) // SD 2014

* Gen Speed 70-Speed limit over 70 
	gen speed_70 = 1 
	replace speed_70 = 0 if inlist(state,10,9,2,15,25,50,36,33,34,44 ) // DE, RI, MA, VT, NY, HI, CT, NJ, NH, AK

* Gen Drug Per Se Law. illegal if marijuana,drug exceed the limit
	gen per_se_law = 0					// IL , OH, NV, CO, MT, WA
	replace per_se_law = 1 if (state == 53 & year >= 2013) // WA 2013
	replace per_se_law = 1 if (state == 8  & year >= 2013) // CO 2013
	replace per_se_law = 1 if (state == 30 & year >= 2013) // MT 2013
	replace per_se_law = 1 if (state == 39 & year >= 2006) // OH 2006
	replace per_se_law = 1 if (state == 32 & year >= 2003) // NV 2003
	replace per_se_law = 1 if (state == 17 & year >= 1997) // IL 1997
	
* Gen Zero- Tolerance Law . illegal if any THC,drug found. 
	gen zero_tolerance = inlist(state,4,10,13,18,19,21,26,27,37,42,44,49,55,46 ) // 13 states: AZ, DE, GA, IN ,IO, KY, MI, MN, NC, PA, RI , UT, WI ,SD* 
	
	replace zero_tolerance = 1 if (state == 40 & year >= 2014 ) // OK 2014
	
* GDL all introduced before 2010

* ALR law:
	gen ALR = 1 
	replace ALR = 0 if inlist(state,21,26,30,34,42,44,45,46,47) //9 states—Kentucky, Michigan, Montana, New Jersey, Pennsylvania, Rhode Island, South Carolina, South Dakota, and Tennessee no ALR
	
* 0.08 BAC law.
	gen bac_08 = 1
	replace bac_08 = 0 if state == 49 // UT 49 BAC 0.05 Law

* Decriminalized
	gen decriminalized = (inlist(state,2,6,8,23,25,27,28,31,32,36,37,39,41)) // AK,CA,CO,ME,MA,MN,MS,NE,NV,NY,NC,OH,OR
	
	replace decriminalized = 1/12 if (state == 10 & year == 2015 ) // DE  12/2015
	replace decriminalized = 1 if (state == 10 & year > 2015)
	
	replace decriminalized = 3/12 if (state == 24 & year == 2014 ) // MD 10/1/2014
	replace decriminalized = 1 if (state == 24 & year > 2014)
	
	replace decriminalized = 1 if (state == 29 & year >= 2014) // MO 2014
	
	replace decriminalized = 5/12 if (state == 33 & year == 2017) // NH 7/18/2017
	replace decriminalized = 1 if (state ==3 & year > 2017)
	
	replace decriminalized = 1/2 if (state == 38 & year >= 2019) // ND 5/2019
	
	replace decriminalized = 9/12 if (state == 44 & year == 2013) // RI  4/1/2013
	replace decriminalized = 1 if (state == 44 & year > 2013)

* Gen Vehicle miles driven per licensed driver (thousands of miles)
	gen VM_per_driver = VM * 1000000 / (1000*DL)
	label var VM_per_driver "Miles Driven"
* Save left hand side data
	
	save "$directory/ECON 6073/Final_data/X_cov.dta",replace



set more on

