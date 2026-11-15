/* Project info
   4_tables_261109.do | build-up and subset regression tables for the OECD full sample. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_tables}==1 {
    cap log close
    capture noisily log using "${log_dir}/4_tables_261109.log", text replace
}

* Single specification built one variable at a time, OECD full sample
use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

xtpcse employment_gap lag_fatherweeks10 i.year i.country_id, het corr(ar1)
estimates store build1
xtpcse employment_gap lag_fatherweeks10 lag_lngdp i.year i.country_id, het corr(ar1)
estimates store build2
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id, het corr(ar1)
estimates store build3
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id, het corr(ar1)
estimates store build4

etable, estimates(build1 build2 build3 build4) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    note("Year FE: yes; Country FE: yes in all columns. Main regressor enters first; no non-linear term is added.") ///
    export("${tabledir}/results_buildup_261109.docx", replace)

* Subsets compare countries with and without supranational EU leave mandates
generate byte european = 0
replace european = 1 if inlist(iso,"AUT","BEL","CZE","DEU","ESP","EST","FRA","GBR")
replace european = 1 if inlist(iso,"GRC","HUN","IRL","ITA","LTU","LUX","LVA","NLD")
replace european = 1 if inlist(iso,"POL","PRT","SVN")
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if european==1, het corr(ar1)
estimates store sub_europe
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if european==0, het corr(ar1)
estimates store sub_noneurope

etable, estimates(build3 sub_europe sub_noneurope) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    note("Year FE: yes; Country FE: yes. Subsets split the 26 OECD members by supranational EU leave mandates (19 European, 7 non-European). The non-European column has 6 groups and 102 observations; report it for the three-column comparison only, not as a policy effect.") ///
    export("${tabledir}/results_subsets_261109.docx", replace)

//Close log if needed
if ${store_log_tables}==1 {
    cap log close
}
