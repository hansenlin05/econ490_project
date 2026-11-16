capture log close
log using "log_files/3_results_261109.log", text replace

import delimited using "data_final/oecd_childcare_261109.csv", clear
keep if childcare_sample == 1
drop if employment_gap >= . | lag_socx_ecec >= . | lag_fatherweeks10 >= .
drop if lag_lngdp >= . | lag_gdp_growth >= . | leave_gdp >= .
drop if country_id == "" | year >= .
encode country_id, generate(ccode)

generate year_centered = year - 2010
xtset ccode year, yearly

su employment_gap, detail
generate employment_gap_winsor = employment_gap
replace employment_gap_winsor = r(p1) if employment_gap_winsor < r(p1) & employment_gap_winsor != .
replace employment_gap_winsor = r(p99) if employment_gap_winsor > r(p99) & employment_gap_winsor != .

su lag_lngdp, detail
generate lag_lngdp_winsor = lag_lngdp
replace lag_lngdp_winsor = r(p1) if lag_lngdp_winsor < r(p1) & lag_lngdp_winsor != .
replace lag_lngdp_winsor = r(p99) if lag_lngdp_winsor > r(p99) & lag_lngdp_winsor != .

xtpcse employment_gap_winsor lag_socx_ecec lag_fatherweeks10 ///
    lag_lngdp_winsor lag_gdp_growth leave_gdp i.year i.ccode ///
    c.year_centered#i.ccode, het corr(ar1)

capture log close
