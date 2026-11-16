/* Project info
   3_results_261109.do | primary OECD childcare expenditure regressions. */

if ${store_log_mainresults}==1 {
    capture log close
    capture noisily log using "${log_dir}/3_results_261109.log", text replace
}

* OECD. 2026. Social Expenditure Database, public early childhood education
* and care spending as a share of GDP (TP521). https://doi.org/10.1787/data-00167-en
* Official annual series retrieved 15 November 2026.
* Build the one-year spending lag before attaching employment data.
import delimited using "${datadir_raw}/oecd_socx_ecec_gdp.csv", clear varnames(1)
keep if unit_measure=="PT_B1GQ" & expend_source=="ES10" & programme_type=="TP521"
rename ref_area iso
rename time_period year
keep iso year obs_value
encode iso, generate(spending_id)
xtset spending_id year, yearly
sort spending_id year
generate lag_socx_ecec = L1.obs_value
keep iso year lag_socx_ecec
isid iso year
tempfile spending
save `spending'

use "${datadir_final}/oecd_analysis_261109.dta", clear
merge 1:1 iso year using `spending'
keep if _merge==3
drop _merge

* Compare both specifications on the same complete cases.
keep if !missing(employment_gap, lag_socx_ecec, lag_fatherweeks10)
keep if !missing(lag_lngdp, lag_gdp_growth, leave_gdp)
label variable lag_socx_ecec "Prior-year public childcare and early education spending (% of GDP)"
xtset country_id year, yearly

* Check the year effects, heteroskedasticity, and serial correlation.
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year#i.country_id, fe
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
    i.year c.year#i.country_id, fe vce(robust)
estimates store childcare_twfe
test lag_socx_ecec = 0

* Compare inference using PCSE with first-order serial correlation.
xtpcse employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id c.year#i.country_id, het corr(ar1)
estimates store childcare_pcse
test lag_socx_ecec = 0

etable, estimates(childcare_twfe childcare_pcse childcare_no_trends) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(index) ///
    note("Country and year fixed effects in all columns. Columns 1 and 2 include country-specific linear trends. Columns 1 and 3 use country-clustered standard errors. Column 2 uses PCSE with AR(1).") ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

if ${store_log_mainresults}==1 {
    capture log close
}
