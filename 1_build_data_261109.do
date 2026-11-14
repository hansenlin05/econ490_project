/* Project info
   1_build_data_261109.do | rebuilds both locked panels from data_raw, then the two analysis files
   Europe: 23 Eurostat countries, 2006-2019, N=295. OECD: 26 ILO countries, 2000-2024, N=477. Never pooled.
   Step 0 merges the 11/4 upstream build logic so this chain now runs from raw sources.
   Inputs: country_codes.csv, oecd_leave_history.xlsx, eurostat_employment_raw.csv,
   ilo_household_raw.csv, wdi_raw.dta, oecd_policy_donor.dta.
   generate + recast double + replace: plain generate stores a float, so the replace refills at double precision. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_build}==1 {
    cap log close
    capture noisily log using "${log_dir}/1_build_data_261109.log", text replace
}

* Step 0: rebuild both locked panels from data_raw (merged from the 11/4 build do-files)
* Europe: Eurostat lfst_hhacwnc, 23 OECD countries, 2006-2019, N=295
* Import the original OECD policy workbook.
import delimited "${datadir_raw}/country_codes.csv", clear varnames(1) stringcols(_all)
tempfile country_codes euro_codes policy panel
save `country_codes'
preserve
keep if geo!=""
save `euro_codes'
restore

import excel "${datadir_raw}/oecd_leave_history.xlsx", sheet("Time-Series") cellrange(A9) allstring clear
rename A country
rename B year
rename S total_all_raw
rename T total_paid_raw
keep country year total_all_raw total_paid_raw
destring year, replace force
keep if inrange(year,1970,2024)
merge m:1 country using `country_codes'
keep if _merge==3
drop _merge
isid iso year

* Apply the previously documented legal effective-date corrections.
generate timing_note = ""
replace total_paid_raw = "2.6" if iso=="FRA" & year==2014
replace timing_note = "PreParE effective 2015, not 2014" if iso=="FRA" & year==2014
replace total_paid_raw = "4" if iso=="IRL" & year==2019
replace timing_note = "Two weeks Parents Leave effective November 2019" if iso=="IRL" & year==2019
replace total_paid_raw = string(real(total_paid_raw)+13) if iso=="ITA" & year==2022
replace timing_note = "Three months reserved paid parental leave effective August 2022" if iso=="ITA" & year==2022

* Align annual snapshots to the legal years listed in the OECD annex.
foreach measure in all paid {
    generate snapshot = real(total_`measure'_raw)
    bysort iso: egen aligned = max(cond(year==2020,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="AUT" & year==2019
    drop aligned
    bysort iso: egen aligned = max(cond(year==2021,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="EST" & year==2020
    drop aligned
    bysort iso: egen aligned = max(cond(year==2011,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="FIN" & year==2010
    drop aligned
    bysort iso: egen aligned = max(cond(year==2022,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="GRC" & year==2021
    drop aligned snapshot
}
replace timing_note = "OECD annex: effective 2019; 2020 snapshot" if iso=="AUT" & year==2019
replace timing_note = "OECD annex: effective 2020; 2021 snapshot" if iso=="EST" & year==2020
replace timing_note = "OECD annex: effective 2010; 2011 snapshot" if iso=="FIN" & year==2010
replace timing_note = "OECD annex: effective 2021; 2022 snapshot" if iso=="GRC" & year==2021

* Retain slash-separated entitlement options instead of averaging them.
foreach measure in all paid {
    split total_`measure'_raw, parse("/") generate(`measure'_option)
    destring `measure'_option*, replace force
    egen `measure'_min = rowmin(`measure'_option*)
    egen `measure'_max = rowmax(`measure'_option*)
    egen `measure'_n = rownonmiss(`measure'_option*)
    generate known_`measure' = `measure'_n>0 & `measure'_min>=0
    bysort iso (year): generate same_`measure' = `measure'_n==`measure'_n[_n-1] & abs(`measure'_min-`measure'_min[_n-1])<=0.1 & abs(`measure'_max-`measure'_max[_n-1])<=0.1
    bysort iso (year): generate nondecrease_`measure' = same_`measure' | `measure'_min>=`measure'_max[_n-1]-0.1
    bysort iso (year): generate increase_`measure' = `measure'_min>`measure'_max[_n-1]+0.1
}
generate known_policy = known_all & known_paid
bysort iso (year): generate expansion = year==year[_n-1]+1 & known_policy & known_policy[_n-1]==1 & nondecrease_all & nondecrease_paid & (increase_all | increase_paid)
replace expansion = 0 if !inrange(year,2000,2024)
* Czech 2007 records a benefit change, not a verified new duration right.
replace expansion = 0 if iso=="CZE" & year==2007
bysort iso: egen reform_year = min(cond(expansion==1,year,.))
keep iso country year total_all_raw total_paid_raw known_policy reform_year timing_note
keep if inrange(year,2000,2024)
save `policy'

* Import every reported observation from the original Eurostat JSON.
* The CSV changes the storage format only; the JSON is supplied alongside it.
import delimited "${datadir_raw}/eurostat_employment_raw.csv", clear varnames(1) stringcols(_all)
rename time year
destring year value, replace
keep if freq=="A" & age=="Y25-54" & unit=="THS_PER"
keep if n_child=="TOTAL" & agechild=="Y_LT6"
keep if inlist(sex,"M","F") & inlist(wstatus,"EMP","POP")
merge m:1 geo using `euro_codes'
keep if _merge==3 & geo!=""
drop _merge
* Retain the established 23-country Eurostat sample, all OECD members.
keep if inrange(year,2006,2019)
bysort iso year: egen unreliable = max(strpos(flag,"u")>0)
keep if unreliable==0
generate measure = sex+"_"+wstatus
keep iso year measure value flag
isid iso year measure
reshape wide value flag, i(iso year) j(measure) string
generate male_rate = 100*valueM_EMP/valueM_POP
recast double male_rate
replace male_rate = 100*valueM_EMP/valueM_POP
generate female_rate = 100*valueF_EMP/valueF_POP
recast double female_rate
replace female_rate = 100*valueF_EMP/valueF_POP
generate source_flags = flagF_EMP+";"+flagF_POP+";"+flagM_EMP+";"+flagM_POP
keep iso year male_rate female_rate source_flags

* Merge raw outcomes with the policy history and apply the existing sample rule.
merge 1:1 iso year using `policy'
keep if _merge==3 & known_policy==1
drop _merge
drop if missing(male_rate,female_rate)
generate employment_gap = male_rate-female_rate
recast double employment_gap
replace employment_gap = male_rate-female_rate
generate treated = reform_year<=2019
encode iso, generate(country_id)
isid country_id year
sort country_id year
save "${datadir_final}/europe_twfe.dta", replace
export delimited using "${datadir_final}/europe_twfe.csv", replace

* OECD extension: ILO household series, 26 countries, 2000-2024, N=477
* Import the original OECD policy workbook.
import delimited "${datadir_raw}/country_codes.csv", clear varnames(1) stringcols(_all)
tempfile country_codes_o euro_codes_o policy_o panel_o
save `country_codes_o'
preserve
keep if geo!=""
save `euro_codes_o'
restore

import excel "${datadir_raw}/oecd_leave_history.xlsx", sheet("Time-Series") cellrange(A9) allstring clear
rename A country
rename B year
rename S total_all_raw
rename T total_paid_raw
keep country year total_all_raw total_paid_raw
destring year, replace force
keep if inrange(year,1970,2024)
merge m:1 country using `country_codes_o'
keep if _merge==3
drop _merge
isid iso year

* Apply the previously documented legal effective-date corrections.
generate timing_note = ""
replace total_paid_raw = "2.6" if iso=="FRA" & year==2014
replace timing_note = "PreParE effective 2015, not 2014" if iso=="FRA" & year==2014
replace total_paid_raw = "4" if iso=="IRL" & year==2019
replace timing_note = "Two weeks Parents Leave effective November 2019" if iso=="IRL" & year==2019
replace total_paid_raw = string(real(total_paid_raw)+13) if iso=="ITA" & year==2022
replace timing_note = "Three months reserved paid parental leave effective August 2022" if iso=="ITA" & year==2022

* Align annual snapshots to the legal years listed in the OECD annex.
foreach measure in all paid {
    generate snapshot = real(total_`measure'_raw)
    bysort iso: egen aligned = max(cond(year==2020,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="AUT" & year==2019
    drop aligned
    bysort iso: egen aligned = max(cond(year==2021,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="EST" & year==2020
    drop aligned
    bysort iso: egen aligned = max(cond(year==2011,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="FIN" & year==2010
    drop aligned
    bysort iso: egen aligned = max(cond(year==2022,snapshot,.))
    replace total_`measure'_raw = string(aligned,"%18.10g") if iso=="GRC" & year==2021
    drop aligned snapshot
}
replace timing_note = "OECD annex: effective 2019; 2020 snapshot" if iso=="AUT" & year==2019
replace timing_note = "OECD annex: effective 2020; 2021 snapshot" if iso=="EST" & year==2020
replace timing_note = "OECD annex: effective 2010; 2011 snapshot" if iso=="FIN" & year==2010
replace timing_note = "OECD annex: effective 2021; 2022 snapshot" if iso=="GRC" & year==2021

* Retain slash-separated entitlement options instead of averaging them.
foreach measure in all paid {
    split total_`measure'_raw, parse("/") generate(`measure'_option)
    destring `measure'_option*, replace force
    egen `measure'_min = rowmin(`measure'_option*)
    egen `measure'_max = rowmax(`measure'_option*)
    egen `measure'_n = rownonmiss(`measure'_option*)
    generate known_`measure' = `measure'_n>0 & `measure'_min>=0
    bysort iso (year): generate same_`measure' = `measure'_n==`measure'_n[_n-1] & abs(`measure'_min-`measure'_min[_n-1])<=0.1 & abs(`measure'_max-`measure'_max[_n-1])<=0.1
    bysort iso (year): generate nondecrease_`measure' = same_`measure' | `measure'_min>=`measure'_max[_n-1]-0.1
    bysort iso (year): generate increase_`measure' = `measure'_min>`measure'_max[_n-1]+0.1
}
generate known_policy = known_all & known_paid
bysort iso (year): generate expansion = year==year[_n-1]+1 & known_policy & known_policy[_n-1]==1 & nondecrease_all & nondecrease_paid & (increase_all | increase_paid)
replace expansion = 0 if !inrange(year,2000,2024)
* Czech 2007 records a benefit change, not a verified new duration right.
replace expansion = 0 if iso=="CZE" & year==2007
bysort iso: egen reform_year = min(cond(expansion==1,year,.))
keep iso country year total_all_raw total_paid_raw known_policy reform_year timing_note
keep if inrange(year,2000,2024)
save `policy_o'

* Import the unchanged ILO source CSV, decompressed from the source archive.
import delimited "${datadir_raw}/ilo_household_raw.csv", clear varnames(1) stringcols(_all)
rename ref_area iso
rename time year
destring year obs_value, replace force
keep if classif1=="HHT_AGGREGATE_K" & classif2=="CHL_AGET6_YES"
keep if inlist(sex,"SEX_M","SEX_F") & inrange(year,2000,2024)
bysort iso year: egen flagged = max(obs_status!="")
keep if flagged==0
generate sexcode = cond(sex=="SEX_M","M","F")
keep iso year sexcode obs_value
isid iso year sexcode
reshape wide obs_value, i(iso year) j(sexcode) string
rename obs_valueM male_rate
rename obs_valueF female_rate
generate source_flags = ""

* Merge raw outcomes with the policy history and apply the existing sample rule.
merge 1:1 iso year using `policy_o'
keep if _merge==3 & known_policy==1
drop _merge
drop if missing(male_rate,female_rate)
generate employment_gap = male_rate-female_rate
recast double employment_gap
replace employment_gap = male_rate-female_rate
generate treated = reform_year<=2024
encode iso, generate(country_id)
isid country_id year
sort country_id year
save "${datadir_final}/oecd_twfe.dta", replace
export delimited using "${datadir_final}/oecd_twfe.csv", replace


* Prepare the control files; iso in the panels = countrycode in the donors
* GDP lags are built on the full WDI annual series before merging, so first-year and post-gap rows keep their previous-year GDP
preserve
    use "${datadir_raw}/wdi_raw.dta", clear
    rename countrycode iso
    keep iso year ny_gdp_pcap_kd ny_gdp_mktp_kd_zg
    duplicates report iso year

    generate lngdp = ln(ny_gdp_pcap_kd) if ny_gdp_pcap_kd>0
    recast double lngdp
    replace lngdp = ln(ny_gdp_pcap_kd) if ny_gdp_pcap_kd>0

    generate gdp_growth = ny_gdp_mktp_kd_zg
    recast double gdp_growth
    replace gdp_growth = ny_gdp_mktp_kd_zg

    encode iso, generate(wdi_id)
    xtset wdi_id year, yearly

    generate lag_lngdp = L1.lngdp
    recast double lag_lngdp
    replace lag_lngdp = L1.lngdp

    generate lag_gdp_growth = L1.gdp_growth
    recast double lag_gdp_growth
    replace lag_gdp_growth = L1.gdp_growth

    label variable lngdp "Log real GDP per capita (WDI, constant prices)"
    label variable gdp_growth "Real GDP growth, percent (WDI)"
    label variable lag_lngdp "Lagged log real GDP per capita"
    label variable lag_gdp_growth "Lagged real GDP growth, percent"
    keep iso year ny_gdp_pcap_kd ny_gdp_mktp_kd_zg lngdp gdp_growth lag_lngdp lag_gdp_growth
    save "${datadir_final}/wdi_controls.dta", replace
restore

preserve
    use "${datadir_raw}/oecd_policy_donor.dta", clear
    keep countrycode year leave_gdp maternal_weeks
    rename countrycode iso
    duplicates report iso year
    save "${datadir_final}/policy_controls.dta", replace
restore

* Build one analysis file per sample
foreach s in europe oecd {

    display "========== building sample: `s' =========="

    use "${datadir_final}/`s'_twfe.dta", clear
    xtset country_id year, yearly
    display "Observations in locked panel = " _N

    * PF2.1 Total_Father_specific_paid; slash cells keep the lower bound
    generate fatherweeks = real(total_paid_raw)
    recast double fatherweeks
    replace fatherweeks = real(total_paid_raw)
    replace fatherweeks = 28.6  if total_paid_raw == "28.6 / 54.6"
    replace fatherweeks = 30.17 if total_paid_raw == "30.17 / 56.17"
    label variable fatherweeks "Weeks of paid father-specific leave (PF2.1, lower bound)"

    * Unit: pp change in the gap per 10 extra weeks of lagged leave
    generate fatherweeks10 = fatherweeks/10
    label variable fatherweeks10 "Father-specific paid leave, per 10 weeks"
    generate lag_fatherweeks10 = L1.fatherweeks10
    label variable lag_fatherweeks10 "Lagged father-specific paid leave, per 10 weeks"

    * WDI macro controls, with lags already built on the full annual series
    sort iso year
    merge 1:1 iso year using "${datadir_final}/wdi_controls.dta"
    keep if _merge==3
    drop _merge

    * Public leave spending; maternal_weeks kept for inspection only (sparse coverage)
    sort iso year
    merge 1:1 iso year using "${datadir_final}/policy_controls.dta"
    keep if _merge==3
    drop _merge

    * Lagged log GDP per capita is required in every regression
    label variable leave_gdp "Public maternity and parental leave spending, percent of GDP"

    * post: years at/after the first verified expansion; controls have no reform year
    generate post = (year>=reform_year) if !missing(reform_year)
    replace post = 0 if missing(post)
    label variable post "Post first verified expansion of reserved paid leave"

    * Record control coverage in the log
    display "Coverage check: observations with non-missing paid maternity weeks"
    count if maternal_weeks!=.
    display "Coverage check: observations with non-missing lagged log GDP per capita"
    count if lag_lngdp!=.
    display "Coverage check: observations with non-missing public leave spending"
    count if leave_gdp!=.

    save "${datadir_final}/`s'_analysis_261109.dta", replace
    display "========== sample `s' saved =========="
}

* CSV copies for the data part of the submission
foreach s in europe oecd {
    use "${datadir_final}/`s'_analysis_261109.dta", clear
    export delimited using "${datadir_final}/`s'_analysis_261109.csv", replace
}

* Module 18: leave the primary sample in memory when the next do-file runs
use "${datadir_final}/europe_analysis_261109.dta", clear

//Close log if needed
if ${store_log_build}==1 {
    cap log close
}
