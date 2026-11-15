/* Project info
   ECON 490 team project | 0_master_261109.do
   Father-specific paid leave and the gender employment gap.
   Primary: 23 European OECD countries, 2006-2019. Extension: 26 ILO countries, 2000-2024.
   Run this file first: it sets the paths and calls the four numbered do-files in order. */

clear

/* Directory settings: paths to folders, defined as globals */
********************* * Directory Settings ***********************

capture noisily cd "C:/Users/Hansen/UBC/ECON 490 003 2026W1 Seminar in Applied Economics - 2_Team/econ490_project"
capture noisily dir

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

/* Project settings: such as global variables and other macros */
********************* * Project Settings ***********************

global run_build = 1                // 0 = skip build step; 1 = run build.do
global store_log_build = 1          // 0 = don't save log file; 1 = save log file
global run_descriptive = 1          // 0 = skip; 1 = run
global store_log_descriptive = 1    // 0 = don't save log file; 1 = save log file
global run_mainresults = 1          // 0 = skip; 1 = run
global store_log_mainresults = 1    // 0 = don't save log file; 1 = save log file
global run_tables = 1              // 0 = skip; 1 = run
global store_log_tables = 1        // 0 = don't save log file; 1 = save log file

* Lagged log GDP per capita is in every regression
global controls "lag_lngdp lag_gdp_growth leave_gdp"

/* Run the do-files: runs all of the do-files for the project */
if ${run_build}==1 {
    capture noisily do "${do_dir}/1_build_data_261109.do"
}
if ${run_descriptive}==1 {
    capture noisily do "${do_dir}/2_descriptive_261109.do"
}
if ${run_mainresults}==1 {
    capture noisily do "${do_dir}/3_results_261109.do"
}
if ${run_tables}==1 {
    capture noisily do "${do_dir}/4_tables_261109.do"
}

