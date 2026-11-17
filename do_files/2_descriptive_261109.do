/* Project info
   2_descriptive_261109.do | OECD childcare descriptives, figures, and subset regressions. */
if ${store_log_descriptive}==1 {
    capture log close
    capture noisily log using "${log_dir}/2_descriptive_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear

* Mean, sd, min, max and N for every model variable in 2019.
preserve
    keep if year==2019 & !missing(ln_spending)
    collapse ///
        (mean) mean_gap=ln_gap (sd) sd_gap=ln_gap ///
        (min) min_gap=ln_gap (max) max_gap=ln_gap ///
        (count) n_gap=ln_gap ///
        (mean) mean_spend=ln_spending (sd) sd_spend=ln_spending ///
        (min) min_spend=ln_spending (max) max_spend=ln_spending ///
        (count) n_spend=ln_spending ///
        (mean) mean_leave=ln_leaveweeks (sd) sd_leave=ln_leaveweeks ///
        (min) min_leave=ln_leaveweeks (max) max_leave=ln_leaveweeks ///
        (count) n_leave=ln_leaveweeks ///
        (mean) mean_lngdp=lag_lngdp (sd) sd_lngdp=lag_lngdp ///
        (min) min_lngdp=lag_lngdp (max) max_lngdp=lag_lngdp ///
        (count) n_lngdp=lag_lngdp ///
        (mean) mean_growth=lag_gdp_growth (sd) sd_growth=lag_gdp_growth ///
        (min) min_growth=lag_gdp_growth (max) max_growth=lag_gdp_growth ///
        (count) n_growth=lag_gdp_growth ///
        (mean) mean_mleave=ln_leavespending (sd) sd_mleave=ln_leavespending ///
        (min) min_mleave=ln_leavespending (max) max_mleave=ln_leavespending ///
        (count) n_mleave=ln_leavespending
    list
    export excel using "${tabledir}/descriptive_2019_oecd_childcare_261109.xlsx", replace
    export delimited using "${tabledir}/descriptive_2019_oecd_childcare_261109.csv", replace
restore

keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly
tabulate eu_childcare

* Illustrate the elasticity relationship between spending and the employment gap.
twoway (scatter ln_gap ln_spending) (lfit ln_gap ln_spending), ///
    title("Public childcare spending and the employment gap") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Log of the male minus female employment rate") ///
    legend(label(1 "Country-year observation") label(2 "Linear fit")) ///
    graphregion(color(white))
graph export "${figdir}/scatter_gap_childcare_261109.png", as(png) replace

* Compare logged spending across the regional groups used in the subset regressions.
twoway (histogram ln_spending if eu_childcare==1, color(navy) lcolor(black)) ///
    (histogram ln_spending if eu_childcare==0, color(maroon) lcolor(black)), ///
    title("Public childcare spending by subgroup") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Density") ///
    legend(label(1 "EU-target group") label(2 "Other OECD")) graphregion(color(white))
graph export "${figdir}/histogram_childcare_byregion_261109.png", as(png) replace

* Compare the same specification across both groups and the full sample.
* The EU's Barcelona targets linked ECEC access to parental employment.
* https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, robust
estimates store childcare_all
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==1, robust
estimates store childcare_eu
regress ln_gap ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==0, robust
estimates store childcare_other

* Columns: all countries, EU-target group, other OECD. Country, year and trend effects apply to every column.
etable, estimates(childcare_all childcare_eu childcare_other) ///
    keep(ln_spending ln_leaveweeks lag_lngdp lag_gdp_growth ln_leavespending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_subsets_261109.docx", replace)

if ${store_log_descriptive}==1 {
    capture log close
}
