clear
capture log close
log using "oecd_childcare_live_results.log", text replace

wbopendata, indicator(NY.GDP.PCAP.KD) long clear
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

import excel using "https://webfs.oecd.org/els-com/Family_Database/PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx", sheet("Time-Series") cellrange(A9) clear
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

import delimited using "https://sdmx.oecd.org/public/rest/data/OECD.ELS.SPD,DSD_SOCX_AGG@DF_SOCX_AGG,1.0/.A..PT_B1GQ.ES10..TP512+TP521.?format=csvfile&startPeriod=1999&endPeriod=2024", clear
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

import delimited using "https://rplumber.ilo.org/data/indicator/?id=GED_PEPR_SEX_HHT_CHL_RT_A", clear
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
regress ln_gap ln_childcare ln_fatherweeks10 lag_lngdp ln_leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, robust

capture log close
