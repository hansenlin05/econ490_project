# Notes for a teammate joining the project

Read `README.md` first for the reading order and the closed decisions, then
`HANDOVER.md`. This page is the short version for a teammate who is joining
with only this repository.

Before reviewing or editing any do-file, read `CODE_CONVENTIONS.md`. It lists
the permitted commands, the banned ones, the documented exceptions and the
comment rules. A patch that violates it is declined even if the numbers are
correct. For the 18 Nov submission rules, read `RUBRIC_REDLINES.md`.

## What this repository is

A mirror for information sync and handoff between teammates. It is **not** the
course submission. The 18 Nov 2026 Econometric Files and the 11 Dec 2026 final
paper are uploaded from the team's OneDrive project to Canvas. Nothing here is
graded. By standing instruction, changes are synced to OneDrive by default and
to GitHub only when the team asks.

All rules in this repository are justified with filenames or URLs. If a source
file named in a rule is not available, ask the team for the file rather than
filling the gap from general knowledge.

## What the project uses

- Read the do-files, logs, tables and figures to understand the current state.
- Draft or polish paper prose, format exported Word tables, check reference
  metadata, summarise meetings.
- Answer "what does this file do" and "what are the current numbers" from the
  logs in `log_files/`.

## Course constraints on Stata syntax

The course restricts Stata syntax to what is literally demonstrated in the
team's own Stata handouts: `StataCheatSheet_analysis_19.pdf`, the COMET
notebooks (including `18 - Stata Workflow Guide – COMET.pdf`), the Stata Test
do-files (Test One-Seven) and the quiz do-files. Two local indexes record that
vocabulary: `docs/CODE_CONVENTIONS.md` lists every permitted command and where
the course demonstrates it.

Do not use `reghdfe` / `csdid` / `eventdd` / `bacondecomp` or any other command
from general Stata practice that the handouts do not show. Do not reinterpret
p-values or standard-error conventions — the reading used in the logs is the
one the course notes teach. Raise a question rather than changing the
specification on an unverified convention.

Also avoid: pooling the two panels, reintroducing a retired p-value, changing
the subset definition without changing both `4_tables_261109.do` and
`2_descriptive_261109.do`, or treating a GitHub commit as a Canvas submission.

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

Europe main table N = 292 / 292 / 292 / 295 / 292 / 295; OECD N = 348 / 348 / 463.
`lag_fatherweeks10` = +0.617 with FE p=0.028, robust p=0.099,
country-cluster p=0.113; AR(1) PCSE +0.493 (p=0.021). DiD -0.626 (p=0.653).
Event-study periods p=0.878 / 0.815 / 0.817 / 0.603. OECD columns
p=0.857 / 0.936 / 0.876. With only 23 country clusters, the lecture note
`Preparing for Panel Data Analysis` ("always cluster your SEs", rough floor
30-50) means the clustered p=0.113 is itself optimistic; PCSE is a sensitivity
check only.

## Evidence hierarchy

Primary course PDFs > original logs and data > authoritative web sources >
any earlier conclusion in a conversation (verify each one). Do not treat a
summary or a second-hand paraphrase as primary evidence. Compare file contents
before claiming a version changed. Keep denominators closed. Do not infer
agreement from silence.

## People and dates

Hansen and Neal own code; Sultana owns paper text and formatted tables.
18 Nov 2026: one set of do, log, data and image files. 2 and 7 Dec 2026:
posters. 11 Dec 2026: final paper. Details in
`docs/COURSE_REQUIREMENTS.md`; remaining manual work in
`docs/SUBMISSION_STATUS.md`.
