
**Generating time discontinuity for Table 1**
*Presidential elections
gen pt = .
replace pt = 1 if year == 2016
replace pt = 0 if year == 2012

*Midterm elections
gen mt = .
replace mt = 1 if year == 2018
replace mt = 0 if year == 2010

*Constitutional elections
gen ct = .
replace ct = 1 if year == 2017
replace ct = 0 if year == 2009


**Table 1**
*Presidential total
xtreg turnout pt##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)

*Midterm total
xtreg turnout mt##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)

*Constitutional total
xtreg turnout ct##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)


*Generating time discontinuity for Table 2**
gen c3 = .
replace c3 = 1 if year == 2011
replace c3 = 0 if year == 2009

gen c4 = .
replace c4 = 1 if year == 2017
replace c4 = 0 if year == 2011

gen c1 = .
replace c1 = 1 if year == 2017
replace c1 = 0 if year == 2015


**Table 2**
*Constitutional 2009-2011
xtreg turnout c3##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)
 
*Constitutional 2011-2017
xtreg turnout c4##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)

*Constitutional 2015-2017
xtreg turnout c1##votecenter medianinc_rec bachelor_higher totalpop_rec , fe vce(cluster County)


**For Online Appendix**

*Parallel Assumption Graph

use "...\Paralle Assumption.dta", clear

twoway (line control year) (line treat year), ytitle(Turnout) ///
xscale(range(2009 2018))  xlabel(2009(2)2018) legend(region(lcolor(none))) ///
by(Election) subtitle(, nobox)

*Propensity Score Matching
*Constitutional 

psmatch2 votecenter medianinc_rec totalpop_rec bachelor_higher  if Election == 1

psgraph

pstest  medianinc_rec totalpop_rec bachelor_higher  , both 

gen weights_const=_weight 

replace weights_const=0 if weights_const==.

replace weights_const=1 if votecenter==1


*Midterm
psmatch2 votecenter medianinc_rec totalpop_rec bachelor_higher  if Election == 2

psgraph

pstest  medianinc_rec totalpop_rec bachelor_higher  , both 

gen weights_mt=_weight 

replace weights_mt=0 if weights_mt==.

replace weights_mt=1 if votecenter==1


*Presidential
psmatch2 votecenter medianinc_rec totalpop_rec bachelor_higher if Election == 3

psgraph

pstest  medianinc_rec totalpop_rec bachelor_higher  , both 

gen weights_p=_weight 

replace weights_p=0 if weights_p==.

replace weights_p=1 if votecenter==1


**Table 3**

*Presidential
reg turnout pt##votecenter medianinc_rec bachelor_higher totalpop_rec  [pw= weights_p ]

*Midterm
reg turnout mt##votecenter medianinc_rec bachelor_higher totalpop_rec  [pw= weights_mt ]

*Constitutional
reg turnout ct##votecenter medianinc_rec bachelor_higher totalpop_rec  [pw=weights_const]
