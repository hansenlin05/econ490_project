/* Project info
   ECON 490 team project | 0_master_261109.do
   Father-specific paid leave and the gender employment gap.
   Main: OECD ILO panel, 2000-2024. Further analysis: European Eurostat panel, 2006-2019.
   From the repository root, run this file to produce one annotated project log. */

clear

/* Directory settings: paths to folders, defined as globals */
********************* * Directory Settings ***********************

global proj_name "econ490_project"                 // project name
global proj_main "."
global datadir_raw   "${proj_main}/data_raw"       // raw files
global datadir_final "${proj_main}/data_final"     // built files
global do_dir        "${proj_main}/do_files"       // do-files path
global log_dir       "${proj_main}/log_files"      // log-file path
global tabledir      "${proj_main}/tables"         // tables path
global figdir        "${proj_main}/figures"        // figures path
global literature    "${proj_main}/literature"     // literature path
global paperdir      "${proj_main}/paper"          // paper path

* Shared controls for the main model.
global controls "lag_lngdp lag_gdp_growth leave_gdp"

* Build data and fit the supplementary models. The log prints compact
* tables of those estimates while retaining the main diagnostics in full.
capture log close
do "${do_dir}/1_build_data_261109.do"
do "${do_dir}/4_tables_261109.do"

log using "${log_dir}/econ490_oecd_261109.log", text replace

* Raw-source provenance and sample checks from 1_build_data_261109.do.
* OECD PF2.5 leave history, ILOSTAT household employment, Eurostat employment,
* World Bank WDI macro controls and OECD SOCX leave spending.
display "OECD ILO panel rows: " ${total_oecd} "; main complete cases: " ${complete_oecd}
display "European Eurostat panel rows: " ${total_europe} "; complete cases: " ${complete_europe}
display "Eurostat lookup: rows outside the selected geography = " ${unmatched_euro_map_master}
display "European employment/policy merge: master-only / using-only = " ///
    ${unmatched_euro_policy_master} " / " ${unmatched_euro_policy_using}
display "OECD employment/policy merge: master-only / using-only = " ///
    ${unmatched_oecd_policy_master} " / " ${unmatched_oecd_policy_using}

display "Descriptive statistics and figures"
do "${do_dir}/2_descriptive_261109.do"

display "Main regression: OECD ILO panel"
do "${do_dir}/3_results_261109.do"

log close
