/* Project info
   2_descriptive_261109.do | OECD childcare descriptives, figures, and subset regressions. */
if ${store_log_descriptive}==1 {
    capture log close
    capture noisily log using "${log_dir}/2_descriptive_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear

* Mean, sd, min, max and N for every model variable in 2019.
preserve
    keep if year==2019 & !missing(lag_socx_ecec)
    collapse ///
        (mean) mean_gap=employment_gap (sd) sd_gap=employment_gap ///
        (min) min_gap=employment_gap (max) max_gap=employment_gap ///
        (count) n_gap=employment_gap ///
        (mean) mean_spend=lag_socx_ecec (sd) sd_spend=lag_socx_ecec ///
        (min) min_spend=lag_socx_ecec (max) max_spend=lag_socx_ecec ///
        (count) n_spend=lag_socx_ecec ///
        (mean) mean_leave=lag_fatherweeks10 (sd) sd_leave=lag_fatherweeks10 ///
        (min) min_leave=lag_fatherweeks10 (max) max_leave=lag_fatherweeks10 ///
        (count) n_leave=lag_fatherweeks10 ///
        (mean) mean_lngdp=lag_lngdp (sd) sd_lngdp=lag_lngdp ///
        (min) min_lngdp=lag_lngdp (max) max_lngdp=lag_lngdp ///
        (count) n_lngdp=lag_lngdp ///
        (mean) mean_growth=lag_gdp_growth (sd) sd_growth=lag_gdp_growth ///
        (min) min_growth=lag_gdp_growth (max) max_growth=lag_gdp_growth ///
        (count) n_growth=lag_gdp_growth ///
        (mean) mean_mleave=leave_gdp (sd) sd_mleave=leave_gdp ///
        (min) min_mleave=leave_gdp (max) max_mleave=leave_gdp ///
        (count) n_mleave=leave_gdp
    list
    export excel using "${tabledir}/descriptive_2019_oecd_childcare_261109.xlsx", replace
    export delimited using "${tabledir}/descriptive_2019_oecd_childcare_261109.csv", replace
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
twoway (histogram lag_socx_ecec if eu_childcare==1, color(navy) lcolor(black)) ///
    (histogram lag_socx_ecec if eu_childcare==0, color(maroon) lcolor(black)), ///
    title("Public childcare spending by subgroup") ///
    xtitle("Prior-year public ECEC spending (% of GDP)") ///
    ytitle("Density") ///
    legend(label(1 "EU-target group") label(2 "Other OECD")) graphregion(color(white))
graph export "${figdir}/histogram_childcare_byregion_261109.png", as(png) replace

* Compare the same specification across both groups and the full sample.
* The EU's Barcelona targets linked ECEC access to parental employment.
* https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)
regress employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year i.country_id c.year_centered#i.country_id, robust
estimates store childcare_all
regress employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==1, robust
estimates store childcare_eu
regress employment_gap lag_socx_ecec lag_fatherweeks10 ${controls} ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==0, robust
estimates store childcare_other

* Columns: all countries, EU-target group, other OECD. Country, year and trend effects apply to every column.
etable, estimates(childcare_all childcare_eu childcare_other) ///
    keep(lag_socx_ecec lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_subsets_261109.docx", replace)

if ${store_log_descriptive}==1 {
    capture log close
}
