/* Project info
   3_results_261109.do | the main OECD childcare expenditure regressions */

if ${store_log_mainresults}==1 {
    capture log close
    capture noisily log using "${log_dir}/3_results_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* check year effects, heteroskedasticity and serial correlation
xtreg ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
capture noisily xtserial ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending

* main elasticities, standard errors clustered by country
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store childcare_twfe
testparm ln_spending
* country effects tested off the LSDV version
testparm i.country_id

* same thing with plain robust standard errors
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, robust
estimates store childcare_robust
testparm ln_spending

* PCSE inference with first-order serial correlation
xtpcse ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_pcse
testparm ln_spending

* a version without the country trends, but with both fixed effects
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id, vce(cluster country_id)
estimates store childcare_no_trends
testparm ln_spending

* level version kept as a comparison column on the same sample
regress employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
estimates store childcare_level
testparm lag_socx_ecec

etable, estimates(childcare_twfe childcare_robust childcare_pcse childcare_no_trends childcare_level) ///
    keep(ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
         lag_socx_ecec lag_fatherweeks10 leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

* check for curvature on the same sample
regress ln_gap c.ln_spending##c.ln_spending ///
    ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, vce(cluster country_id)
testparm c.ln_spending#c.ln_spending

if ${store_log_mainresults}==1 {
    capture log close
}
