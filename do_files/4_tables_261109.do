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
xtreg employment_gap lag_socx_ecec ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store build1
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store build2
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store build3
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store build4
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store build5

etable, estimates(build1 build2 build3 build4 build5) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(index) ///
    note("Country FE: yes. Year FE: yes. Country trends: yes. These apply to every column. The sample and country-clustered standard errors are used throughout.") ///
    export("${tabledir}/results_childcare_buildup_261109.docx", replace)

* Winsorize the six continuous model variables on the main estimation sample.
foreach var in employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp {
    summarize `var', detail
    local low = r(p1)
    local high = r(p99)
    generate w_`var' = `var'
    recast double w_`var'
    replace w_`var' = `var'
    replace w_`var' = `low' if `var'<`low'
    replace w_`var' = `high' if `var'>`high'
}

xtreg w_employment_gap w_lag_socx_ecec w_lag_fatherweeks10 w_lag_lngdp ///
    w_lag_gdp_growth w_leave_gdp i.year c.year_centered#i.country_id, fe vce(robust)
estimates store childcare_winsor
test w_lag_socx_ecec = 0
* Keep observed spending as primary because winsorization barely changes the estimate.

etable, estimates(build5 childcare_winsor) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
         w_lag_socx_ecec w_lag_fatherweeks10 w_lag_lngdp w_lag_gdp_growth w_leave_gdp) ///
    mstat(N) showstars showstarsnote column(index) ///
    note("Column 1 uses the observed data. Column 2 winsorizes every continuous variable at the first and 99th percentiles.") ///
    export("${tabledir}/results_childcare_winsor_261109.docx", replace)

if ${store_log_tables}==1 {
    capture log close
}
