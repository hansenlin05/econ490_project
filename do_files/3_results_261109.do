/* Project info
   3_results_261109.do | the main OECD childcare expenditure regressions */

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* check year effects, heteroskedasticity and serial correlation
xtreg ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
xtserial ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending

* PCSE inference with first-order serial correlation
xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_pcse
testparm ln_childcare_spending

* a version without the country trends, but with both fixed effects
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id, het corr(ar1)
estimates store childcare_no_trends
testparm ln_childcare_spending

* level version kept as a comparison column on the same sample
quietly xtpcse employment_gap lag_socx_ecec lag_fatherweeks10 lag_motherweeks10 lag_lngdp leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_level
testparm lag_socx_ecec

etable, estimates(childcare_pcse childcare_no_trends childcare_level) ///
    keep(ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
         lag_socx_ecec lag_fatherweeks10 lag_motherweeks10 leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

* check for curvature on the same sample
quietly xtpcse ln_gender_gap c.ln_childcare_spending##c.ln_childcare_spending ///
    ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
testparm c.ln_childcare_spending#c.ln_childcare_spending
