# ECON 490 — Project Handover (authoritative English version)

Last updated: 16 November 2026 (local time, MST).
This is the single current handover. `README.md` carries the reading order and
the closed decisions; this file carries the detail; then use
`docs/HANDOVER_INDEX.md` for the document map.

Everything here is written for a teammate who has **only this repository**:
no access to the team's course folder, no chat history, and no special tooling.
Where a rule comes from a course document or a website, the filename or URL is
given so it can be checked independently.

---

## 1. What this repository is, and is not

This GitHub repository (`hansenlin05/econ490_project`) is an **information-sync
mirror** for the teammates. It is **not** a course submission. The 18 Nov 2026
"Econometric Files" and the 11 Dec 2026 final paper are submitted from the
team's OneDrive project folder to Canvas.

Standing instruction: changes are synced to OneDrive by default. This GitHub
mirror is updated only when the team explicitly asks. Do not treat a GitHub
commit as evidence that anything was submitted to Canvas.

People: Hansen and Neal own the Stata code; Sultana owns the paper text and the
formatted tables.

---

## 2. Research question and direction (frozen)

Question: does lagged **public spending on early childhood education and care**
reduce the gender employment gap (male minus female employment rate among
parents with a child under 6, percentage points)? Hypothesis H1 predicts a
negative coefficient on the spending variable.

One primary panel:

| Sample | Countries | Years | Panel rows | Estimation sample |
|---|---|---|---|---|
| Primary and only | 23 OECD countries | 2000-2024 | 477 | 347 (`childcare_sample`) |

Outcome source: ILOSTAT household series (employment rate by sex and household
composition, child under 6). Main explanatory variable: `lag_socx_ecec` —
prior-year public ECEC spending as a share of GDP, OECD SOCX series TP521.
Controls: `lag_fatherweeks10` (lagged father-specific paid leave, 10-week
units), `lag_lngdp` (the course's required convergence variable),
`lag_gdp_growth`, and `leave_gdp` (public maternity and parental leave
spending).

Specification: `regress` with `i.year i.country_id
c.year_centered#i.country_id`, standard errors clustered by country
(reference inference); the same model under unclustered robust SEs and under
PCSE with common AR(1) as the sensitivity checks. Estimates are conditional
associations, not causal effects.
A quadratic spending term was assessed and is not in the main model (p =
0.8891).

**Conclusion to write up:** a statistically significant negative conditional
association conditional on country-specific linear trends. Removing only
the trends while retaining country and year fixed effects gives +0.131
(clustered p = 0.5181). Report this dependence on the trend specification.
The regressions do not establish a causal effect. The earlier father-specific paid leave
analysis was retired on 16 November 2026; none of its numbers may be quoted.

---

## 3. Current state and progress (as of 17 Nov 2026)

The OneDrive submission package contains exactly nine delivery directories:
`do_files/` (5), `log_files/` (4), `tables/` (6), `figures/` (2),
`data_raw/` (11), `data_final/` (7), plus `literature/`, `paper/`, `slides/`
for the 11 Dec paper. Nothing else is allowed at the project root — no
changelogs, no handover files, no notes.

Chain: `do_files/0_master_261109.do` sets paths and calls, in order,
`1_build_data_261109.do`, `2_descriptive_261109.do`, `3_results_261109.do`,
`4_tables_261109.do`. `1_build_data` rebuilds the locked panel directly from
the frozen files in `data_raw/`, so a single master run reproduces everything
from raw inputs. Each numbered do-file opens and closes its own numbered log.
The fourth do-file exists only to keep every log comfortably under the
assignment's log limit; the instructor confirmed 35 pages on 16 November 2026
(see `docs/COURSE_REQUIREMENTS.md`).

Latest verification (16 Nov 2026, full rerun from `data_raw`): no `r()` errors
anywhere, and the key numbers below are exactly the ones in the current logs.
Log sizes are 586 / 423 / 911 / 749 lines, roughly 12.2 / 8.8 / 19.0 / 15.6
pages with 80-character wrapping — all under both the old 25-page and the new
35-page limit.

All 100-point rubric items on the code side are closed: four official data
citations in the do-file; a 2019 single-year summary table restricted to rows
with the main regressor, exported as `.csv` and `.xlsx`; a five-column
build-up table on one fixed estimation sample; a three-column subset table
(all countries / EU-target group / other OECD); two overlapping subset
histograms; a full 1/99 winsorized repeat of all six continuous model
variables; `testparm` tests for the year effects and the country effects; and
the required comments on unmatched merges, winsorization preference and
non-linearity.

**What is still open is human work, not code work** — see
`docs/SUBMISSION_STATUS.md`. In short: the actual Canvas upload, the Canvas
comments, checking the formatted Word tables after any rerun, the empty `literature/` and `paper/`
folders, and the 11 Dec paper itself.

---

## 4. Headline numbers (authority: `log_files/3_results_261109.log` and
`log_files/4_tables_261109.log`)

