*import 4 data sets from excel and name for convenient use 
cd C:\Users\bdame\OneDrive\Documents\Red_Sox
forvalues i=2009/2012 {
	import excel using "C:\Users\bdame\OneDrive\Documents\Red_Sox\red_sox_`i'"
gen year=`i'
save RS_`i', replace
clear
}

*combine data sets into one dta file
use RS_2009
append using RS_2010 RS_2011 RS_2012
save RS_allyears, replace 

rename price_per_ticket price
rename days_from_transaction_until_game days
rename team opposingteam

save RS_allyears, replace 

collapse(mean) price, by(sectiontype)
sort price
save price_sectiontype, replace 
clear

use RS_allyears
egen section=group(sectiontype)
egen month=group(gamemonth)
egen team=group(opposingteam)
save RS_allyears, replace

reg price days, robust 
est store reg1
reg price days day_game weekend_game, robust
est store reg2   
reg price days day_game weekend_game i.year, robust
est store reg3 
reg price days day_game weekend_game i.year i.section, robust
est store reg4
reg price days day_game weekend_game i.year i.section i.month, robust
est store reg5
reg price days day_game weekend_game i.year i.section i.month i.team, robust
est store reg6 

esttab reg1 reg2 reg3 reg4 reg5 reg6, b(3) se(3) nomtitles ar2 drop(2009.year 2010.year 2011.year 2012.year 1.month 2.month 3.month 4.month 5.month 6.month 7.month 1.team 2.team 3.team 4.team 5.team 6.team 7.team 8.team 9.team 10.team 11.team 12.team 13.team 14.team 15.team 16.team 17.team 18.team 19.team 20.team 21.team 22.team 23.team 24.team 1.section 2.section 3.section 4.section 5.section 6.section 7.section 8.section 9.section 10.section 11.section 12.section 13.section 14.section 15.section 16.section 17.section 18.section 19.section 20.section 21.section _cons) alignment(center) fragment tex 

reg price days day_game weekend_game i.days i.year i.section i.month i.team, robust
margins i.days if days<=100
marginsplot

clear 
use RS_allyears

reg logprice days, robust 
est store reg1
reg logprice days day_game weekend_game, robust
est store reg2   
reg logprice days day_game weekend_game i.year, robust
est store reg3 
reg logprice days day_game weekend_game i.year i.section, robust
est store reg4
reg logprice days day_game weekend_game i.year i.section i.month, robust
est store reg5
reg logprice days day_game weekend_game i.year i.section i.month i.team, robust
est store reg6 
	
esttab reg1 reg2 reg3 reg4 reg5 reg6, b(3) se(3) nomtitles ar2 drop(2009.year 2010.year 2011.year 2012.year 1.month 2.month 3.month 4.month 5.month 6.month 7.month 1.team 2.team 3.team 4.team 5.team 6.team 7.team 8.team 9.team 10.team 11.team 12.team 13.team 14.team 15.team 16.team 17.team 18.team 19.team 20.team 21.team 22.team 23.team 24.team 1.section 2.section 3.section 4.section 5.section 6.section 7.section 8.section 9.section 10.section 11.section 12.section 13.section 14.section 15.section 16.section 17.section 18.section 19.section 20.section 21.section _cons) alignment(center) fragment tex 

reg price days day_game weekend_game i.days i.year i.section i.month i.team, robust
margins i.days if days<=100
marginsplot
graph save Margins1

reg price days c.days#i.year, robust 
est store reg1
reg price days c.days#i.year day_game weekend_game, robust
est store reg2   
reg price days c.days#i.year day_game weekend_game i.year, robust
est store reg3 
reg price days c.days#i.year day_game weekend_game i.year i.section, robust
est store reg4
reg price days c.days#i.year day_game weekend_game i.year i.section i.month, robust
est store reg5
reg price days c.days#i.year day_game weekend_game i.year i.section i.month i.team, robust
est store reg6 

esttab reg1 reg2 reg3 reg4 reg5 reg6, b(3) se(3) nomtitles ar2 drop(2009.year 2010.year 2011.year 2012.year 1.month 2.month 3.month 4.month 5.month 6.month 7.month 1.team 2.team 3.team 4.team 5.team 6.team 7.team 8.team 9.team 10.team 11.team 12.team 13.team 14.team 15.team 16.team 17.team 18.team 19.team 20.team 21.team 22.team 23.team 24.team 1.section 2.section 3.section 4.section 5.section 6.section 7.section 8.section 9.section 10.section 11.section 12.section 13.section 14.section 15.section 16.section 17.section 18.section 19.section 20.section 21.section _cons) fragment alignment(center) tex 











