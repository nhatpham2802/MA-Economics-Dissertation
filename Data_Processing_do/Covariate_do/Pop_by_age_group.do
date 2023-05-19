***********************
*** Nhat Hoang Pham ***
***    UC Denver    ***
***********************

* Pop by age group 

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
	keep if id == 1 | inrange(id,5,19) | id == 35 // 1 - total 5,15-19 67,20-29 89,30-39 1011,40-49, 1213,50-59 14-19,60+
	* Append each file to masterfile
	append using `master',force
	save `master', replace
}

* Keep useful data
	preserve
	keep if id == 5 
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP152010 M152010 F152010 POP152011 M152011 F152011 POP152012 M152012 F152012 POP152013 M152013 F152013 POP152014 M152014 F152014 POP152015 M152015 F152015 POP152016 M152016 F152016 POP152017 M152017 F152017 POP152018 M152018 F152018 POP152019 M152019 F152019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_15_19,replace
	restore

* 20-29
	preserve
	keep if id == 6|id == 7
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP202010 M202010 F202010 POP202011 M202011 F202011 POP202012 M202012 F202012 POP202013 M202013 F202013 POP202014 M202014 F202014 POP202015 M202015 F202015 POP202016 M202016 F202016 POP202017 M202017 F202017 POP202018 M202018 F202018 POP202019 M202019 F202019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_20_29,replace
	restore

* 30-39
	preserve
	keep if id == 8| id == 9
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP302010 M302010 F302010 POP302011 M302011 F302011 POP302012 M302012 F302012 POP302013 M302013 F302013 POP302014 M302014 F302014 POP302015 M302015 F302015 POP302016 M302016 F302016 POP302017 M302017 F302017 POP302018 M302018 F302018 POP302019 M302019 F302019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_30_39,replace
	restore
	
* 40-49
	preserve
	keep if id == 10| id == 11
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP402010 M402010 F402010 POP402011 M402011 F402011 POP402012 M402012 F402012 POP402013 M402013 F402013 POP402014 M402014 F402014 POP402015 M402015 F402015 POP402016 M402016 F402016 POP402017 M402017 F402017 POP402018 M402018 F402018 POP402019 M402019 F402019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_40_49,replace
	restore
	
* 50-59
	preserve
	keep if id == 12| id == 13
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP502010 M502010 F502010 POP502011 M502011 F502011 POP502012 M502012 F502012 POP502013 M502013 F502013 POP502014 M502014 F502014 POP502015 M502015 F502015 POP502016 M502016 F502016 POP502017 M502017 F502017 POP502018 M502018 F502018 POP502019 M502019 F502019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_50_59,replace
	restore	
	
* 60 plus	
	preserve
	keep if inrange(id,14,19)
	rename (H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK) (POP602010 M602010 F602010 POP602011 M602011 F602011 POP602012 M602012 F602012 POP602013 M602013 F602013 POP602014 M602014 F602014 POP602015 M602015 F602015 POP602016 M602016 F602016 POP602017 M602017 F602017 POP602018 M602018 F602018 POP602019 M602019 F602019)
	collapse (sum) POP* (sum) M* (sum)F*, by(state)
	save pop_60_plus,replace
	restore
	
* Merge all
	clear all
	use pop_15_19
	merge 1:1 state using pop_20_29, keep(3) nogen
	merge 1:1 state using pop_30_39, keep(3) nogen
	merge 1:1 state using pop_40_49, keep(3) nogen
	merge 1:1 state using pop_50_59, keep(3) nogen
	merge 1:1 state using pop_60_plus, keep(3) nogen
	
* Reshape and rename the data
	reshape long POP15 M15 F15 POP20 M20 F20 POP30 M30 F30 POP40 M40 F40 POP50 M50 F50 POP60 M60 F60  , i(state) j(year)
	rename (POP15 M15 F15 POP20 M20 F20 POP30 M30 F30 POP40 M40 F40 POP50 M50 F50 POP60 M60 F60) (pop_15_19 pop_male_15_19 pop_female_15_19 pop_20_29 pop_male_20_29 pop_female_20_29 pop_30_39 pop_male_30_39 pop_female_30_39 pop_40_49 pop_male_40_49 pop_female_40_49 pop_50_59 pop_male_50_59 pop_female_50_59 pop_60_plus pop_male_60_plus pop_female_60_plus )

save "$directory/ECON 6073/Final_data/pop_by_age_group.dta",replace

	
	
	
	
	