All regressions use the 347-observation estimation sample; the subset columns
use 309 (EU-target group) and 38 (other OECD).

- **Primary specification** (year + country effects + country trends, SEs
  clustered by country, transformed continuous variables): `ln_spending`
  **−0.582** (SE 0.172, p = 0.003); `testparm ln_spending` F(1, 22) = 11.39.
  GDP per capita is logged. GDP growth is the WDI annual percentage growth
  series and stays in levels. Childcare spending enters as ln(1 + x), so its
  local elasticity is beta × x/(1 + x). At the sample mean of 0.538 percent of
  GDP, a 1 percent relative spending increase is associated with about a 0.20
  percent smaller gap. The coefficient is an elasticity with respect to 1 + x.
  The outcome and public leave spending use ln(x), and father leave uses
  ln(1 + lagged weeks/10).
- **Unclustered robust SEs:** **−0.582** (SE 0.116, p < 0.001); `testparm`
  F(1, 276) = 25.17.
- **PCSE, heteroskedastic panels, common AR(1):** **−0.477** (SE 0.135,
  p < 0.001); `testparm` chi2(1) = 12.52, p = 0.0004.
- Subset columns (clustered): EU-target group −0.566 (p = 0.005); other OECD
  −0.327 (p = 0.149, 38 observations — not readable as a policy effect; the
  table note carries the warning).
- Full 1/99 winsorized repeat: **−0.581** (clustered SE 0.166, p = 0.002),
  same sign and significance, so the unwinsorized model stays preferred.
- Log model without country trends (both fixed effects kept): **+0.131**
  (clustered SE 0.199, p = 0.518). The negative association is identified
  relative to each country's own trajectory; without the trend terms it is
  not present, and the paper reports this openly. The trend terms stand
  because countries started from different childcare systems (the same
  institutional-divergence logic as the Barcelona-targets subset).
- Level specification retained as a comparison column: `lag_socx_ecec`
  **−9.456** (clustered SE 3.305, p = 0.009), a percentage-point effect.
- Diagnostics: `testparm i.year` F(22, 276) = 1.15, p = 0.2904 (year effects retained by
design, although not jointly significant in the log model); `testparm i.country_id` in the LSDV form F(19, 22) = 6.7e+06, p < 0.001 (country
  effects kept); `xttest3` chi2(23) = 5332.23, p < 0.001 (groupwise
  heteroskedasticity present, clustered/PCSE inference responds to it);
  `xtserial` p = 0.0009 (serial correlation present, AR(1) PCSE responds to
  it); quadratic term F(1, 22) = 0.02, p = 0.8891 (not included).

Country-clustered standard errors are the reference inference because the
lecture note "Preparing for Panel Data Analysis" states "Always cluster your
SEs" and demonstrates `vce(cluster id)` verbatim. Unclustered robust SEs and
PCSE are sensitivity checks. With 23 country clusters the note's rough floor
of 30-50 is not met, and the paper discloses this limitation. Any document
whose numbers disagree with these logs is wrong.

---

## 5. Course rules that are explicitly written down

Primary documents (cite these by filename; do not paraphrase them from memory):

- `Econometric Files for Final Paper.pdf` — Canvas assignment export for the
  18 Nov drop. Contains the 100-point rubric, the ten required items, the
  allowed file types and the 25-page log limit (instructor raised it to 35 on
  16 Nov 2026).
- `Final Paper Checklist_ ECON_V 490 003 2026W1 Seminar in Applied Economics.pdf`
  — the 11 Dec paper checklist, 50 points, with four mandatory Stata Files
  gates ("NO PAPER GRADED IF INCOMPLETE").
- `ECON 490 Course Outline.pdf`, p.14 — deadlines and "One set of do, log,
  data, and image files will be uploaded per team to Canvas according to the
  posted checklist."
- `START_HERE_Research_Context.txt` — publication-quality figures/tables and
  the requirement that the do-file rebuilds logs, tables, figures and results.
- `Final Paper Instructions` — at least eight peer-reviewed economics journal
  articles and an AER-style bibliography.
- `18 - Stata Workflow Guide – COMET.pdf` — Workflow Guide 18, the master /
  numbered do-file structure.

The two `...Checklist...` and `Econometric Files...` PDFs are **different
documents with different scopes**. Also note that the Canvas PDF still says
"March 23rd" in its body while its header says "Due No Due Date"; that is a
leftover from an older term. The deadline is 18 Nov 2026 per the Course
Outline.

