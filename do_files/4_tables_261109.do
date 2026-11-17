/* Project info
   4_tables_261109.do | OECD childcare build-up and winsorization check. */
if ${store_log_tables}==1 {
    capture log close
    capture noisily log using "${log_dir}/4_tables_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* Hold the sample, country and year effects, and trends fixed across all columns.
regress ln_gap ln_spending ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store build1
regress ln_gap ln_spending ln_leaveweeks ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store build2
regress ln_gap ln_spending ln_leaveweeks lag_lngdp ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store build3
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store build4
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store build5

* Country and year effects and country trends apply to every column; the sample is fixed.
etable, estimates(build1 build2 build3 build4 build5) ///
    keep(ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_buildup_261109.docx", replace)

* Winsorize the six continuous model variables on the main estimation sample.
foreach var in ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending {
    quietly summarize `var', detail
    local low = r(p1)
    local high = r(p99)
    generate w_`var' = `var'
    replace w_`var' = `low' if `var'<`low'
    replace w_`var' = `high' if `var'>`high'
}

regress w_ln_gap w_ln_spending w_ln_leaveweeks w_lag_lngdp ///
    w_lag_gdp_growth w_ln_leavespending i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store childcare_winsor
testparm w_ln_spending
* Keep observed spending as primary because winsorization barely changes the estimate.

* Column 1 uses the observed data; column 2 winsorizes every continuous variable at the first and 99th percentiles.
etable, estimates(build5 childcare_winsor) ///
    keep(ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
         w_ln_spending w_ln_leaveweeks w_lag_lngdp w_lag_gdp_growth w_ln_leavespending) ///
    mstat(N) showstars showstarsnote column(dvlabel) ///
    export("${tabledir}/results_childcare_winsor_261109.docx", replace)

if ${store_log_tables}==1 {
    capture log close
}
