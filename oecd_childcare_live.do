clear
capture log close
log using "oecd_childcare_live_results.log", text replace

use "wdi_gdp_raw.dta", clear
rename (countrycode countryname) (iso country)
keep if inrange(year,1999,2024)

preserve
    keep iso country
    bysort iso: keep if _n == 1
    replace country = "Korea" if iso == "KOR"
    replace country = "Türkiye" if iso == "TUR"
    save "oecd_country_codes.dta", replace
restore

encode iso, generate(gdp_id)
xtset gdp_id year, yearly
generate lngdp = ln(ny_gdp_pcap_kd)
generate lag_lngdp = L1.lngdp
keep iso year lag_lngdp
save "oecd_gdp.dta", replace

import excel using "oecd_leave_history.xlsx", sheet("Time-Series") cellrange(A9) clear
rename (A B T) (country year total_paid_raw)
keep country year total_paid_raw
keep if inrange(year,2000,2024)
merge m:1 country using "oecd_country_codes.dta"
keep if _merge == 3
drop _merge

generate fatherweeks = real(total_paid_raw)
replace fatherweeks = 28.6 if total_paid_raw == "28.6 / 54.6"
replace fatherweeks = 30.17 if total_paid_raw == "30.17 / 56.17"

encode iso, generate(leave_id)
xtset leave_id year, yearly
generate fatherweeks10 = fatherweeks / 10
generate lag_fatherweeks10 = L1.fatherweeks10
keep iso year lag_fatherweeks10
save "oecd_father_leave.dta", replace

import delimited using "oecd_socx_spending.csv", clear
rename (ref_area time_period) (iso year)
keep iso year programme_type obs_value
reshape wide obs_value, i(iso year) j(programme_type) string
rename obs_valueTP512 leave_gdp
rename obs_valueTP521 ecec_gdp
encode iso, generate(spending_id)
xtset spending_id year, yearly
generate childcare = L1.ecec_gdp
keep iso year childcare leave_gdp
save "oecd_spending.dta", replace

import delimited using "ilostat_employment.csv", clear
rename (ref_area time) (iso year)
keep if classif1=="HHT_AGGREGATE_K" & classif2=="CHL_AGET6_YES"
keep if inlist(sex,"SEX_M","SEX_F") & inrange(year,2000,2024)
bysort iso year: egen flagged = max(obs_status!="")
keep if flagged == 0
keep iso year sex obs_value
reshape wide obs_value, i(iso year) j(sex) string
rename (obs_valueSEX_M obs_valueSEX_F) (male_rate female_rate)
generate employment_gap = male_rate - female_rate

merge 1:1 iso year using "oecd_father_leave.dta"
keep if _merge == 3
drop _merge
merge 1:1 iso year using "oecd_gdp.dta"
keep if _merge == 3
drop _merge
merge 1:1 iso year using "oecd_spending.dta"
keep if _merge == 3
drop _merge
drop if missing(employment_gap, childcare, lag_fatherweeks10, lag_lngdp, leave_gdp)

generate ln_gap = ln(employment_gap)
generate ln_childcare = ln(1 + childcare)
generate ln_fatherweeks10 = ln(1 + lag_fatherweeks10)
generate ln_leave_gdp = ln(leave_gdp)

encode iso, generate(country_id)
generate year_centered = year - 2010
tsset country_id year

xtreg ln_gap ln_childcare ln_fatherweeks10 lag_lngdp ln_leave_gdp ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
capture noisily xtserial ln_gap ln_childcare ln_fatherweeks10 lag_lngdp ln_leave_gdp

quietly su ln_gap, detail
generate ln_gap_winsor = ln_gap
replace ln_gap_winsor = r(p1) if ln_gap_winsor < r(p1) & ln_gap_winsor != .
replace ln_gap_winsor = r(p99) if ln_gap_winsor > r(p99) & ln_gap_winsor != .

quietly su lag_lngdp, detail
generate lag_lngdp_winsor = lag_lngdp
replace lag_lngdp_winsor = r(p1) if lag_lngdp_winsor < r(p1) & lag_lngdp_winsor != .
replace lag_lngdp_winsor = r(p99) if lag_lngdp_winsor > r(p99) & lag_lngdp_winsor != .

quietly su ln_childcare, detail
generate ln_childcare_winsor = ln_childcare
replace ln_childcare_winsor = r(p1) if ln_childcare_winsor < r(p1) & ln_childcare_winsor != .
replace ln_childcare_winsor = r(p99) if ln_childcare_winsor > r(p99) & ln_childcare_winsor != .

quietly su ln_fatherweeks10, detail
generate ln_fatherweeks10_winsor = ln_fatherweeks10
replace ln_fatherweeks10_winsor = r(p1) if ln_fatherweeks10_winsor < r(p1) & ln_fatherweeks10_winsor != .
replace ln_fatherweeks10_winsor = r(p99) if ln_fatherweeks10_winsor > r(p99) & ln_fatherweeks10_winsor != .

quietly su ln_leave_gdp, detail
generate ln_leave_gdp_winsor = ln_leave_gdp
replace ln_leave_gdp_winsor = r(p1) if ln_leave_gdp_winsor < r(p1) & ln_leave_gdp_winsor != .
replace ln_leave_gdp_winsor = r(p99) if ln_leave_gdp_winsor > r(p99) & ln_leave_gdp_winsor != .

xtpcse ln_gap_winsor ln_childcare_winsor ln_fatherweeks10_winsor ///
    lag_lngdp_winsor ln_leave_gdp_winsor i.year i.country_id ///
    c.year_centered#i.country_id, het corr(ar1)

capture log close
