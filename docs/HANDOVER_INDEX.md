# Document index

The entry point is **`../README.md`**: it carries the reading order, the closed
decisions and the pre-edit checklist. The detailed handover is
**`HANDOVER.md` at the repository root**. Read both, then use this index. All documents listed in sections 1-3 are
English and self-contained: they cite filenames and URLs, not a private
document collection.

## 1. Start here (authoritative, English)

| File | What it answers |
|---|---|
| `../README.md` | Reading order, what each document is for, closed decisions, pre-edit checklist, collaboration rules |
| `../HANDOVER.md` | Full project state: research direction, progress, results, explicit and implicit course rules, pitfalls, frozen decisions, open items, reproduction |
| `CODE_CONVENTIONS.md` | Permitted command set, banned commands, the three documented exceptions (including instructor-approved `quietly summarize`), comment rules, coding level, pre-commit checks |
| `COURSE_REQUIREMENTS.md` | All 18 Nov rubric items with point values, allowed file types, 11 Dec gates, implicit course conventions |
| `RUBRIC_REDLINES.md` | Every 11/18 rubric clause turned into a must-do / must-not-do technical line, with the 100-point map |
| `SUBMISSION_STATUS.md` | What is done, the manual Canvas checklist, ready-to-paste Canvas comments |
| `TEAMMATE_NOTES.md` | Short rules for a teammate joining the project: course constraints, frozen decisions, current numbers |
| `../CHANGELOG.md` | Dated change record |

## 2. Decisions, corrections, citations

| File | What it answers |
|---|---|
| `RESEARCH_DECISIONS.md` | Every sample / subset / control / specification decision and its reason, including the EU-targets subset split |
| `PITFALLS_AND_CORRECTIONS.md` | Mistakes already made and what replaced them. Read before proposing a fix |
| `DATA_CITATIONS.md` | Official "How to cite" rules with URLs, and the four citation strings used in the do-file (SOCX accessed 16 November 2026, the others 14 November 2026) |

## 3. Paper writing and people

| File | What it answers |
|---|---|
| `LITERATURE_SOURCES.md` | Article PDFs by filename, the EU policy sources for the subset split, plus AER / Chicago paper-format rules |
| `ECON490_PAPER_OUTLINE_EN_261112.md` | Final-paper outline with word budgets |
| `ECON490_SULTANA_TASKS_261111.txt` | Division of labour; Sultana owns paper text and formatted tables |

## 4. Where the Chinese material went

Earlier versions of this mirror carried Chinese working notes and two
Chinese-language command indexes. Their content now lives in the English
documents and the files themselves were removed, so the repository has one
language:

| Removed file | Now covered by |
|---|---|
| `COMET_Notebook_command_syntax_index.md`, `StataTest_ECON490Quizzes_command_syntax_index.md` (Chinese, removed) | `CODE_CONVENTIONS.md` §1 (permitted set), §2 (documented exceptions), §7 (module-by-module provenance) |
| `ECON490_DECISION_2026-11-11.txt` (interaction term) | `README.md` §7 and `RESEARCH_DECISIONS.md` |
| `ECON490_SAMPLE_SCOPE_NOTE_261112.txt` (Europe stays primary) | superseded — the OECD childcare panel is now the primary and only analysis; see `RESEARCH_DECISIONS.md` §0 |
| `ECON490_PRECISION_STYLE_DECISION_261114.txt` (float vs double) | `RESEARCH_DECISIONS.md` §4 |
| `ECON490_ECONOMETRIC_FILES_GAP_261114.txt` (rubric gap audit) | `COURSE_REQUIREMENTS.md` and `SUBMISSION_STATUS.md` |
| `ECON490_NEAL_REPORT_261113_CN.txt` (status report) | `HANDOVER.md` §3 and `CHANGELOG.md` |
| `NEAL_HANDOFF_USABLE_261113.txt` (old file provenance) | retired with the files it described |
| `SYNC_STATUS_2026-11-14.md` (mirror scope and the 15 Nov verification) | `README.md` §3, `SUBMISSION_STATUS.md` §1 and §2 |

## 5. Authoritative outputs elsewhere in this repository

- `log_files/3_results_261109.log` — all main regression numbers. Highest authority.
- `log_files/4_tables_261109.log` — build-up and winsorized estimates.
- `log_files/2_descriptive_261109.log` — 2019 summary table, figures and subset columns.
- `log_files/1_build_data_261109.log` — sample construction and coverage counts.
- `tables/results_oecd_childcare_261109.docx` — main result table.
- `1_build_data_261109.do` (`* Data sources` block) — the four data citations.

## 6. Archived single file childcare variant

`legacy/prior_pcse/` contains the earlier single-file do-file, its log, and
its formatted PCSE table. These belong to a superseded specification with
different controls and data handling. They are excluded from the current
master chain and submission package.
