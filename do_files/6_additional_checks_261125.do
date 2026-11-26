/* Project info
   6_additional_checks_261125.do | supplemental regressions and the adjusted scatter */

* build next-year spending on the full series before the sample restriction
import delimited "${datadir_raw}/oecd_socx_ecec_gdp.csv", clear varnames(1)
keep if unit_measure=="PT_B1GQ" & expend_source=="ES10" & programme_type=="TP521"
rename ref_area iso
rename time_period year
encode iso, generate(spending_id)
xtset spending_id year, yearly
sort spending_id year
generate lead_spending = ln(1 + F1.obs_value)
label variable lead_spending "Next-year public ECEC spending, log of one plus percent of GDP"
keep iso year lead_spending
sort iso year
save "${datadir_final}/tmp_lead_spending.dta", replace

* estimation sample with next-year spending attached
use "${datadir_final}/oecd_childcare_261109.dta", clear
merge 1:1 iso year using "${datadir_final}/tmp_lead_spending.dta"
drop if _merge==2
drop _merge
keep if childcare_sample==1
generate year_centered = year - 2010
sort country_id year
xtset country_id year, yearly

local controls ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id

* separate regressions for the gap, mothers and fathers
generate ln_mothers = ln(female_rate)
generate ln_fathers = ln(male_rate)
label variable ln_gender_gap "Log of the male minus female employment gap"
label variable ln_mothers "Log of mothers' employment rate"
label variable ln_fathers "Log of fathers' employment rate"
quietly xtpcse ln_gender_gap ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_gap
quietly xtpcse ln_mothers ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_mothers
quietly xtpcse ln_fathers ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_fathers
etable, estimates(outcome_gap outcome_mothers outcome_fathers) ///
    keep(ln_childcare_spending) mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_gender_outcomes_261125.docx", replace)

* placebo comparison on the country-years with next-year spending
quietly xtpcse ln_gender_gap ln_childcare_spending `controls' if !missing(lead_spending), het corr(ar1)
estimates store placebo_base
quietly xtpcse ln_gender_gap ln_childcare_spending lead_spending `controls' if !missing(lead_spending), het corr(ar1)
estimates store placebo_joint
etable, estimates(placebo_base placebo_joint) ///
    keep(ln_childcare_spending lead_spending) mstat(N) showstars showstarsnote varlabel ///
    export("${tabledir}/results_placebo_261125.docx", replace)

* re-estimate after dropping each country in turn
levelsof iso, local(countries)
foreach country of local countries {
    quietly xtpcse ln_gender_gap ln_childcare_spending `controls' if iso!="`country'", het corr(ar1)
    estimates store omit_`country'
}
etable, estimates(omit_AUT omit_BEL omit_CAN omit_CHL omit_COL omit_CZE omit_DEU omit_ESP omit_EST omit_FRA omit_GBR omit_GRC omit_HUN omit_IRL omit_ITA omit_LTU omit_LUX omit_LVA omit_NLD omit_POL omit_PRT omit_SVN omit_TUR) ///
    keep(ln_childcare_spending) mstat(N) showstars showstarsnote ///
    export("${tabledir}/results_leave_one_out_261125.docx", replace)

* residualize the scatter axes on the same controls and effects
regress ln_childcare_spending `controls'
predict spend_hat, xb
generate adjusted_spending = ln_childcare_spending - spend_hat
regress ln_gender_gap `controls'
predict gap_hat, xb
generate adjusted_gap = ln_gender_gap - gap_hat
quietly regress adjusted_gap adjusted_spending
estimates store scatter_fit
etable, estimates(scatter_fit) keep(adjusted_spending) mstat(N) showstars showstarsnote ///
    export("${tabledir}/results_adjusted_scatter_261125.docx", replace)
twoway (scatter adjusted_gap adjusted_spending, color(teal)) ///
    (lfit adjusted_gap adjusted_spending, lcolor(navy)), ///
    title("Adjusted spending and the employment gap") ///
    xtitle("Adjusted log childcare spending") ytitle("Adjusted log gap") ///
    legend(label(1 "Adjusted spending") label(2 "Fitted line"))
graph export "${figdir}/scatter_adjusted_261125.png", as(png) replace
graph export "${figdir}/scatter_adjusted_261125.svg", as(svg) replace
