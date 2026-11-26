# ECON 490 poster replication

This folder contains the code that reproduces the figures and the model
comparison table used in the conference poster. It is kept separate from the
paper chain in `do_files/` so the poster can be rebuilt on its own.

## Files

- `do_files/poster/0_poster_master_261125.do` runs everything in order.
- `do_files/poster/childcare_poster_figures_261125.do` draws the five figures
  from the analysis panel.
- `do_files/poster/childcare_poster_checks_261125.do` produces the model
  comparison table and the supplemental checks reported on the poster.

## How to run

Set Stata's working directory to the project root, then run
`do do_files/poster/0_poster_master_261125.do`. The analysis panel
`oecd_childcare_261109.dta` must be present in the project root (the paper
chain builds it). Output figures and tables are written to this `poster/`
folder.

The model uses 2010 as the reference year for country-specific trends, the
same 347 complete country-years from 23 OECD countries, and Prais-Winsten
estimation with panel-corrected standard errors and a common AR(1) process.

The figure scripts use Stata's built-in graphics commands and the commands
covered by the course COMET notebooks and the Stata cheat sheet. The model
comparison and sensitivity tables are written with `etable` so stars and
standard errors come directly from the stored estimates.
