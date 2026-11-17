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
COMET notebooks (including `18 - Stata Workflow Guide – COMET.pdf`), the Stata
Test do-files (Test One-Seven) and the quiz do-files. The Stata CheatSheet was
removed from this list on 16 November 2026 and is no longer a permitted source.
Two local indexes record the vocabulary: `docs/CODE_CONVENTIONS.md` lists every
permitted command and where the course demonstrates it.

Do not use `reghdfe` / `csdid` / `eventdd` / `bacondecomp` or any other command
from general Stata practice that the handouts do not show. Do not reinterpret
p-values or standard-error conventions — the reading used in the logs is the
one the course notes teach. Raise a question rather than changing the
specification on an unverified convention.

Also avoid: quoting any number from the retired father-leave chain,
reintroducing a retired p-value, changing the subset definition without
changing both `2_descriptive_261109.do` and the subset table export, or
treating a GitHub commit as a Canvas submission.

## Frozen decisions (need a written group decision to reopen)

- The OECD childcare panel (23 countries, 2000-2024, 477 panel rows, 347
  complete-case estimation rows) is the primary and only analysis. The earlier
  Europe-primary father-leave design was retired on 16 November 2026.
- Main explanatory variable: lagged public ECEC spending (SOCX TP521).
  Father-specific leave weeks stay in the model as a control. Every regression
  includes lagged log real GDP per capita.
- Year effects, country effects and country-specific linear trends are in the
  main specification; standard errors clustered by country are the reference
  inference and unclustered robust SEs and PCSE with common AR(1) are the
  sensitivity checks.
- The quadratic spending term is not in the main model; the unwinsorized
  specification is preferred.
- The 18 Nov tables use 2019 as the representative year and the EU
  childcare-targets group vs other OECD members as the subsets. The small
  other-OECD column is kept for the required three columns but is disclosed as
  low-power (38 observations) and must not be interpreted.
- Conclusion: a statistically significant negative conditional association,
  phrased as an association rather than a causal effect.
- All coefficients and p-values of the retired father-leave chain are retired.

Full rationale in `docs/RESEARCH_DECISIONS.md`.

## Current headline numbers (from `log_files/3_results_261109.log`)

All regressions use N = 347; the subset columns use 309 (EU-target group) and
38 (other OECD). The headline is the log specification with country-clustered
SEs (the lecture note's "Always cluster your SEs"): `ln_spending` **-0.582**
with year and country effects plus country trends (clustered SE 0.172,
p = 0.003), -0.582 with unclustered robust SEs (p < 0.001), **-0.477** under
PCSE with common AR(1) (p < 0.001), and -0.581 in the full 1/99 winsorized
repeat (p = 0.002). Keeping both fixed effects and dropping only the trends
gives **+0.131** (p = 0.518), so the negative association rides on the
country-specific trends; the trend terms stand because countries started from
different childcare systems, and this is reported wherever the headline is
quoted. The level comparison column gives -9.456 (clustered p = 0.009).
Diagnostics: `xttest3` p < 0.001, `xtserial` p = 0.0009, `testparm i.year`
p = 0.2904 (year effects not jointly significant in the log model but
retained because the rubric requires them), `testparm i.country_id`
p < 0.001, quadratic term p = 0.8891. 23 clusters is below the lecture
note's 30-50 floor and the paper discloses this.

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
