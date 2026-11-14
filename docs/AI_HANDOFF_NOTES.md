# Notes for a teammate's AI assistant

## What this repository is

A mirror for information sync and handoff between the teammates' AI assistants.
It is **not** the course submission. The 18 Nov Econometric Files and the 11 Dec
final paper are uploaded from the team OneDrive project to Canvas. Nothing here
is graded. By standing instruction, changes are synced to OneDrive by default
and to GitHub only when the user explicitly asks.

## What you may use it for

- Reading the current do-files, logs, tables and figures to understand the
  project state.
- Drafting or polishing paper prose, formatting tables, checking references,
  summarising meetings.
- Answering "what does this file do" and "what are the current numbers".

## What you should not decide on your own

The course restricts Stata commands to those literally shown in the ECON 490
COMET Notebook, Stata Tests, Quizzes and the Stata CheatSheet. If you do not
have that knowledge base, do **not** judge whether a command is allowed, do not
propose `reghdfe` / `csdid` / `eventdd` / `bacondecomp` or other commands learned
from general training data, and do not reinterpret p-values or standard-error
conventions. Earlier feedback from an assistant without the knowledge base
needed line-by-line correction on exactly these points. Raise questions instead
of changing the spec.

## Frozen decisions (do not reopen without a written group decision)

- Europe (23 countries, 2006-2019, N=295) is the primary sample; OECD
  (26 countries, 2000-2024, N=477) is an extension. Never pooled.
- Main specification: two-way fixed effects with lagged father-specific paid
  leave; DiD and event study are supplementary within the same framework.
- Every regression includes lagged log real GDP per capita.
- Country-clustered standard errors are the reference inference.
- The `weeks x pay_c` interaction is not in the main model.
- Conclusion: no robustly significant policy effect / conditional association.
- All historically significant p-values are retired. Do not roll back a
  specification to obtain significance.

## Current headline numbers (from `log_files/3_results_261109.log`)

Europe main table N = 272 / 272 / 272 / 295 / 272 / 295; OECD N = 333 / 333 / 443.
`lag_fatherweeks10` = +0.668 with FE p=0.016, robust p=0.054,
country-cluster p=0.065; AR(1) PCSE +0.560 (p=0.007). DiD -0.626 (p=0.653).
Event-study periods p=0.878 / 0.815 / 0.817 / 0.603. OECD columns
p=0.352 / 0.583 / 0.746. With only 23 country clusters, the course material's
"always cluster your SEs" plus its 30-50 cluster rule of thumb means the
clustered p=0.065 is itself optimistic; PCSE is a sensitivity check only.

## Evidence hierarchy

Course primary text > original logs and data > authoritative web sources >
conclusions from any earlier AI conversation (verify each one). Do not treat a
summary or a second-hand paraphrase as primary evidence. Keep denominators
closed. Do not infer agreement from silence.

## People

Hansen and Neal own code; Sultana owns paper text and formatted tables.
The final paper is due 11 Dec 2026; the 18 Nov submission is one set of do,
log, data and image files.
