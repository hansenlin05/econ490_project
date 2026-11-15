/* Main analysis uses the OECD ILO household employment panel, 2000-2024.
   The dependent variable is male minus female employment in percentage points.
   The key regressor is lagged father-specific paid leave per 10 weeks. */

use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

* Year effects, panel effects and residual diagnostics for the full specification.
xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe
testparm i.year
xttest3
capture noisily xtserial employment_gap lag_fatherweeks10 lag_lngdp ///
    lag_gdp_growth leave_gdp

* Main specification includes country/year effects and corrects for AR(1)
* and heteroskedasticity. Country-clustered TWFE provides a second inference check.
xtpcse employment_gap lag_fatherweeks10 ${controls} i.year i.country_id, het corr(ar1)
estimates store oecd_pcse
test lag_fatherweeks10 = 0

xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe vce(robust)
estimates store oecd_fe
test lag_fatherweeks10 = 0

etable, estimates(oecd_pcse oecd_fe) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(index) ///
    note("OECD ILO sample. Column 1: AR(1) PCSE. Column 2: country-clustered TWFE. Both include country and year effects.") ///
    export("${tabledir}/results_oecd_261109.docx", replace)

* OECD robustness: quadratic and fully winsorized specifications.
display "OECD robustness: quadratic and fully winsorized specifications"
display "Quadratic term, p = " ${quadratic_p}
display "Winsorized week coefficient, p = " ${winsor_p}
display "Winsorization counts (gap, weeks, log GDP, growth, spending): " ///
    ${winsor_changed_gap} " / " ${winsor_changed_leave} " / " ${winsor_changed_gdp} " / " ///
    ${winsor_changed_growth} " / " ${winsor_changed_spend}
etable, estimates(pcse_quad pcse_winsor) ///
    keep(lag_fatherweeks10 c.lag_fatherweeks10#c.lag_fatherweeks10 ///
         lag_fatherweeks10_winsor lag_lngdp lag_lngdp_winsor ///
         lag_gdp_growth lag_gdp_growth_winsor leave_gdp leave_gdp_winsor) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_robust_261109.docx", replace)

* OECD build-up: all columns use the same complete cases.
display "OECD build-up: all columns use the same complete cases"
etable, estimates(build1 build2 build3 oecd_pcse) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(index) ///
    note("Year FE: yes; Country FE: yes in all columns. Main regressor enters first; no non-linear term is added. All four columns use the same 333 observations with complete data on every variable.") ///
    export("${tabledir}/results_buildup_261109.docx", replace)

* Further analysis: geographic subsets of the OECD ILO sample.
display "Further analysis: geographic subsets of the OECD ILO sample"
etable, estimates(all_countries sub_europe sub_noneurope) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(index) ///
    note("Year FE: yes; Country FE: yes. Subsets use the geographic groups defined for this study. The non-European column has 6 groups and 102 observations; report it for the three-column comparison only, not as a policy effect.") ///
    export("${tabledir}/results_subsets_261109.docx", replace)

* Further analysis: European Eurostat panel, DiD and event study.
display "Further analysis: European Eurostat panel, DiD and event study"
etable, estimates(europe_fe pcse did eventstudy) ///
    keep(lag_fatherweeks10 1.treated#1.post ///
         event_time_dummy1 event_time_dummy3 event_time_dummy4 event_time_dummy5 ///
         lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_europe_261109.docx", replace)