Full item-by-item breakdown, points and file-type rules:
`docs/COURSE_REQUIREMENTS.md`.

---

## 6. Course rules that are implicit (not written as one list, but binding)

These are conventions the team derived from the course's own Stata handouts and
lecture notes. They are easy to miss and have caused real rework.

1. **Command vocabulary is restricted.** Only syntax literally demonstrated in
   the COMET notebooks (including `18 - Stata Workflow Guide – COMET.pdf`), the
   Stata Test do-files (Test One-Seven) and the quiz do-files may appear in a
   do-file. `StataCheatSheet_analysis_19.pdf` was removed as a source on 16
   November 2026. Banned examples: `reghdfe`, `csdid`, `eventdd`,
   `bacondecomp`. The local index is `docs/CODE_CONVENTIONS.md` §7, which
   records the course module or question set in which each permitted command is
   demonstrated. Panel lags/leads use `L1.` / `F1.` after `encode` + `xtset` +
   `sort`.
2. **Workflow 18 structure.** Master starts with `/* Project info */`, then
   `clear`, directory settings, project settings, and ordered
   `capture noisily do` calls. `clear all` inside a sub-do-file would erase the
   globals defined by the master and break the chain. Star `*` comments are
   printed into the log, which is what "fully annotated log" needs.
3. **Comment style.** One short `* ` line per block, saying only what the block
   does. No change logs, dates, version notes, references to course module
   numbers, paper-writing advice, or justifications of command syntax.
   `display` is not a workflow requirement; it survives only where an `r()`
   count must be written into the log. The full restatement, with the permitted
   command list and the documented exceptions, is `docs/CODE_CONVENTIONS.md`.
4. **Reproducibility.** Inputs are frozen local snapshots in `data_raw/`. A
   proposed change that read five official endpoints at run time was rejected:
   live revisions would make the submitted log irreproducible, and two of the
   endpoints were unreliable on this machine. Official sites are used for
   citation provenance only.
5. **Precision over byte-identity.** When a change affects only float/double
   storage precision, prefer full command-whitelist compliance over identical
   CSV md5. This rule is what allowed the `string()` constructions to be
   replaced by literal numeric replaces with every coefficient unchanged.
6. **Root cleanliness.** The OneDrive project root holds only the nine delivery
   directories. Notes, changelogs and handover documents live in the local
   working folder, never in the submission root.
7. **Number authority.** Primary course PDFs > original logs and data >
   official web sources > any earlier conclusion from a conversation (verify
   each one). Never judge a file's version by filename or timestamp: compare
   bytes. Never treat a summary as primary evidence. Keep statistical
   denominators closed. Do not infer agreement from silence.

---

## 7. Pitfalls we already hit (do not repeat)

- **The leave workbook stores weeks as text**, sometimes with two slash-
  separated options. `real()` plus literal replaces handle it; the three
  year-corrections and four late-snapshot corrections are hardcoded literals
  taken from the next recorded year. Do not reintroduce `string()` formatting.
- **`testparm i.country_id` aborts after `xtreg, fe`** with "no such
  variables", because the fixed-effects estimator absorbs the country effects.
  Run it after the LSDV `regress` that includes `i.country_id`.
- **The "other OECD" subset column has 38 observations** and its coefficient
  (−0.327, p = 0.149) is not readable as a policy effect. It is kept because
  the rubric requires three columns and the split is theory-driven; the table
  note says so.
- **The SOCX lag is built on the full SOCX series before the merge**, in the
  same way as the GDP and leave lags. Building any lag after the merge lets
  outcome availability select the sample; that mistake is why an earlier
  direction's event-study numbers were retired.
- **Six added regressions can push a log past its page limit.** The build-up
  and winsorized work live in a fourth numbered do-file with its own log;
  Workflow Guide 18 §18.2.2 allows a separate do-file for tables.
- **Live endpoint reads are unreliable and would break reproducibility.** The
  ILOSTAT API endpoint returned HTTP 200 with 0 bytes for both `.csv` and
  `.csv.gz`, and the Eurostat SDMX 3.0 response did not finish in 20 s. The
  ILOSTAT bulk download does work — a 15 November re-download was
  byte-identical to the snapshot — so the reason to ship frozen snapshots is
  that a live revision would change the reported numbers, not that the sources
  cannot be fetched.
- **The input csv encoding matters.** The leave timeseries is pre-converted to
  latin-1 because Stata misreads the workbook's UTF-8 output; a UTF-8 version
  once broke the Türkiye rows and dropped 56 merged observations.
- **`inlist()` with 19 string arguments hangs Stata.** Split the country list
  into several `replace` lines.
- **A build-up table with different samples per column cannot be read as the
  effect of adding controls.** All five build-up columns use the same
  347-observation estimation sample.
