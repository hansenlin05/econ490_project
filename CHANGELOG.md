# Changelog

All entries describe the local OneDrive project; this repository only mirrors
them for teammate / AI handoff. Dates are local (MST).

## 2026-11-15 (evening) — source refresh check, portable master, Chinese content merged

**Source vintages checked against the publishers.** Two of the five sources had a
November release; both were downloaded again and compared cell by cell with the
frozen snapshots.

- **OECD PF2.5** (`Last-Modified: 5 Nov 2026 08:56 GMT`, 272,022 bytes against
  the 4 Nov file's 279,582). The new workbook has 2,166 rows instead of 2,128,
  the extra rows being 2025; across the 2,128 overlapping country-years the
  `total_all_raw` and `total_paid_raw` cells are **identical**, zero changes.
  The file was replaced, and `keep if inrange(year,1970,2024)` drops the new
  2025 rows.
- **World Bank WDI** (`lastupdated: 2026-11-11`). Over 14,561 country-years for
  GDP per capita and 14,388 for GDP growth, **no value differs by more than
  1e-9**. The `.dta` snapshot was kept: it carries 14 variables including the
  World Bank metadata columns, and rebuilding it would change bytes without
  changing a number.
- **Eurostat** `lfst_hhacwnc` still reports `updated: 2026-09-10`, so no newer
  release exists. **SOCX** has no public version stamp.
- **ILOSTAT** `GED_PEPR_SEX_HHT_CHL_RT_A` was fetched again on 15 November
  through the ILOSTAT bulk download. The decompressed file is 18,854,904 bytes
  and 169,679 rows covering 2000-2026, and it is **byte-for-byte identical** to
  the snapshot, md5 `e45765c52e64a428dc28819e9d06e5a0` on both. The API endpoint
  still answers HTTP 200 with `Content-Length: 0`; only the bulk route works.
  Earlier notes that called this source impossible to re-download described the
  API route and were wrong about the bulk one.

After the PF2.5 replacement the whole chain was rerun from `data_raw`: all four
analysis CSVs and both table CSVs kept their md5, the four logs kept their line
counts (737 / 354 / 858 / 1087), and no `r()` error appeared. The two November
releases are therefore value-neutral for this project. `docs/DATA_CITATIONS.md`
§8 records the check.

**Master is now portable.** The SharePoint library was renamed on 15 November
(`... - 2_Team` became `... - econ490_project`), which left the single
`capture noisily cd "<absolute path>"` line pointing at a directory that no
longer exists. An edit had already been made in OneDrive to the new absolute
path, with backslashes, which would break again on the next rename and on any
other machine. The line was removed instead. `0_master_261109.do` now opens with
`capture noisily dir` and `global proj_main "."`, so every path is relative to
the working directory and the folder can be renamed, moved, or opened on macOS
without touching the code. The header states that the file must be run from the
project root, and the first `use` in `1_build_data` names the missing file if it
is not.

**Chinese material merged into English and removed.** Eight Chinese files were
deleted from `docs/`, with their content folded into the English set:
the two command indexes into `docs/CODE_CONVENTIONS.md` §7 (module-by-module
provenance) and §2 (documented exceptions); the interaction-term decision into
`README.md` §7 and `RESEARCH_DECISIONS.md`; the sample-scope note and the
float/double note into `RESEARCH_DECISIONS.md`; the rubric gap audit into
`COURSE_REQUIREMENTS.md` and `SUBMISSION_STATUS.md`; the 13 November status
report into `HANDOVER.md`. `docs/HANDOVER_INDEX.md` §4 records where each one
went. The repository now contains one Chinese-free document set; only the file
names of the removed documents remain, in that table.

## 2026-11-15 (afternoon) — PR triage, README as entry point, code conventions

**Two open pull requests reviewed and both declined.**

PR #2 (`zja42/main`, base `29eb0d3`, `mergeable_state = dirty`) was closed. It
restores live official-source imports ("the build reads official data online"),
re-adds `display "Master do-file finished."`, re-adds comments that cite
"Module 18" and "Checklist", adds a paper-writing instruction inside the do-file
("the paper must explain why theory predicts non-linearity") and adds a defence
of the `generate` + `recast double` + `replace` sequence. Those are the four
categories the team removed on 14 November. Its base is four commits behind main,
so it could not merge without resolving conflicts anyway.

PR #3 (`oecd-primary`, base `427e040`, clean) was closed with one element
adopted. The adopted part is `test lag_fatherweeks10 = 0` after the main
regressions: the course's own post-estimation material shows `test 变量 = 0`, and
the three lines make the quoted p-values traceable. Everything else was
declined: it makes the OECD panel the primary analysis, which is a change of
research design rather than a code improvement; it runs `1_build_data` and
`4_tables` before `log using` opens, so three of the five do-files produce no log
at all; it deletes the model equation and the "associations, not causal effects"
annotation; it removes `cd` and `dir` from the master; it demotes `HANDOVER.md`
in the README to "records the earlier European-primary version"; and it leaves
`tables/results_europe_robust_261109.docx` orphaned while adding a second
robustness table.

**`README.md` rewritten as the single entry point.** It now states the reading
order, what each document is for and when to read it, the nine closed decisions,
the eight pitfalls that have already caused damage, what each file type is for,
why there is no `pay_c` term, and the rules under which pull requests are
reviewed. The section "Before you review or edit any do-file" is the checklist a
new assistant should follow before touching code.

**`docs/CODE_CONVENTIONS.md` added.** An English restatement of the permitted
command set by category, the banned commands, the three documented exceptions
(`egen min()/max()`, `generate` + `recast double` + `replace`, and
`dtable ..., continuous(..., statistic(...))`), the comment rules with a
forbidden-examples table, the expected coding level, the standard do-file
skeleton and six pre-commit checks. It is the gate any future patch must pass and
it cites the course handouts by filename only.

**Comment wording fixed in five places.** `1 = run build.do` referred to a file
that does not exist; "locked panels" and "apply the existing sample rule" are
internal process language; "author-date form" described a citation style inside
a data comment. All five were rewritten to say what the code does.

**Verification.** Full rerun from `data_raw`: no `r()` errors; logs 737 / 354 /
858 / 1087 lines (14.7 / 7.3 / 17.9 / 22.6 pages); all four analysis CSVs and
the 2019 summary CSV keep their md5. The three new `test` lines print
`p = 0.0651` (Europe LSDV clustered), `p = 0.0069` (Europe AR(1) PCSE) and
`p = 0.5832` (OECD AR(1) PCSE), matching the numbers already quoted.

## 2026-11-15 (early morning) — complete winsorization, one estimation sample, Word summary table

Four gaps raised by an external review of commit `2995794` were checked against
the rubric PDF and the current logs and then fixed.

**Full winsorized repeat (rubric item 7).** `4_tables_261109.do` now winsorizes
all five continuous variables at 1/99, not just the outcome and log GDP. Country
and year dummies keep their coding. Observations actually changed: outcome 4,
lagged leave weeks 0, log GDP 4, GDP growth 5, leave spending 5. Lagged leave
weeks has p1=0 and p99=2.86, so no row moves; the count is printed to the log so
the zero change is on record rather than implied. The winsorized PCSE coefficient
is +0.571 (SE 0.206, p=0.005) against +0.560 (p=0.007) unwinsorized: same sign,
same significance, slightly larger magnitude, so the unwinsorized model remains
the preferred specification.

**One estimation sample across the build-up table (rubric item 8).** The four
columns previously used 443 / 443 / 443 / 333 observations, which confounds
"added a control" with "changed the sample". All four now use the same 333
observations, built with `generate` + `missing()` on the full control set. The
table note states this. The `3_results` OECD table keeps its own 443 / 443 / 333
design because those columns are descriptive, not a build-up.

**Word version of the 2019 summary table (rubric item 6).** Rubric asks for
"an Excel or Word document" and the Canvas upload list has no `.xlsx`, so
`2_descriptive_261109.do` now also writes
`tables/descriptive_2019_oecd_261109.docx` with
`dtable ..., continuous(... statistic(n mean sd min max)) export(...)`. The N is
reported per variable, not once for the table: `leave_gdp` covers 20 of the 23
rows, the other four cover all 23. The Excel and CSV versions are unchanged,
byte for byte.

**Column headers.** The build-up and subset tables now use `column(index)`, the
form shown in the Stata cheat sheet, instead of `column(dvlabel)`, which
repeated the dependent-variable name once per column. A build-up table with four
identical headers is unreadable on export.

**Canvas comments draft corrected.** The draft said N=295 next to the main
regression; 295 is the input panel, while every Europe regression is estimated
on 272 rows. It also now separates the two kinds of observation loss (rows that
never matched, and rows that matched but drop because `leave_gdp` is missing) and
records both country-clustered p-values: `xtreg, fe vce(robust)` gives p=0.054
and explicit LSDV clustering gives p=0.065, with the same conclusion.

**Where the new code went.** The quadratic and winsorized checks were moved from
`3_results` to `4_tables`: with the extra code `3_results` reached 1257 lines
(~26 pages), over the 25-page limit. Sizes after the move: 739 / 354 / 834 /
1087 lines (14.8 / 7.3 / 17.4 / 22.6 pages at a conservative 80-character wrap).
Five do-files and four logs are unchanged; tables are now ten.

**Verification.** Full rerun from `data_raw`: no `r()` errors, four logs close
normally, all four analysis CSVs and the 2019 summary CSV keep their md5, and
every coefficient, SE, p-value and N in `3_results_261109.log` is unchanged. The
headline results still read +0.668 (cluster p=0.065), AR(1) PCSE +0.560
(p=0.007), DiD -0.626 (p=0.653), OECD p=0.352 / 0.583 / 0.746.

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
