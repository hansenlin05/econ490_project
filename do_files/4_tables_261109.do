/* Project info
   4_tables_261109.do | the build-up table and the winsorizing check */

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* hold the sample and all effects fixed across the columns
quietly xtpcse ln_gender_gap ln_childcare_spending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build1
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build2
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build3
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build4
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build5

* country, year and trend effects in every column, same sample throughout
etable, estimates(build1 build2 build3 build4 build5) ///
    keep(ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_buildup_261109.docx", replace)

* winsorize the 6 continuous variables on the main sample
foreach var in ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending {
    quietly summarize `var', detail
    local low = r(p1)
    local high = r(p99)
    generate w_`var' = `var'
    replace w_`var' = `low' if `var'<`low'
    replace w_`var' = `high' if `var'>`high'
}

* give the winsorized variables readable labels for the exported table
label variable w_ln_gender_gap "Log of the male minus female employment gap"
label variable w_ln_childcare_spending "Log of one plus prior-year ECEC spending (% of GDP)"
label variable w_ln_father_leaveweeks "Log of one plus lagged father leave (per 10 weeks)"
label variable w_ln_mother_leaveweeks "Log of one plus lagged mother-side paid leave (per 10 weeks)"
label variable w_lag_lngdp "Lagged log real GDP per capita"
label variable w_ln_leave_spending "Log of public leave spending (% of GDP)"

quietly xtpcse w_ln_gender_gap w_ln_childcare_spending w_ln_father_leaveweeks w_ln_mother_leaveweeks w_lag_lngdp ///
    w_ln_leave_spending i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_winsor
testparm w_ln_childcare_spending
* keep the observed spending as the preferred spec, winsorizing changes little

* column 1 uses the raw numbers, column 2 winsorizes each continuous variable at 1 and 99
etable, estimates(build5 childcare_winsor) ///
    keep(ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
         w_ln_childcare_spending w_ln_father_leaveweeks w_ln_mother_leaveweeks w_lag_lngdp w_ln_leave_spending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_winsor_261109.docx", replace)