- **Canvas file types exclude `.xlsx` and `.dta`.** The summary table is
  exported as both `.csv` and `.xlsx` (rubric wording says "Excel or Word
  document"; the CSV is the upload-safe fallback). Data are uploaded as
  `.csv`.

Full list with evidence: `docs/PITFALLS_AND_CORRECTIONS.md`.

---

## 8. Frozen research decisions

| Decision | Reason |
|---|---|
| OECD childcare panel is the primary and only analysis | Team decision of 16 November 2026, following the instructor's suggestion to focus on public childcare spending and the earlier proposal work on this panel |
| `lag_socx_ecec` built on the full SOCX series before any merge | Same principle as the GDP lag; a post-merge lag lets outcome availability select the sample |
| Father-specific leave weeks stay as a control (`lag_fatherweeks10`) | They are the strongest competing policy explanation for the same outcome |
| 2019 is the representative year | Latest year with broad coverage for the single-year summary table (23 rows on the main regressor) |
| Subsets: EU childcare-targets group vs other OECD members | The EU's Barcelona targets and the 2022 Council Recommendation link ECEC provision to parental employment (https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)); no comparable supranational target exists for the other members |
| Keep the weak "other OECD" column | Rubric demands three columns and overlapping subset histograms; deleting it loses points. Disclosed as low-power |
| Country-clustered SEs are the reference inference; robust SEs and PCSE AR(1) are the sensitivity checks | The lecture note demonstrates `vce(cluster id)` and says "Always cluster your SEs"; 23 clusters is below its 30-50 floor and this is disclosed |
| Country-specific linear trends are in the main specification | They absorb divergent institutional trajectories (the Barcelona-targets logic); dropping them removes the association (+0.131, p = 0.518) and this is reported openly |
| No quadratic term | F(1, 22) = 0.02, p = 0.8891; the assignment permits non-linearity only when it improves fit and theory predicts it |
| Unwinsorized specification preferred | The 1/99 repeat keeps the main coefficient at −0.581 with clustered SEs (F(1, 22) = 12.20, p = 0.002); the do-file comment states the preference |
| Fourth numbered do-file for the tables | Keeps every log well under the 35-page limit; Workflow Guide 18 §18.2.2 allows it |
| Build-up table on one fixed sample | All five columns use the same 347-observation sample so coefficient moves read as the effect of added controls |
| 2019 summary table as `.csv` + `.xlsx` | Rubric says "Excel or Word document"; Canvas file types do not list `.xlsx`, so the CSV is the upload-safe fallback |
| Every lag built on its own full annual series before any merge | One principle covers GDP, leave weeks, leave spending and ECEC spending |
| Access dates: SOCX 15 November 2026, the other four sources 14 November 2026 | Kept as written in the do-file citation block |
| OneDrive is the submission source; GitHub is a mirror | Standing instruction. GitHub is updated only on explicit request |

Full rationale: `docs/RESEARCH_DECISIONS.md`. Citation strings and the official
"How to cite" rules: `docs/DATA_CITATIONS.md`.

---

## 9. Reproduce on a fresh machine

1. Install Stata 17 or newer (developed on StataNow/BE 19) and the user-written
   commands `xttest3`, `xtserial`, `coefplot`.
2. Copy the whole `econ490_project` folder, including `data_raw/` — the chain
   does not download anything.
3. Edit the single `capture noisily cd "<path>"` line in the master to your
   project folder. It is the course-demonstrated form of the directory block,
   and `capture noisily` shows the error instead of hiding it if the path is
   wrong. Every other path is a relative global.
4. From the project root run the master; it calls the four numbered do-files.
5. Compare `log_files/` with this repository. Any differing coefficient means
   the reproduction failed.

On a brand-new Stata session `clear` and `clear all` are equivalent for the
first master run; the real portability risks are the `cd` line, missing ado
packages, a Stata version below 17, and a missing `data_raw/`.

---

## 10. Evidence limits and open items

This handover is a secondary document. Re-verify against the course PDFs,
Canvas announcements and the logs after any course-page or code change. The
team's literature PDFs are listed by filename in `docs/LITERATURE_SOURCES.md`;
only those file names, not their full text, are available here.

Open items: Canvas upload and comments; final check of the formatted Word tables
(repeat post-export formatting after any Stata rerun); opening each log in Word
to confirm the rendered page count; empty `literature/` and `paper/` folders;
whether Canvas accepts the `.xlsx` summary table (CSV fallback exists);
whether to ask the TA about the three documented command extensions; 2 Dec and
7 Dec poster requirements; 11 Dec final paper.

See `docs/SUBMISSION_STATUS.md` for the actionable checklist and the ready-to-
paste Canvas comments.
