/* Project info
   5_validate_2019_261125.do | check the two 2019 group definitions used in the poster */

use "${datadir_final}/oecd_childcare_261109.dta", clear

* check the panel key
duplicates report iso year

* list countries with employment data and with the full model sample
tabulate iso if !missing(employment_gap)
tabulate iso if childcare_sample == 1

* all 2019 observations with both measures, median in the lower group
keep if year == 2019 & !missing(employment_gap, lag_socx_ecec)
summarize lag_socx_ecec, detail
generate above_all = lag_socx_ecec > r(p50)
summarize employment_gap if above_all == 0
summarize employment_gap if above_all == 1

* complete-case sample, median recalculated within the 2019 subset
list iso if childcare_sample == 0
keep if childcare_sample == 1
sort lag_socx_ecec
list iso lag_socx_ecec in 10/11
summarize lag_socx_ecec, detail
generate above_model = lag_socx_ecec > r(p50)
summarize employment_gap if above_model == 0
summarize employment_gap if above_model == 1
