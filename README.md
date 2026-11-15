# ECON 490 Team Project — Sync Mirror

**Purpose.** This repository is an information-sync and handoff mirror between the
teammates' AI assistants. It is **not a course submission**. The 18 Nov
Econometric Files and the 11 Dec final paper are submitted from the team OneDrive
project and Canvas, not from here.

Research question: father-specific paid leave and the gender employment gap.
Primary sample: 23 European OECD countries, 2006-2019 (N=295).
Extension: 26 ILO countries, 2000-2024 (N=477). The two panels are never pooled.

## Reproduce

The team OneDrive project is the reference for the model and submission files.
The GitHub master uses the same workflow and reads the official data online.

Set the Stata working directory to the repository root and run
`do 0_master_261109.do`. Use Stata with `dtable` and `etable` support and
the project's `xttest3`, `xtserial`, and `coefplot` commands installed.

The build imports data directly from these official sources.

- [OECD PF2.5](https://www.oecd.org/en/data/datasets/oecd-family-database.html) supplies the historical father-specific leave workbook.
- [Eurostat LFST_HHACWNC](https://ec.europa.eu/eurostat/databrowser/view/lfst_hhacwnc/default/table?lang=en) supplies employment and population counts through the SDMX CSV endpoint.
- [ILOSTAT](https://ilostat.ilo.org/data/bulk/) supplies the household employment series `GED_PEPR_SEX_HHT_CHL_RT_A`.
- [World Bank WDI](https://datatopics.worldbank.org/world-development-indicators/) supplies GDP per capita and GDP growth through the indicator Excel endpoints.
- [OECD SOCX](https://www.oecd.org/en/data/datasets/social-expenditure-database-socx.html) supplies published public maternity and parental leave spending as a percentage of GDP.

The only required file in `data_raw/` is the repository's country lookup,
which records the study's country selection. The other files in that folder
are archived inputs from the previous run. A live run uses the latest figures
available at the source endpoints, so revisions can change estimates.

## Layout

| Path | Contents |
|---|---|
| Root | the four numbered do-files, `README.md`, `CHANGELOG.md` |
| `log_files/` | three numbered logs |
| `tables/` | exported .docx / .xlsx result and descriptive tables |
| `figures/` | four .png figures |
| `data_raw/` | country lookup and archived source snapshots |
| `data_final/` | two locked panels and two analysis files (.dta + .csv) |
| `docs/` | handover, sample-scope note, teammate report, command whitelists, paper outline, AI handoff notes and a document index |

## Where the authoritative numbers live

`log_files/3_results_261109.log` records the estimates for the run that
produced it. Run the master to refresh the logs, tables and figures using live inputs. See `docs/AI_HANDOFF_NOTES.md` before
answering questions about model specification, command whitelists or p-values.

## Course files

Course Outline p.14 asks for "One set of do, log, data, and image files" on
18 Nov. The only checklist is the Final Paper Checklist; its Stata Files section
requires uploaded do/log files, logs created by the do-file, fully annotated
do-files, and all reported work present in do and log. Those requirements are
checked against the OneDrive package, not this mirror.

See `CHANGELOG.md` for recent changes and `docs/SYNC_STATUS_2026-11-14.md` for
what was mirrored.
