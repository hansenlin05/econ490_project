# Changelog

All entries describe the local OneDrive project; this repository only mirrors
them for teammate / AI handoff. Dates are local (MST).

## 2026-11-14 (evening) — English handover, exact citation dates, subset decision

**Repository reorganised for an English-only reader.** Added `HANDOVER.md` at
the root as the single authoritative handover, plus `docs/COURSE_REQUIREMENTS.md`,
`docs/RESEARCH_DECISIONS.md`, `docs/PITFALLS_AND_CORRECTIONS.md`,
`docs/DATA_CITATIONS.md`, `docs/SUBMISSION_STATUS.md` and
`docs/LITERATURE_SOURCES.md`. Rewrote `README.md`, `docs/HANDOVER_INDEX.md`,
`docs/AI_HANDOFF_NOTES.md`, `docs/SYNC_STATUS_2026-11-14.md` and the Sultana
task note. All new documents justify rules with filenames or URLs only. The
Chinese-language handover previously uploaded to the root and to `docs/` was
removed from this mirror (the team keeps its own Chinese copy locally).

**"How to cite" researched from the publishers' own guidance** and written into
`1_build_data_261109.do`. Sources: the OECD Style Guide (Fourth Edition)
"Citing data" section, the ILOSTAT "Dissemination and analysis / Citations"
page, the World Bank "Summary Terms of Use", the EU data-provider manual's
"Data citation" page and Eurostat's DOI documentation, plus the SOCX dataset DOI.
All five data citations now carry the exact access date **14 November 2026**
(previously "October 2026"), plus version information read from the five saved
source PDFs: Eurostat DOI 10.2908/lfst_hhacwnc (last update 10/09/2026 15:00),
OECD PF2.5 updated November 2026, WDI last updated 11 November 2026, and
https://doi.org/10.1787/data-00167-en for SOCX.

**Non-European subset column: kept.** Rubric item 9 requires three columns and
rubric item 10 requires overlapping histograms for the same subsets; deleting
the column would lose both. The split (19 European / 7 non-European OECD
members) is theory-driven via supranational EU leave mandates. The column has
6 groups and 102 observations, so `4_tables_261109.do` now states in its note
that it is shown for the three-column comparison only and must not be read as
a policy effect. Also corrected a stale "three numbered do-files" phrase in
`0_master_261109.do`.

**Overlapping histogram cleaned up.** `2_descriptive_261109.do` now uses the
course's literal two-group histogram syntax: `bin()` and `subtitle()` (neither
appears in the course handouts) were removed and `lcolor(black)` was added so
both overlaid series stay visible. The figure still shows the same substantive
fact — non-European OECD members cluster at zero weeks of father-specific leave.

**Full rerun and verification (two passes).** No `r()` errors; logs
739 / 330 / 1113 / 560 lines (~15 / 7 / 22 / 11 pages); all four analysis CSVs,
the 2019 summary-table CSV and all 2396 result floats unchanged.
`log_files/3_results_261109.log` is byte-identical apart from its header.

## 2026-11-14 — rubric compliance, official-source decision, fifth numbered do-file

**Official sources: adopted as citations, not as live imports.** Neal's PR #1
(commit `8efda45`, merged as `29eb0d3`) changed `0_master` and `1_build_data`
to read five official endpoints at run time. We reverted the live reads and
kept the provenance information. Measured on this machine: ILOSTAT
`GED_PEPR_SEX_HHT_CHL_RT_A` returns HTTP 200 with 0 bytes for both `.csv` and
`.csv.gz`; the Eurostat SDMX 3.0 response is 12.7 MB and did not complete in
20 s; the other three endpoints respond normally. Beyond reliability, live
revisions would break the course requirement that the submitted log be created
by the do-file and reproduce the reported numbers. The five sources are now
cited in AER / Chicago author-date form in `1_build_data_261109.do`; frozen
snapshots remain in `data_raw/`. Also reverted `do_dir = "${proj_main}"` and
`do` (the Workflow Guide uses `${proj_main}/do_files` and `capture noisily do`),
but kept the portable idea: `global proj_main "."` with one `cd` line to edit.

