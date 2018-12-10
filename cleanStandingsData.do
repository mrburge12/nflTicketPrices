********************************************************************************
** Preliminaries
********************************************************************************

clear
cls
br


********************************************************************************
** Import Data
********************************************************************************

import excel "rawData/standings.xlsx", first sh("week14") clear
g week_no = 14
g pull_date = "2018-12-06"
drop B win_division
g record = ""
replace record = substr(team, -4,4)
replace team = subinstr(team,"-", "",.)
replace record = "" if strpos(record, "-") == 0

*Remove letters from record variable
local vlist a b c d e f g h i j k l m n o p q r s t u v w x y z
foreach value of local vlist {
replace record = subinstr(record, "`value'", "", .)
replace record = subinstr(record, "-", "",1) if strpos(record, "-") == 1
}

*Remove numbers from team names
forvalues n = 0/9{
replace team = subinstr(team, "`n'", "",.)
}

*save "cleanData/standingsMaster.dta", replace

append using "cleanData/standingsMaster.dta", force
duplicates drop

order week_no pull_date team elo_rating
gsort +week_no -elo_rating
save "cleanData/standingsMaster.dta", replace
export excel "cleanData/standings/standingsMaster.xlsx", first(var) replace
