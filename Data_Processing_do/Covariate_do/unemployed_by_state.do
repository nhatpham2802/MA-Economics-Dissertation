***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

set more off
clear all 
* Unemployment rate





cd "$directory/ECON 6073/Raw_data/Covariate/UE/"
* Import person data 2010-2019
local filepath = "`c(pwd)'" // Save path to current folder in a local
di "`c(pwd)'" // Display path to current folder

local files : dir "`filepath'" files "*.xlsx" // Save name of all files in folder ending with .csv in a local
di `"`files'"' // Display list of files to import data from

tempfile master // Generate temporary save file to store data in
save `master', replace empty


foreach x of local files {
    di "`x'" // Display file name

	* Import each file
	qui: import excel "`x'", cellrange(A11:H131) firstrow case(lower) clear // Import csv file
	qui: gen state = real(subinstr("`x'", ".xlsx", "", .))	// Generate id variable (same as file name but without .csv)
	keep state year unemploymentrate 
	collapse (mean) unemploymentrate state , by(year)
	
	* Append each file to masterfile
	append using `master',force

	save `master', replace
}
rename unemploymentrate unemployed
sort state year
format  unemployed %9.2f

save "$directory/ECON 6073/Final_data/unemployed_by_state.dta",replace

set more on