**Rubric gaps closed** (Canvas assignment "Econometric Files for Final Paper",
100-point rubric, received 18:52): AER data citations in the do-file; a 2019
summary table restricted to `lag_fatherweeks10 != .` (23 observations,
exported as both .xlsx and .csv because Canvas file types exclude .xlsx); a
four-column build-up table with the main regressor first and a
"Year FE: yes; Country FE: yes" note; a three-column subset table (all 26 /
European 19 / non-European 7 OECD countries) with the same core specification;
an overlapping two-subset histogram; comments on merge non-matches, the
preferred unwinsorized specification, and why the non-linear term was dropped.

**Subset decision.** Full sample is the 26-country OECD panel, representative
year 2019, as agreed by the team. Subsets are European vs non-European OECD
members: a defensible institutional split (EU-level leave directives versus
no supranational mandate), and no new data are needed. Grouping by initial
leave generosity was tested and rejected because the median initial
father-specific entitlement is 0, putting all 26 countries in one group. The
core specification omits `leave_gdp` because SOCX coverage is sparse outside
Europe; using full controls would leave only 33 observations in the
non-European column. Even so that column has 6 clusters and 102 observations,
and its coefficient (23.576) is a small-sample artifact — the table note warns
against interpreting it.

**Fifth numbered do-file.** Adding six regressions pushed `3_results` to 1659
lines (~30-33 pages), over the assignment's 25-page log limit. The build-up
and subset tables now live in `4_tables_261109.do` with their own
`4_tables_261109.log`; the Workflow Guide allows separate do-files for tables.
Final log sizes: 732 / 331 / 1113 / 558 lines, all under 25 pages.

**Verification.** Full rerun from `data_raw`: no `r()` errors, all four numbered
logs generated by their do-files, all 2396 original floating-point numbers in
`3_results_261109.log` unchanged, all four analysis CSV md5 unchanged, five
do-files, four logs, nine tables, five figures, all filenames ASCII.

## 2026-11-14 — full deliverables mirror and whitelist cleanup

Added to this mirror: `tables/` (5), `figures/` (4), `data_raw/` (8),
`data_final/` (10), plus `CHANGELOG.md`, `docs/HANDOVER_INDEX.md` and
`docs/AI_HANDOFF_NOTES.md`.

Do-file changes on this date, all verified by a full rerun from `data_raw`:

- Removed `stringcols(_all)` and `allstring` from the import commands. This is a
  float/double storage-precision change only: three rate columns differ by at
  most 1.03e-05 percentage points (Europe) and 7.08e-06 (OECD); every reported
  coefficient, standard error, p-value and sample size is unchanged. The only
  discrete side effect is that outcome winsorization now changes 4 instead of 5
  observations.
- Replaced `cond()`, `[_n-1]` subscripts and `egen max(cond())` with the
  course-taught `L1.` / `F1.` operators, `generate` + `replace`, and
  `egen min()` after `encode` + `xtset` + `sort`.
- Deleted four `destring` lines that had become no-ops (log printed
  "already numeric; no replace").
- Merged two verbatim-duplicated policy-history build blocks into one;
  `1_build_data_261109.do` went from 357 to 275 lines.

Verification: four data CSVs keep their md5 across the last three cleanups;
all 2396 floating-point numbers in `3_results_261109.log` are unchanged; no
`r()` errors; all three numbered logs close normally. Main results are still
+0.668 (cluster p=0.065), AR(1) PCSE +0.560 (p=0.007), DiD -0.626 (p=0.653),
OECD columns p=0.352 / 0.583 / 0.746. Conclusion: no robustly significant
policy effect / conditional association.

## 2026-11-14 — do-files refreshed (web upload)

Four numbered do-files uploaded, including the 275-line `1_build_data`.

## 2026-11-13 — repository created

Initial commit with four do-files and a short README.

## Standing notes

- Europe is the primary sample; OECD is an extension. The two are never pooled.
  See `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt` for the course-based rationale.
- The `weeks x pay_c` interaction is not in the main model. See
  `docs/ECON490_DECISION_2026-11-11.txt` and
  `docs/ECON490_PRECISION_STYLE_DECISION_261114.txt`.
- Historical significant p-values are retired and must not be reinstated.
- Default sync target is OneDrive only. This GitHub mirror is updated only on
  explicit instruction.
