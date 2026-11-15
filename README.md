# ECON 490 Team Project — Sync Mirror

**Purpose.** This repository is an information-sync and handoff mirror between the
teammates' AI assistants. It is **not a course submission**. The 18 Nov
Econometric Files and the 11 Dec final paper are submitted from the team OneDrive
project and Canvas, not from here.

Research question: father-specific paid leave and the gender employment gap.
Primary sample: 23 European OECD countries, 2006-2019 (N=295).
Extension: 26 OECD countries, 2000-2024 (N=477). The two panels are never pooled.

## Reproduce

Set Stata's working directory to the project root, then run
`do do_files/0_master_261109.do` (the root copies are identical). The master
sets every path relative to the current directory and calls the five numbered
do-files in order. Stata 17+ is required for `dtable` / `etable`, and
`xttest3`, `xtserial` and `coefplot` must be installed. On a new machine only
the `capture noisily cd "..."` line in `0_master_261109.do` needs editing.
Use `clear`, not `clear all`: the master defines globals that the numbered
do-files need, and `clear all` would erase them.

**Inputs are frozen local snapshots in `data_raw/`.** The chain deliberately
does NOT read live endpoints at run time. Commit `8efda45` imported directly
from official URLs; that approach was reverted after testing:

- ILOSTAT `GED_PEPR_SEX_HHT_CHL_RT_A` returned HTTP 200 with **0 bytes** for
  both `format=.csv` and `format=.csv.gz`;
- the Eurostat SDMX 3.0 response was 12.7 MB and did not finish within 20 s;
- live source revisions would make the submitted log irreproducible, which
  conflicts with the course requirement that the log be created by the do-file
  and that all reported work be present in do and log.

The official provenance of every input is recorded in AER / Chicago
author-date form in the `* Data sources` block of `1_build_data_261109.do`:
Eurostat LFST_HHACWNC; OECD Family Database PF2.5; ILOSTAT
GED_PEPR_SEX_HHT_CHL_RT_A; World Bank WDI NY.GDP.PCAP.KD and
NY.GDP.MKTP.KD.ZG; OECD SOCX. Exact day-level access dates still need to be
confirmed by the team; the do-file currently records month-level access only.

## Layout

- Root and `do_files/`: the same five numbered do-files (`0_master`,
  `1_build_data`, `2_descriptive`, `3_results`, `4_tables`). The `do_files/`
  copy mirrors the OneDrive folder structure required by the Stata Workflow
  Guide; the root copies are kept so this mirror stays easy to browse.
- `log_files/`: four numbered logs, each created by its do-file and each under
  the assignment's 25-page limit.
- `tables/`: nine exported .docx / .xlsx / .csv tables.
- `figures/`: five .png figures.
- `data_raw/`, `data_final/`: frozen inputs and built panels.
- `docs/`: handover, sample-scope note, command whitelists, paper outline,
  AI handoff notes and a document index.

## Where the authoritative numbers live

`log_files/3_results_261109.log` holds the main estimates; the new build-up and
subset estimates are in `log_files/4_tables_261109.log`. Any number in a
teammate document that disagrees with these logs is wrong. See
`docs/AI_HANDOFF_NOTES.md` before answering questions about model
specification, command whitelists or p-values.

## Course files

Course Outline p.14 asks for "One set of do, log, data, and image files" on
18 Nov. The 18 Nov Canvas assignment ("Econometric Files for Final Paper") adds
a 100-point rubric: data-set citations in the do-file, a one-year summary
table, a build-up regression table, a three-column subset table, overlapping
histograms, heteroskedasticity / serial-correlation / FE tests, a winsorized
repeat, publication-ready graphs, comments on whether results support the
hypothesis, and a log no longer than 25 pages. The Final Paper Checklist is the
12 Dec paper rubric. Both are checked against the OneDrive package, not here.

## 14 Nov 2026 changes

Added AER data citations; a 2019 summary table restricted to observations with
the main regressor; a build-up table (one variable at a time, main regressor
first, with year/country FE yes-no notes); a three-column subset table (all 26 /
European 19 / non-European 7 OECD countries); and an overlapping two-subset
histogram. All original estimates are unchanged: the 2396 numbers in
`3_results_261109.log` are byte-for-byte identical and all four analysis CSVs
keep their md5. The fourth numbered do-file exists only to keep each log below
the 25-page limit; the Stata Workflow Guide explicitly allows separate
do-files for tables.

The subset table's non-European column has only 6 clusters and 102
observations. Its coefficient is imprecise and must not be interpreted as a
policy effect; the table note says so. See `CHANGELOG.md` for the full decision
record and `docs/SYNC_STATUS_2026-11-14.md` for what was mirrored.
