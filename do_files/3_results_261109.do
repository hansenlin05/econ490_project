/* Project info
   3_results_261109.do | primary OECD childcare expenditure regressions. */

if ${store_log_mainresults}==1 {
    capture log close
    capture noisily log using "${log_dir}/3_results_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* Check the year effects, heteroskedasticity, and serial correlation.
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
capture noisily xtserial employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp

* Compare with a model that uses country and year effects without separate trends.
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year, fe vce(robust)
estimates store childcare_no_trends
test lag_socx_ecec = 0

* Estimate the primary association using country-clustered standard errors.
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store childcare_twfe
test lag_socx_ecec = 0

* Compare inference using PCSE with first-order serial correlation.
xtpcse employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_pcse
test lag_socx_ecec = 0

etable, estimates(childcare_twfe childcare_pcse childcare_no_trends) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(index) ///
    note("Country and year fixed effects in all columns. Columns 1 and 2 include country-specific linear trends. Columns 1 and 3 use country-clustered standard errors. Column 2 uses PCSE with AR(1).") ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

* Check curvature in the spending association on the same sample.
xtreg employment_gap c.lag_socx_ecec##c.lag_socx_ecec ///
    lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year_centered#i.country_id, fe vce(robust)
test c.lag_socx_ecec#c.lag_socx_ecec = 0

if ${store_log_mainresults}==1 {
    capture log close
}
