/* Project info
   2_descriptive_261109.do | descriptive statistics and figures for the primary Europe sample. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_descriptive}==1 {
    cap log close
    capture noisily log using "${log_dir}/2_descriptive_261109.log", text replace
}

* Load the saved file if the build step was skipped
if ${run_build}==0 {
    use "${datadir_final}/europe_analysis_261109.dta", clear
}

summarize year

* Univariate statistics
summarize employment_gap male_rate female_rate fatherweeks10 ///
    lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp
summarize employment_gap, detail
return list
summarize lag_lngdp, detail
return list

* Mean, sd, min, max and N for all variables
preserve
    collapse ///
        (mean) mean_gap=employment_gap (sd) sd_gap=employment_gap ///
        (min) min_gap=employment_gap (max) max_gap=employment_gap ///
        (count) n_gap=employment_gap ///
        (mean) mean_leave10=lag_fatherweeks10 (sd) sd_leave10=lag_fatherweeks10 ///
        (min) min_leave10=lag_fatherweeks10 (max) max_leave10=lag_fatherweeks10 ///
        (count) n_leave10=lag_fatherweeks10 ///
        (mean) mean_lngdp=lag_lngdp (sd) sd_lngdp=lag_lngdp ///
        (min) min_lngdp=lag_lngdp (max) max_lngdp=lag_lngdp ///
        (count) n_lngdp=lag_lngdp ///
        (mean) mean_growth=lag_gdp_growth (sd) sd_growth=lag_gdp_growth ///
        (min) min_growth=lag_gdp_growth (max) max_growth=lag_gdp_growth ///
        (count) n_growth=lag_gdp_growth ///
        (mean) mean_spend=leave_gdp (sd) sd_spend=leave_gdp ///
        (min) min_spend=leave_gdp (max) max_spend=leave_gdp ///
        (count) n_spend=leave_gdp ///
        (mean) mean_male=male_rate (sd) sd_male=male_rate ///
        (min) min_male=male_rate (max) max_male=male_rate ///
        (count) n_male=male_rate ///
        (mean) mean_female=female_rate (sd) sd_female=female_rate ///
        (min) min_female=female_rate (max) max_female=female_rate ///
        (count) n_female=female_rate
    list
    export excel using "${tabledir}/descriptive_261109.xlsx", firstrow(variables) replace
restore

* Compact N/mean/sd table
dtable employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    leave_gdp male_rate female_rate, ///
    export("${tabledir}/descriptive_dtable_261109.docx", replace)

* Figure 1: gap against lagged leave
twoway (scatter employment_gap lag_fatherweeks10) ///
    (lfit employment_gap lag_fatherweeks10), ///
    title("Father-specific paid leave and the employment gap") ///
    xtitle("Lagged father-specific paid leave, per 10 weeks") ///
    ytitle("Male minus female employment rate, percentage points") ///
    legend(label(1 "Country-year observation") label(2 "Linear fit")) ///
    graphregion(color(white))
graph export "${figdir}/scatter_gap_leave_261109.png", as(png) replace

* Figure 2: outcome distribution
histogram employment_gap, ///
    title("Distribution of the employment gap") ///
    xtitle("Male minus female employment rate, percentage points") ///
    graphregion(color(white))
graph export "${figdir}/histogram_gap_261109.png", as(png) replace

* Figure 3: average gap over time
bysort year: egen mean_gap = mean(employment_gap)
twoway (connected mean_gap year), ///
    title("Average employment gap, 23 European OECD countries") ///
    ytitle("Male minus female employment rate, percentage points") ///
    xtitle("Year") ///
    graphregion(color(white))
graph export "${figdir}/trend_gap_261109.png", as(png) replace

//Close log if needed
if ${store_log_descriptive}==1 {
    cap log close
}
