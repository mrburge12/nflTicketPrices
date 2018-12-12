********************************************************************************
** Preliminaries
********************************************************************************

clear
cls
br

cd "C:\Users\g1mxb12\Desktop\nflTicketPrices\data\seatgeek\cleanData\eventData\"
********************************************************************************
** Import Data
********************************************************************************

import delimited "sg_2018-09-05_08.12.46.csv", clear
save "master.dta"

local filelist : dir . files "sg_*"

foreach file of local filelist {
	import delimited "`file'", clear
	append using "master.dta", force
	save "master.dta", replace
}

drop v1
save "master.dta", replace
