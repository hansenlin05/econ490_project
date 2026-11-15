/* OECD robustness checks and further analyses. */

* Nonlinear check on the same OECD sample as the main model.
use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly
keep if !missing(employment_gap, lag_fatherweeks10, lag_lngdp, lag_gdp_growth, leave_gdp)

xtpcse employment_gap c.lag_fatherweeks10##c.lag_fatherweeks10 ///
    ${controls} i.year i.country_id, het corr(ar1)
estimates store pcse_quad
test c.lag_fatherweeks10#c.lag_fatherweeks10 = 0
global quadratic_p = r(p)

* Winsorize every continuous variable at the 1/99 percentiles and count the changes
summarize employment_gap, detail
local p1_gap = r(p1)
local p99_gap = r(p99)
generate employment_gap_winsor = employment_gap
recast double employment_gap_winsor
replace employment_gap_winsor = employment_gap
label variable employment_gap_winsor "Employment gap, winsorized 1/99 (pp)"
replace employment_gap_winsor = `p1_gap' if employment_gap_winsor < `p1_gap' & employment_gap_winsor != .
replace employment_gap_winsor = `p99_gap' if employment_gap_winsor > `p99_gap' & employment_gap_winsor != .
count if employment_gap_winsor != employment_gap & employment_gap != .
global winsor_changed_gap = r(N)

summarize lag_fatherweeks10, detail
local p1_leave = r(p1)
local p99_leave = r(p99)
generate lag_fatherweeks10_winsor = lag_fatherweeks10
recast double lag_fatherweeks10_winsor
replace lag_fatherweeks10_winsor = lag_fatherweeks10
label variable lag_fatherweeks10_winsor "Lagged father-specific paid leave, winsorized 1/99"
replace lag_fatherweeks10_winsor = `p1_leave' if lag_fatherweeks10_winsor < `p1_leave' & lag_fatherweeks10_winsor != .
replace lag_fatherweeks10_winsor = `p99_leave' if lag_fatherweeks10_winsor > `p99_leave' & lag_fatherweeks10_winsor != .
count if lag_fatherweeks10_winsor != lag_fatherweeks10 & lag_fatherweeks10 != .
global winsor_changed_leave = r(N)

summarize lag_lngdp, detail
local p1_gdp = r(p1)
local p99_gdp = r(p99)
generate lag_lngdp_winsor = lag_lngdp
recast double lag_lngdp_winsor
replace lag_lngdp_winsor = lag_lngdp
label variable lag_lngdp_winsor "Lagged log real GDP per capita, winsorized 1/99"
replace lag_lngdp_winsor = `p1_gdp' if lag_lngdp_winsor < `p1_gdp' & lag_lngdp_winsor != .
replace lag_lngdp_winsor = `p99_gdp' if lag_lngdp_winsor > `p99_gdp' & lag_lngdp_winsor != .
count if lag_lngdp_winsor != lag_lngdp & lag_lngdp != .
global winsor_changed_gdp = r(N)

summarize lag_gdp_growth, detail
local p1_growth = r(p1)
local p99_growth = r(p99)
generate lag_gdp_growth_winsor = lag_gdp_growth
recast double lag_gdp_growth_winsor
replace lag_gdp_growth_winsor = lag_gdp_growth
label variable lag_gdp_growth_winsor "Lagged real GDP growth, winsorized 1/99"
replace lag_gdp_growth_winsor = `p1_growth' if lag_gdp_growth_winsor < `p1_growth' & lag_gdp_growth_winsor != .
replace lag_gdp_growth_winsor = `p99_growth' if lag_gdp_growth_winsor > `p99_growth' & lag_gdp_growth_winsor != .
count if lag_gdp_growth_winsor != lag_gdp_growth & lag_gdp_growth != .
global winsor_changed_growth = r(N)

summarize leave_gdp, detail
local p1_spend = r(p1)
local p99_spend = r(p99)
generate leave_gdp_winsor = leave_gdp
recast double leave_gdp_winsor
replace leave_gdp_winsor = leave_gdp
label variable leave_gdp_winsor "Public leave spending, winsorized 1/99 (percent of GDP)"
replace leave_gdp_winsor = `p1_spend' if leave_gdp_winsor < `p1_spend' & leave_gdp_winsor != .
replace leave_gdp_winsor = `p99_spend' if leave_gdp_winsor > `p99_spend' & leave_gdp_winsor != .
count if leave_gdp_winsor != leave_gdp & leave_gdp != .
global winsor_changed_spend = r(N)

* Repeat the preferred specification with all continuous variables winsorized
xtpcse employment_gap_winsor lag_fatherweeks10_winsor lag_lngdp_winsor ///
    lag_gdp_growth_winsor leave_gdp_winsor i.year i.country_id, het corr(ar1)
estimates store pcse_winsor
test lag_fatherweeks10_winsor = 0
global winsor_p = r(p)


* Single specification built one variable at a time, OECD full sample
use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

* Keep one estimation sample in all four columns
generate byte same_sample = 1
replace same_sample = 0 if missing(employment_gap)
replace same_sample = 0 if missing(lag_fatherweeks10)
replace same_sample = 0 if missing(lag_lngdp)
replace same_sample = 0 if missing(lag_gdp_growth)
replace same_sample = 0 if missing(leave_gdp)
count if same_sample==1

xtpcse employment_gap lag_fatherweeks10 i.year i.country_id ///
    if same_sample==1, het corr(ar1)
estimates store build1
xtpcse employment_gap lag_fatherweeks10 lag_lngdp i.year i.country_id ///
    if same_sample==1, het corr(ar1)
estimates store build2
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if same_sample==1, het corr(ar1)
estimates store build3

* Further analysis compares geographic subsets within the OECD ILO panel.
* Leave spending is omitted from all three columns because coverage differs by region.
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id, het corr(ar1)
estimates store all_countries
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



* Further analysis uses the separate Eurostat outcome for European OECD countries.
use "${datadir_final}/europe_analysis_261109.dta", clear
xtset country_id year, yearly
xtreg employment_gap lag_fatherweeks10 ${controls} i.year, fe vce(robust)
estimates store europe_fe

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
