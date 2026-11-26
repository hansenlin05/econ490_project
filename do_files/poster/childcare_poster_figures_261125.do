/* Project info
   ECON 490 team project | childcare_poster_figures_261125.do
   reproduce the five figures used in the conference poster
   run after setting the working directory to the project root */

clear

/* Directory settings */
********************* * Directory Settings ***********************

global datadir_final "."                 // panel built by the main chain
global poster_figdir "./poster"          // output folder for the poster figures

/* Load the estimation sample and set the panel */
********************* * Panel Setup ***********************

use "${datadir_final}/oecd_childcare_261109.dta", clear
quietly levelsof iso if !missing(employment_gap), local(matched_iso)
local matched_count : word count `matched_iso'
keep if childcare_sample == 1
quietly levelsof iso, local(estimation_iso)
local estimation_count : word count `estimation_iso'
generate year_centered = year - 2010
sort country_id year
xtset country_id year, yearly

/* Adjusted spending-gap scatter: residualize both axes on the model terms,
   then fit a line to the residuals. Each point is one country-year. */
********************* * Adjusted Scatter ***********************

local adjustment ln_leaveweeks ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id
regress ln_spending `adjustment'
predict spend_hat, xb
generate adjusted_spending = ln_spending - spend_hat
regress ln_gap `adjustment'
predict gap_hat, xb
generate adjusted_gap = ln_gap - gap_hat
regress adjusted_gap adjusted_spending
twoway (scatter adjusted_gap adjusted_spending, msize(small) mcolor("20 125 135%70")) ///
    (lfit adjusted_gap adjusted_spending, lcolor("20 53 72") lwidth(medthick)), ///
    xtitle("Adjusted transformed childcare spending") ytitle("Adjusted log gap") ///
    legend(off) graphregion(color(white)) xsize(10) ysize(3.5) scale(1.2)
graph export "${poster_figdir}/stata_adjusted_scatter.png", as(png) replace width(2400)

/* Build-up graph: the childcare coefficient as controls enter one at a time */
********************* * Build-up Graph ***********************

preserve
generate step = _n
generate coefficient = .
local added
local position 1
foreach control in baseline ln_leaveweeks ln_motherweeks lag_lngdp ln_leavespending {
    if "`control'" != "baseline" local added `added' `control'
    quietly xtpcse ln_gap ln_spending `added' ///
        i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
    replace coefficient = _b[ln_spending] if step == `position'
    local ++position
}
keep if !missing(coefficient)
twoway connected coefficient step, sort mcolor("20 125 135") lcolor("20 125 135") ///
    lwidth(medthick) msize(medium) ///
    xlabel(1 "Childcare" 2 "+ Father leave" 3 "+ Mother leave" 4 "+ GDP" 5 "+ Leave spending", labsize(small)) ///
    ylabel(-.60(.04)-.44, angle(horizontal)) ytitle("Coefficient") xtitle("") ///
    xsize(8) ysize(3) scale(1.2) graphregion(color(white))
graph export "${poster_figdir}/stata_buildup_graph.png", as(png) replace width(1800)
restore

/* Country paths: observed gaps and separate fits over a shared window */
********************* * Country Paths ***********************

twoway (line employment_gap year if iso=="FRA" & inrange(year,2001,2021), sort lcolor("20 53 72") lwidth(medthick)) ///
    (lfit employment_gap year if iso=="FRA" & inrange(year,2001,2021), lcolor("20 53 72") lpattern(dash)) ///
    (line employment_gap year if iso=="AUT" & inrange(year,2001,2021), sort lcolor("20 125 135") lwidth(medthick)) ///
    (lfit employment_gap year if iso=="AUT" & inrange(year,2001,2021), lcolor("20 125 135") lpattern(dash)) ///
    (line employment_gap year if iso=="BEL" & inrange(year,2001,2021), sort lcolor("174 92 51") lwidth(medthick)) ///
    (lfit employment_gap year if iso=="BEL" & inrange(year,2001,2021), lcolor("174 92 51") lpattern(dash)), ///
    legend(order(1 "France" 3 "Austria" 5 "Belgium") rows(1) size(small) position(6) ring(1)) ///
    xtitle("Year") ytitle("Employment gap (pp)") xlabel(2001(1)2021, angle(45) labsize(small)) ///
    xsize(8) ysize(5) graphregion(color(white))
graph export "${poster_figdir}/stata_country_paths.png", as(png) replace width(2000)

/* Country slopes: raw annual trends, one fit per country, split across two panels */
********************* * Country Slopes ***********************

preserve
bysort iso: generate observations = _N
keep if observations >= 2
replace country = "UK" if iso=="GBR"
generate slope = .
levelsof iso, local(slope_countries)
foreach code of local slope_countries {
    quietly regress employment_gap year if iso == "`code'"
    replace slope = _b[year] if iso == "`code'"
}
collapse (mean) slope, by(country)
sort slope
generate row = _n
generate negative = slope if slope < 0
generate positive = slope if slope >= 0
forvalues column = 1/2 {
    local first = 1 + 11*(`column'-1)
    local last = 11*`column'
    graph hbar (asis) negative positive if inrange(row,`first',`last'), ///
        over(country, sort(slope) label(labsize(small))) stack ///
        bar(1, color("20 125 135")) bar(2, color("174 92 51")) legend(off) ///
        ylabel(-1.6 -.8 0 .4, labsize(small)) ytitle("") ///
        graphregion(color(white)) name(slopes`column', replace)
}
graph combine slopes1 slopes2, cols(2) graphregion(color(white))
graph export "${poster_figdir}/stata_country_slopes.png", as(png) replace width(2200)
restore

/* Sample coverage: countries included versus excluded at each selection step */
********************* * Sample Coverage ***********************

preserve
clear
input category country_count
1 .
2 .
3 .
end
replace country_count = `estimation_count' if category == 1
replace country_count = 38 - `matched_count' if category == 2
replace country_count = `matched_count' - `estimation_count' if category == 3
graph hbar (mean) country_count, over(category, relabel(1 "Included" 2 "No ILOSTAT match" 3 "No leave spending")) ///
    bar(1, color(teal)) title("Countries") graphregion(color(white))
graph export "${poster_figdir}/stata_sample_coverage.png", as(png) replace width(1800)
restore
