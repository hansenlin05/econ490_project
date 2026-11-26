/* Project info
   ECON 490 team project | 0_poster_master_261125.do
   reproduce the figures and model comparison shown in the conference poster
   run this one after the main paper chain has built the analysis panel */

clear

/* Directory settings */
********************* * Directory Settings ***********************

capture noisily cd "C:\Users\Hansen\UBC\ECON 490 003 2026W1 Seminar in Applied Economics - 2_Team\econ490_project"
capture noisily dir

global poster_datadir "."              // folder holding oecd_childcare_261109.dta
global poster_figdir "${poster_datadir}/poster"      // poster figure output
global poster_tabledir "${poster_datadir}/poster"    // poster table output

/* run the two poster files in order */
********************* * Run Order ***********************

capture noisily do "${poster_datadir}/do_files/poster/childcare_poster_figures_261125.do"
capture noisily do "${poster_datadir}/do_files/poster/childcare_poster_checks_261125.do"
