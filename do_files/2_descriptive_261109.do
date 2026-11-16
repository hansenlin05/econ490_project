/* Project info
   2_descriptive_261109.do | OECD childcare descriptives, figures, and subset regressions. */
if ${store_log_descriptive}==1 {
    capture log close
    capture noisily log using "${log_dir}/2_descriptive_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear

* Describe all model variables in 2019 for observations with childcare spending.
preserve
    keep if year==2019 & !missing(lag_socx_ecec)
    dtable employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp, ///
        continuous(employment_gap lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp, ///
        statistic(n mean sd min max)) ///
        title("OECD childcare model: descriptive statistics for 2019") ///
        export("${tabledir}/descriptive_2019_oecd_childcare_261109.docx", replace)
restore

keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly
tabulate eu_childcare

* Illustrate the relationship between spending and employment in the estimation sample.
twoway (scatter employment_gap lag_socx_ecec) (lfit employment_gap lag_socx_ecec), ///
    title("Public childcare spending and the employment gap") ///
    xtitle("Prior-year public ECEC spending (% of GDP)") ///
    ytitle("Male minus female employment rate (pp)") ///
    legend(label(1 "Country-year observation") label(2 "Linear fit")) ///
    graphregion(color(white))
graph export "${figdir}/scatter_gap_childcare_261109.png", as(png) replace

* Compare spending across the regional groups used in the subset regressions.
twoway (histogram lag_socx_ecec if eu_childcare==1, color(navy%40) lcolor(navy) start(0) width(.2)) ///
    (histogram lag_socx_ecec if eu_childcare==0, color(maroon%40) lcolor(maroon) start(0) width(.2)), ///
    title("Public childcare spending by subgroup") ///
    xtitle("Prior-year public ECEC spending (% of GDP)") ///
    ytitle("Density") ///
    legend(label(1 "EU-target group") label(2 "Other OECD")) graphregion(color(white))
graph export "${figdir}/histogram_childcare_byregion_261109.png", as(png) replace

* Compare the same specification across both groups and the full sample.
* The EU's Barcelona targets linked ECEC access to parental employment.
* https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year c.year_centered#i.country_id, fe vce(robust)
estimates store childcare_all
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year c.year_centered#i.country_id if eu_childcare==1, fe vce(robust)
estimates store childcare_eu
xtreg employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year c.year_centered#i.country_id if eu_childcare==0, fe vce(robust)
estimates store childcare_other

etable, estimates(childcare_all childcare_eu childcare_other) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(index) ///
    note("Columns: all countries, EU-target group, other OECD. Country FE: yes. Year FE: yes. Country trends: yes. Country-clustered standard errors.") ///
    export("${tabledir}/results_childcare_subsets_261109.docx", replace)

if ${store_log_descriptive}==1 {
    capture log close
}
