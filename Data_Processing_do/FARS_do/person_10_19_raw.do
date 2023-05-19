***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************
set more off
/* Create person raw FARS_data for 10-19 */

clear all

* For loop to have useful data in FARS_data
	
	cd "$directory/ECON 6073/Raw_data/FARS data/FARS_10_19/Person_10_19"
* Import person data 2010-2019
	local filepath = "`c(pwd)'" // Save path to current folder in a local
	di "`c(pwd)'" // Display path to current folder

	local files : dir "`filepath'" files "*.CSV" // Save name of all files in folder ending with .csv in a local
	di `"`files'"' // Display list of files to import data from

	tempfile master // Generate temporary save file to store data in
	save `master', replace empty


	foreach x of local files {
		di "`x'" // Display file name

		* Import each file
		qui: import delimited "`x'", clear // Import csv file
		qui: gen id   = subinstr("`x'", ".CSV", "", .)	// Generate id variable (same as file name but without .csv)
		
		* Append each file to masterfile
	
		append using `master',force

		save `master', replace
	}

save "$directory/ECON 6073/Final_data/person_10_19_raw.dta", replace	




set more on


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	




