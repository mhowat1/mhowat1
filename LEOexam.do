*1.Getting the dataset- 1a and 1c

**first I imported the data and cleaned it by getting rid of the title sequences, renaming the variables, and coding the Fedfunds rates and PCE as numeric rather than strings for further data manipulation*
import excel "/Users/meghanleehowat/Documents/FEDFUNDS.xls"
drop in 1/11
rename A date 
gen FFR= real(B)
drop B
save FFR, replace
clear

import excel "/Users/meghanleehowat/Documents/PCE.xls"
drop in 1/11
rename A date
gen PCE= real(B)
drop B
save PCE, replace
clear

*1b- merging the datasets 
use "FFR.dta"
merge 1:1 date using "PCE.dta"
*1d: summary statistics
tabstat FFR PCE, c(stat) stat(mean sd n)

*I did this again without the 31 unmatched observations*
drop if _merge==2
drop _merge
tabstat FFR PCE, c(stat) stat(mean sd n)
*and kept them in the dataset as new observations*
foreach v in FFR PCE { 
    egen mean_`v' = mean(`v')
	egen sd_`v' = sd(`v')
}

*Next, I changed the date format to numeric and extracted the year and month*
gen date1= date(date, "DMY")
gen year=year(date1)
gen month=month(date1)
*generate sum of PCE by year (1e)
egen PCE_AN= sum(PCE), by(year)
*(1f)*
save consumpt.dta, replace 

*2. Regressions using consumpt.dta

*clean data set to include only relevant observations and label observations (id) in order*
clear
use consumpt.dta
drop if year<1960 | year>2019
sort month
sort year, stable 
gen monthid= _n 
gen PCEn_1 = PCE[monthid-1]
gen FFRn_1 = FFR[monthid-1]
save consumptreg.dta, replace

reg PCE PCEn_1 FFRn_1, robust 
est store reg1
esttab reg1, b(3) se(3) nomtitles ar2 alignment(center) fragment tex 

*3. Generating predicted values 
*Put the first 2 quarters of 2020 back in the dataset for prediction and graphing purposes
clear
use consumpt.dta
drop if year<1960 | year>=2021
drop if year==2020 & month==7 | month==10
sort month
sort year, stable 
gen monthid= _n 
gen PCEn_1 = PCE[monthid-1]
gen FFRn_1 = FFR[monthid-1]
save 2020, replace 

reg PCE PCEn_1 FFRn_1, robust
predict PCEnew
twoway line PCE PCEnew monthid, sort  ///
ytitle("Personal Consumption Expenditures") ///
xtitle("Quarters after Q1, 1960") 
graph export "/Users/meghanleehowat/Documents/PCEfitted.pdf", as(pdf) name("Graph") replace

*All results (summary statistics, regression table, and graph) in Latex document








