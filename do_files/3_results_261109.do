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
xtreg ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
capture noisily xtserial ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending

* Compare with a model that uses country and year effects without separate trends.
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year, robust
estimates store childcare_no_trends
testparm ln_spending

* Estimate the primary elasticities with heteroskedasticity-robust standard errors.
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, robust
estimates store childcare_twfe
testparm ln_spending
* Test the country effects with the model in LSDV form.
testparm i.country_id

* Compare inference using PCSE with first-order serial correlation.
xtpcse ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_pcse
testparm ln_spending

* Keep the level specification as a comparison column on the same sample.
regress employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, robust
estimates store childcare_level
testparm lag_socx_ecec

etable, estimates(childcare_twfe childcare_pcse childcare_no_trends childcare_level) ///
    keep(ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
         lag_socx_ecec lag_fatherweeks10 leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

* Check curvature in the spending association on the same sample.
regress ln_gap c.ln_spending##c.ln_spending ///
    ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, robust
testparm c.ln_spending#c.ln_spending

if ${store_log_mainresults}==1 {
    capture log close
}
