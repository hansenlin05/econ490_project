/* Project info
   ECON 490 team project | 0_master_261109.do
   public childcare spending and the gender employment gap
   OECD ILO panel 2000-2024, main variable is public childcare spending
   run this one first and edit the cd line below to point at your folder */

clear

/* Directory settings, where each global points */
********************* * Directory Settings ***********************

capture noisily cd "C:\Users\Hansen\UBC\ECON 490 003 2026W1 Seminar in Applied Economics - 2_Team\econ490_project"
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

/* Project settings, the run switch */
********************* * Project Settings ***********************

global run_build = 1                // 0 skip the build, 1 run it
global run_descriptive = 1          // 0 skip, 1 run
global run_mainresults = 1          // 0 skip, 1 run
global run_tables = 1               // 0 skip, 1 run
global run_validate = 1             // 0 skip, 1 run
global run_additional = 1           // 0 skip, 1 run

/* one log for the whole run, hosted here so every do writes to the same file */
capture log close
capture noisily log using "${log_dir}/econ490_all_261109.log", text replace

/* run the numbered files in order, no per-file logs inside them */
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
if ${run_validate}==1 {
    capture noisily do "${do_dir}/5_validate_2019_261125.do"
}
if ${run_additional}==1 {
    capture noisily do "${do_dir}/6_additional_checks_261125.do"
}

capture log close

