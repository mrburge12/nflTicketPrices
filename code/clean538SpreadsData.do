********************************************************************************
** Preliminaries
********************************************************************************

clear
cls
br

cd "C:\Users\g1mxb12\Desktop\nflTicketPrices\data\538Data\rawData\spreads"

********************************************************************************
** Import Data
********************************************************************************

import excel "538_week17_2018-12-27.xlsx", sh("games") clear
drop E

*save "../../cleanData/masterSpreads.dta", replace

**************
** Clean Data
**************
*Mark the date the data was pulled. This will help to compare output over time
g pull_date = "2018-12-27"

*Clean up vars
destring(C D), force replace
rename (A B C D) (game_time team elo_point_spread win_prob)

*Track which teams are playing at home
g hometeam = "Y" if team[_n-1] ~= "" & team[_n] ~= ""
replace hometeam = "N" if hometeam ~= "Y" & team ~= ""

*Mark which week of the season the data was pulled
g week_no = game_time
replace week_no = "" if strpos(game_time, "Week") == 0
replace week_no = subinstr(week_no, "Week", "", .)
replace week_no = week_no[_n-1] if week_no == ""
destring(week_no), force replace

*Make a variable for the date of the event
g game_date = game_time
replace game_date = "" if strpos(game_date,"day") == 0
replace game_date = game_date[_n-1] if game_date == ""

*Make a variable for the time of the game
replace game_time = "" if strpos(game_time,".m.") == 0 
g game_time2 = game_time[_n-1]
drop game_time
rename game_time2 game_time
order game_time
replace game_time = game_time[_n-1] if game_time == "" & team ~= ""
replace game_time =subinstr(game_time, "Eastern", "", .)
replace game_time =subinstr(game_time, " ", "", .)

*Drop unnecessary vars
drop if team == ""

*Create a variable that keeps teams and their opponents together. That is, for ///
*The first week, Atlanta and Philadelphia are both matched to 1, because they ///
*play each other
g game_id = .
replace game_id = 1 if hometeam == "Y"
replace game_id = game_id[_n-2]+1 if game_id[_n-2] ~= .
replace game_id = game_id[_n+1] if game_id == .

***************************
** Order, append, and save
***************************
order pull_date game_id week_no game_date game_time team elo_point_spread win_prob hometeam
append using "../../cleanData/masterSpreads.dta", force
duplicates drop
*drop A B C D
save "../../cleanData/masterSpreads.dta", replace


export excel "../../cleanData/masterSpreads.xlsx", first(var) replace



