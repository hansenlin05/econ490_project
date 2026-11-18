/* Project info
   2_descriptive_261109.do | descriptives, figures and the subset runs */
use "${datadir_final}/oecd_childcare_261109.dta", clear

* mean, sd, min, max and N for every model variable, 2019 only
preserve
    keep if year==2019 & !missing(ln_childcare_spending)
    collapse ///
        (mean) mean_gap=ln_gender_gap (sd) sd_gap=ln_gender_gap ///
        (min) min_gap=ln_gender_gap (max) max_gap=ln_gender_gap ///
        (count) n_gap=ln_gender_gap ///
        (mean) mean_spend=ln_childcare_spending (sd) sd_spend=ln_childcare_spending ///
        (min) min_spend=ln_childcare_spending (max) max_spend=ln_childcare_spending ///
        (count) n_spend=ln_childcare_spending ///
        (mean) mean_leave=ln_father_leaveweeks (sd) sd_leave=ln_father_leaveweeks ///
        (min) min_leave=ln_father_leaveweeks (max) max_leave=ln_father_leaveweeks ///
        (count) n_leave=ln_father_leaveweeks ///
        (mean) mean_lngdp=lag_lngdp (sd) sd_lngdp=lag_lngdp ///
        (min) min_lngdp=lag_lngdp (max) max_lngdp=lag_lngdp ///
        (count) n_lngdp=lag_lngdp ///
        (mean) mean_mleave=ln_leave_spending (sd) sd_mleave=ln_leave_spending ///
        (min) min_mleave=ln_leave_spending (max) max_mleave=ln_leave_spending ///
        (count) n_mleave=ln_leave_spending ///
        (mean) mean_mother=ln_mother_leaveweeks (sd) sd_mother=ln_mother_leaveweeks ///
        (min) min_mother=ln_mother_leaveweeks (max) max_mother=ln_mother_leaveweeks ///
        (count) n_mother=ln_mother_leaveweeks
    list
    export excel using "${tabledir}/descriptive_2019_oecd_childcare_261109.xlsx", replace
    export delimited using "${tabledir}/descriptive_2019_oecd_childcare_261109.csv", replace
restore

keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly
tabulate eu_childcare

* scatter of spending against the gap
twoway (scatter ln_gender_gap ln_childcare_spending) (lfit ln_gender_gap ln_childcare_spending), ///
    title("Public childcare spending and the employment gap") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Log of the male minus female employment rate") ///
    legend(label(1 "Country-year observation") label(2 "Linear fit")) ///
    graphregion(color(white))
graph export "${figdir}/scatter_gap_childcare_261109.png", as(png) replace

* logged spending by the two groups used in the subsets
twoway (histogram ln_childcare_spending if eu_childcare==1, color(navy) lcolor(black)) ///
    (histogram ln_childcare_spending if eu_childcare==0, color(maroon) lcolor(black)), ///
    title("Public childcare spending by subgroup") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Density") ///
    legend(label(1 "EU-target group") label(2 "Other OECD")) graphregion(color(white))
graph export "${figdir}/histogram_childcare_byregion_261109.png", as(png) replace

* same specification in each group and in the full sample
* the EU Barcelona targets tied childcare access to parental work
* https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_all
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==1, het corr(ar1)
estimates store childcare_eu
quietly xtpcse ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==0, het corr(ar1)
estimates store childcare_other

* columns, all countries, EU group, other OECD, with country, year and trend effects in each
etable, estimates(childcare_all childcare_eu childcare_other) ///
    keep(ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_subsets_261109.docx", replace)
