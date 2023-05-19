***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************



* Get age, pop, pop by sex from 2010 - 2019
clear all
cd "$directory/ECON 6073/Raw_data/Covariate/POP by state/"
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
	qui: import excel "`x'", cellrange(H6:AK40) clear // Import csv file
	qui: gen state = real(subinstr("`x'", ".xlsx", "", .))	// Generate id variable (same as file name but without .csv)
	g id = _n 
	keep if  (id == 1| id == 35)
	* Append each file to masterfile
	append using `master',force

	save `master', replace
}

preserve
keep if id == 35
save median_age,replace
restore

keep if id == 1
save pop,replace

clear all
cd "$directory/ECON 6073/Raw_data/Covariate/POP by state/"
use pop


rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP2010 M2010 F2010 POP2011 M2011 F2011 POP2012 M2012 F2012 POP2013 M2013 F2013 POP2014 M2014 F2014 POP2015 M2015 F2015 POP2016 M2016 F2016 POP2017 M2017 F2017 POP2018 M2018 F2018 POP2019 M2019 F2019)

save pop,replace

clear all
cd "$directory/ECON 6073/Raw_data/Covariate/POP by state/"
use median_age


rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (A2010 MA2010 FA2010 A2011 MA2011 FA2011 A2012 MA2012 FA2012 A2013 MA2013 FA2013 A2014 MA2014 FA2014 A2015 MA2015 FA2015 A2016 MA2016 FA2016 A2017 MA2017 FA2017 A2018 MA2018 FA2018 A2019 MA2019 FA2019)
save median_age,replace

*Merge data
merge 1:1 state using pop

drop id
drop _merge

*Reshape wide to long
reshape long POP M F A MA FA , i(state) j(year)

rename (POP M F A MA FA) (pop pop_male pop_female age age_male age_female)
sort state
save "$directory/ECON 6073/Final_data/pop_median_age.dta",replace




