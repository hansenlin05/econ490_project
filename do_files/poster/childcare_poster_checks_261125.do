/* Project info
   ECON 490 team project | childcare_poster_checks_261125.do
   produce the model comparison and sensitivity results shown on the poster
   run after setting the working directory to the project root */

clear

/* Directory settings */
********************* * Directory Settings ***********************

global datadir_raw "./data_raw"                   // raw SOCX extract for the placebo test
global datadir_final "./data_final"                 // panel built by the main chain
global poster_tabledir "./poster"        // output folder for the poster tables

/* Load the estimation sample and set the panel */
********************* * Panel Setup ***********************

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample == 1
generate year_centered = year - 2010
sort country_id year
xtset country_id year, yearly

/* Model comparison: pooled, two-way fixed effects, and fixed effects with
   country-specific linear trends. Stars and standard errors come from etable. */
********************* * Model Comparison ***********************

local variables ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending
xtpcse ln_gender_gap `variables', het corr(ar1)
estimates store pooled
xtpcse ln_gender_gap `variables' i.year i.country_id, het corr(ar1)
estimates store two_way_fe
xtpcse ln_gender_gap `variables' i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store main_trends
etable, estimates(pooled two_way_fe main_trends) keep(`variables') ///
    mstat(N) showstars showstarsnote varlabel ///
    export("${poster_tabledir}/childcare_regression_table.docx", replace)

/* Outcomes for mothers and fathers estimated separately on the same controls */
********************* * Gender Outcomes ***********************

generate ln_mothers = ln(female_rate)
generate ln_fathers = ln(male_rate)
local controls ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id
quietly xtpcse ln_gender_gap ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_gap
quietly xtpcse ln_mothers ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_mothers
quietly xtpcse ln_fathers ln_childcare_spending `controls', het corr(ar1)
estimates store outcome_fathers
etable, estimates(outcome_gap outcome_mothers outcome_fathers) keep(ln_childcare_spending) ///
    mstat(N) showstars showstarsnote varlabel ///
    export("${poster_tabledir}/childcare_gender_outcomes.docx", replace)

/* Placebo: next-year spending should not predict the current gap. Build the
   lead on the full series before restricting to the estimation sample. */
********************* * Placebo Test ***********************

import delimited "${datadir_raw}/oecd_socx_ecec_gdp.csv", clear varnames(1)
keep if unit_measure == "PT_B1GQ" & expend_source == "ES10" & programme_type == "TP521"
rename ref_area iso
rename time_period year
encode iso, generate(spending_id)
xtset spending_id year, yearly
sort spending_id year
generate lead_spending = ln(1 + F1.obs_value)
keep iso year lead_spending
sort iso year
save "${datadir_final}/tmp_poster_lead_spending.dta", replace

use "${datadir_final}/oecd_childcare_261109.dta", clear
merge 1:1 iso year using "${datadir_final}/tmp_poster_lead_spending.dta"
drop if _merge == 2
drop _merge
keep if childcare_sample == 1
generate year_centered_post = year - 2010
sort country_id year
xtset country_id year, yearly
local controls_post ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered_post#i.country_id
quietly xtpcse ln_gender_gap ln_childcare_spending `controls_post' if !missing(lead_spending), het corr(ar1)
estimates store placebo_base
quietly xtpcse ln_gender_gap ln_childcare_spending lead_spending `controls_post' if !missing(lead_spending), het corr(ar1)
estimates store placebo_joint
etable, estimates(placebo_base placebo_joint) keep(ln_childcare_spending lead_spending) ///
    mstat(N) showstars showstarsnote varlabel ///
    export("${poster_tabledir}/childcare_placebo.docx", replace)

/* Leave-one-country-out: refit the main model dropping each country in turn */
********************* * Leave One Out ***********************

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample == 1
generate year_centered = year - 2010
sort country_id year
xtset country_id year, yearly
local controls_loo ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id
levelsof iso, local(countries)
foreach country of local countries {
    quietly xtpcse ln_gender_gap ln_childcare_spending `controls_loo' if iso != "`country'", het corr(ar1)
    estimates store omit_`country'
}
etable, estimates(omit_AUT omit_BEL omit_CAN omit_CHL omit_COL omit_CZE omit_DEU omit_ESP omit_EST omit_FRA omit_GBR omit_GRC omit_HUN omit_IRL omit_ITA omit_LTU omit_LUX omit_LVA omit_NLD omit_POL omit_PRT omit_SVN omit_TUR) ///
    keep(ln_childcare_spending) mstat(N) showstars showstarsnote ///
    export("${poster_tabledir}/childcare_leave_one_out.docx", replace)

/* COVID-era sensitivity: full window, excluding 2020-21, and pre-2020 only */
********************* * COVID Sensitivity ***********************

local controls_covid ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year i.country_id c.year_centered#i.country_id
quietly xtpcse ln_gender_gap `controls_covid' if year < 2024, het corr(ar1)
estimates store covid_full
quietly xtpcse ln_gender_gap `controls_covid' if !inrange(year, 2020, 2021), het corr(ar1)
estimates store covid_exclude
quietly xtpcse ln_gender_gap `controls_covid' if year <= 2019, het corr(ar1)
estimates store covid_pre
etable, estimates(covid_full covid_exclude covid_pre) keep(ln_childcare_spending) ///
    mstat(N) showstars showstarsnote varlabel ///
    export("${poster_tabledir}/childcare_covid_sensitivity.docx", replace)

/* Diagnostics: heteroskedasticity, serial correlation, year and panel effects */
********************* * Diagnostics ***********************

xtreg ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
testparm c.year_centered#i.country_id
capture noisily xttest3
capture noisily xtserial ln_gender_gap ln_childcare_spending ln_father_leaveweeks ln_mother_leaveweeks lag_lngdp ln_leave_spending
