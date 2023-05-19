***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

**** Master file: RUN DO FILE ****

clear all

* Change directory if needed(This is for MAC-OS)
global directory "/Users/nhatpham/Desktop/Study/Fall 2021"

* For Window user, must fix all directories in each separate do files. 


* Data processing

** Indenpendent data: 

	* Run acc_10_19_raw do file to obtain accident fatalities data (.dta)
	do "$directory/ECON 6073/Data_processing_do/FARS_do/acc_10_19_raw"
	
	* Run person_10_19_raw do file to obtain person data (.dta)
	do "$directory/ECON 6073/Data_processing_do/FARS_do/person_10_19_raw"
	
	* Run person_10_19 do file to clean and process person data, and produce person_10_19.dta  
	do "$directory/ECON 6073/Data_processing_do/FARS_do/person_10_19"
	
	* Run acc_10_19 do file to clean and process accident data amd merge with person_10_19.dta to get final FARS_10_19 dta
	do "$directory/ECON 6073/Data_processing_do/FARS_do/acc_10_19"

** Dependent data
	* Run unemployed_by_state do file to get unemployment data
	do "$directory/ECON 6073/Data_processing_do/Covariate_do/unemployed_by_state"

	* Run pop_median_age do file to get population and age data
	do "$directory/ECON 6073/Data_processing_do/Covariate_do/pop_median_age"

	* Run beer_tax_state do file to get beer tax
	do "$directory/ECON 6073/Data_processing_do/Covariate_do/beer_tax_state"

	* Run pop_by_age_group do file to get population per age group
	do "$directory/ECON 6073/Data_processing_do/Covariate_do/pop_by_age_group"
	
	* Run Xst do file to obtain MML,RML,licensed drivers, vehicle miles, income variable, add all other policies
	do "$directory/ECON 6073/Data_processing_do/Covariate_do/Xst"
	
	* Run final_processing file to obtain master data file (ready for analysis)
	do "$directory/ECON 6073/Data_processing_do/final_processing"

* ANALYSIS
	* Run main analysis-table to produce table
	do "$directory/ECON 6073/Analysis_do/Main Analysis-Tables"

	* Run main analysis-event study to produce event study figure
	do "$directory/ECON 6073/Analysis_do/Main Analysis-Event Studies"

	* Run counterfactual estimator do file for robustness check(counterfactual estimator, leave-one-out analysis)
	do "$directory/ECON 6073/Analysis_do/Counterfactual estimator"

	
	
	