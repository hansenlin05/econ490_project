# Notes for a teammate's AI assistant

Read `README.md` first for the reading order and the closed decisions, then
`HANDOVER.md`. This page is the short version for an assistant that is joining
the project with only this repository.

Before reviewing or editing any do-file, read `CODE_CONVENTIONS.md`. It lists
the permitted commands, the banned ones, the three documented exceptions and
the comment rules. A patch that violates it is declined even if the numbers are
correct.

## What this repository is

A mirror for information sync and handoff between the teammates' AI assistants.
It is **not** the course submission. The 18 Nov 2026 Econometric Files and the
11 Dec 2026 final paper are uploaded from the team's OneDrive project to Canvas.
Nothing here is graded. By standing instruction, changes are synced to OneDrive
by default and to GitHub only when the user explicitly asks.

All rules in this repository are justified with filenames or URLs. If a source
file named in a rule is not available to you, ask the team for the file rather
than filling the gap from general knowledge.

## What you may do

- Read the do-files, logs, tables and figures to understand the current state.
- Draft or polish paper prose, format exported Word tables, check reference
  metadata, summarise meetings.
- Answer "what does this file do" and "what are the current numbers" from the
  logs in `log_files/`.

## What you must not decide on your own

The course restricts Stata syntax to what is literally demonstrated in the
team's own Stata handouts: `StataCheatSheet_analysis_19.pdf`, the COMET
notebooks (including `18 - Stata Workflow Guide – COMET.pdf`), the Stata Test
do-files (Test One-Seven) and the quiz do-files. Two local indexes record that
vocabulary: `docs/CODE_CONVENTIONS.md` lists every permitted command and where
the course demonstrates it.

If you do not have those source files, do **not** judge whether a command is
allowed, do not propose `reghdfe` / `csdid` / `eventdd` / `bacondecomp` or any
other command from general Stata practice, and do not reinterpret p-values or
standard-error conventions. Earlier feedback from an assistant working without
the source handouts needed line-by-line correction on exactly these points.
Raise a question instead of changing the specification.

Also do not: swap the primary and extension samples, pool the two panels,
reintroduce a retired p-value, change the subset definition without changing
both `4_tables_261109.do` and `2_descriptive_261109.do`, or treat a GitHub
commit as a Canvas submission.

## Frozen decisions (need a written group decision to reopen)

- Europe (23 countries, 2006-2019, N=295) is primary; OECD (26 countries,
  2000-2024, N=477) is an extension. Never pooled.
- Two-way fixed effects with lagged father-specific paid leave; DiD and the
  event study are supplementary within the same framework.
- Every regression includes lagged log real GDP per capita.
- Country-clustered standard errors are the reference inference.
- The `weeks x pay_c` interaction and the quadratic term are not in the main
  model; the unwinsorized specification is preferred.
- The 18 Nov tables use the 26-country OECD panel as "all countries", 2019 as
  the representative year, and 19 European / 7 non-European subsets. The
  non-European column is kept for the required three columns but is disclosed
  as low-power (6 groups, 102 observations) and must not be interpreted.
- Conclusion: no robustly significant policy effect / conditional association.
- All historically significant p-values are retired.

Full rationale in `docs/RESEARCH_DECISIONS.md`.

## Current headline numbers (from `log_files/3_results_261109.log`)

Europe main table N = 272 / 272 / 272 / 295 / 272 / 295; OECD N = 333 / 333 / 443.
`lag_fatherweeks10` = +0.668 with FE p=0.016, robust p=0.054,
country-cluster p=0.065; AR(1) PCSE +0.560 (p=0.007). DiD -0.626 (p=0.653).
Event-study periods p=0.878 / 0.815 / 0.817 / 0.603. OECD columns
p=0.352 / 0.583 / 0.746. With only 23 country clusters, the lecture note
`Preparing for Panel Data Analysis` ("always cluster your SEs", rough floor
30-50) means the clustered p=0.065 is itself optimistic; PCSE is a sensitivity
check only.

## Evidence hierarchy

Primary course PDFs > original logs and data > authoritative web sources >
conclusions from any earlier AI conversation (verify each one). Do not treat a
summary or a second-hand paraphrase as primary evidence. Compare file contents
before claiming a version changed. Keep denominators closed. Do not infer
agreement from silence.

## People and dates

Hansen and Neal own code; Sultana owns paper text and formatted tables.
18 Nov 2026: one set of do, log, data and image files. 2 and 7 Dec 2026:
posters. 11 Dec 2026: final paper. Details in
`docs/COURSE_REQUIREMENTS.md`; remaining manual work in
`docs/SUBMISSION_STATUS.md`.
