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

* winsorize each continuous variable at the 1st and 99th percentile
quietly summarize ln_gender_gap, detail
local low_gap = r(p1)
local high_gap = r(p99)
generate w_ln_gender_gap = ln_gender_gap
replace w_ln_gender_gap = `low_gap' if ln_gender_gap<`low_gap'
replace w_ln_gender_gap = `high_gap' if ln_gender_gap>`high_gap'

quietly summarize ln_childcare_spending, detail
local low_spend = r(p1)
local high_spend = r(p99)
generate w_ln_childcare_spending = ln_childcare_spending
replace w_ln_childcare_spending = `low_spend' if ln_childcare_spending<`low_spend'
replace w_ln_childcare_spending = `high_spend' if ln_childcare_spending>`high_spend'

quietly summarize ln_father_leaveweeks, detail
local low_father = r(p1)
local high_father = r(p99)
generate w_ln_father_leaveweeks = ln_father_leaveweeks
replace w_ln_father_leaveweeks = `low_father' if ln_father_leaveweeks<`low_father'
replace w_ln_father_leaveweeks = `high_father' if ln_father_leaveweeks>`high_father'

quietly summarize ln_mother_leaveweeks, detail
local low_mother = r(p1)
local high_mother = r(p99)
generate w_ln_mother_leaveweeks = ln_mother_leaveweeks
replace w_ln_mother_leaveweeks = `low_mother' if ln_mother_leaveweeks<`low_mother'
replace w_ln_mother_leaveweeks = `high_mother' if ln_mother_leaveweeks>`high_mother'

quietly summarize lag_lngdp, detail
local low_gdp = r(p1)
local high_gdp = r(p99)
generate w_lag_lngdp = lag_lngdp
replace w_lag_lngdp = `low_gdp' if lag_lngdp<`low_gdp'
replace w_lag_lngdp = `high_gdp' if lag_lngdp>`high_gdp'

quietly summarize ln_leave_spending, detail
local low_leavespend = r(p1)
local high_leavespend = r(p99)
generate w_ln_leave_spending = ln_leave_spending
replace w_ln_leave_spending = `low_leavespend' if ln_leave_spending<`low_leavespend'
replace w_ln_leave_spending = `high_leavespend' if ln_leave_spending>`high_leavespend'

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
