/* Project info
   3_results_261109.do | regressions, diagnostics and tables
   Primary: 23 Eurostat countries, 2006-2019. Extension: 26 ILO countries, 2000-2024, reported separately.
   GAP = male minus female employment rate, pp. Eurostat: ages 25-54, youngest child under 6; no couple restriction.
   OECD extension: ILO household series (HHT_AGGREGATE_K, child under 6); population definition differs, never pooled.
   GAP_it = b1*L1.LEAVE10_it + b2*L1.LNGDP_it + b3*L1.GROWTH_it + b4*SPEND_it + country_i + year_t + e_it
   LEAVE10 is in 10-week units; H1 predicts b1<0. Estimates are associations, not causal effects.
   */

//If log setting is activated, we record a log file in the log folder
if ${store_log_mainresults}==1 {
    cap log close
    capture noisily log using "${log_dir}/3_results_261109.log", text replace
}

* Load the saved file if both earlier steps were skipped
if ${run_build}==0 & ${run_descriptive}==0 {
    use "${datadir_final}/europe_analysis_261109.dta", clear
}

xtset country_id year, yearly

* FE baseline; xttest3 and xtserial need the unadjusted fit
xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe
estimates store fixed

* Joint test of the year dummies
testparm i.year

* Heteroskedasticity (modified Wald)
xttest3

* Serial correlation (Wooldridge)
capture noisily xtserial employment_gap lag_fatherweeks10 lag_lngdp ///
    lag_gdp_growth leave_gdp

* Robust standard errors
xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe vce(robust)
estimates store robust

* Country-clustered SEs, LSDV with explicit country and year dummies
regress employment_gap lag_fatherweeks10 ${controls} i.year i.country_id, ///
    vce(cluster country_id)
estimates store clustered

* Hausman: FE vs RE
xtreg employment_gap lag_fatherweeks10 ${controls} i.year, re
estimates store random
capture noisily hausman fixed random

* DiD on the first verified expansion
regress employment_gap 1.treated#1.post ${controls} i.year i.country_id, ///
    vce(cluster country_id)
estimates store did

* Prais-Winsten AR(1); xtpcse does not absorb FE, so dummies are explicit
xtpcse employment_gap lag_fatherweeks10 ${controls} i.year i.country_id, ///
    het corr(ar1)
estimates store pcse

* Event study; k=-1 omitted, endpoints binned at -2 and +2
generate time_entering_treatment = reform_year if treated==1
replace time_entering_treatment = . if treated==0
generate event_time = year - time_entering_treatment
replace event_time = -1 if treated==0
replace event_time = -2 if event_time<-2 & treated==1 & event_time!=.
replace event_time =  2 if event_time> 2 & treated==1 & event_time!=.
tabulate event_time, missing
tabulate event_time, gen(event_time_dummy)
regress employment_gap event_time_dummy1 event_time_dummy3 ///
    event_time_dummy4 event_time_dummy5 ${controls} i.year i.country_id, ///
    vce(cluster country_id)
estimates store eventstudy

coefplot, keep(event_time_*) vertical graphregion(color(white)) yline(0) ///
    rename(event_time_dummy1="k=-2" event_time_dummy3="k=0" ///
           event_time_dummy4="k=+1" event_time_dummy5="k=+2") ///
    title("Event study: father-specific paid leave expansions") ///
    ytitle("Employment gap, male minus female (percentage points)") ///
    xtitle("Years since first expansion, k = -1 omitted")
graph export "${figdir}/event_study_261109.png", as(png) replace

* Formal tables; keep() drops the country and year dummies
etable, estimates(fixed robust clustered did pcse eventstudy) ///
    keep(lag_fatherweeks10 1.treated#1.post ///
         event_time_dummy1 event_time_dummy3 event_time_dummy4 event_time_dummy5 ///
         lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_europe_261109.docx", replace)

* OECD extension: leave_gdp coverage limits the sample; third column drops that covariate
use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe vce(robust)
estimates store oecd_fe
xtpcse employment_gap lag_fatherweeks10 ${controls} i.year i.country_id, ///
    het corr(ar1)
estimates store oecd_pcse
xtreg employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth i.year, ///
    fe vce(robust)
estimates store oecd_fe_nospend

etable, estimates(oecd_fe oecd_pcse oecd_fe_nospend) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_261109.docx", replace)

//Close log if needed
if ${store_log_mainresults}==1 {
    cap log close
}
