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
| `CODE_CONVENTIONS.md` | Permitted command set, banned commands, the four documented exceptions, comment rules, coding level, pre-commit checks |
| `COURSE_REQUIREMENTS.md` | All 18 Nov rubric items with point values, allowed file types, 12 Dec gates, implicit course conventions |
| `SUBMISSION_STATUS.md` | What is done, the manual Canvas checklist, ready-to-paste Canvas comments |
| `AI_HANDOFF_NOTES.md` | Short rules for a newly joining assistant: what it may and may not decide |
| `../CHANGELOG.md` | Dated change record |

## 2. Decisions, corrections, citations

| File | What it answers |
|---|---|
| `RESEARCH_DECISIONS.md` | Every sample / subset / control / specification decision and its reason, including the non-European column |
| `PITFALLS_AND_CORRECTIONS.md` | Mistakes already made and what replaced them. Read before proposing a fix |
| `DATA_CITATIONS.md` | Official "How to cite" rules with URLs, and the five citation strings used in the do-file (accessed 14 November 2026) |
| `ECON490_SAMPLE_SCOPE_NOTE_261112.txt` | Original note on why Europe stays primary (background, Chinese) |
| `ECON490_DECISION_2026-11-11.txt` | Original interaction-term decision (background, Chinese) |
| `ECON490_PRECISION_STYLE_DECISION_261114.txt` | Quantified impact of the storage-precision cleanup (background) |

## 3. Paper writing and people

| File | What it answers |
|---|---|
| `LITERATURE_SOURCES.md` | Ten article PDFs by filename, plus AER / Chicago paper-format rules |
| `ECON490_PAPER_OUTLINE_EN_261112.md` | Final-paper outline with word budgets |
| `ECON490_SULTANA_TASKS_261111.txt` | Division of labour; Sultana owns paper text and formatted tables |
| `SYNC_STATUS_2026-11-14.md` | What is mirrored here versus what stays in OneDrive |
| `NEAL_HANDOFF_USABLE_261113.txt` | Which files in Neal's old handoff folder are still usable (provenance only) |

## 4. Where the Chinese material went

Earlier versions of this mirror carried Chinese working notes and two
Chinese-language command indexes. Their content now lives in the English
documents and the files themselves were removed, so the repository has one
language:

| Removed file | Now covered by |
|---|---|
| `COMET_Notebook_命令与语法汇总.md`, `StataTest与ECON490Quizzes_命令与语法汇总.md` | `CODE_CONVENTIONS.md` §1 (permitted set), §2 (documented exceptions), §7 (module-by-module provenance) |
| `ECON490_DECISION_2026-11-11.txt` (interaction term) | `README.md` §7 and `RESEARCH_DECISIONS.md` |
| `ECON490_SAMPLE_SCOPE_NOTE_261112.txt` (Europe stays primary) | `RESEARCH_DECISIONS.md` |
| `ECON490_PRECISION_STYLE_DECISION_261114.txt` (float vs double) | `RESEARCH_DECISIONS.md` §4 |
| `ECON490_ECONOMETRIC_FILES_GAP_261114.txt` (rubric gap audit) | `COURSE_REQUIREMENTS.md` and `SUBMISSION_STATUS.md` |
| `ECON490_NEAL_REPORT_261113_CN.txt` (status report) | `HANDOVER.md` §3 and `CHANGELOG.md` |
| `NEAL_HANDOFF_USABLE_261113.txt` (old file provenance) | retired with the files it described |

## 5. Authoritative outputs elsewhere in this repository

- `log_files/3_results_261109.log` — all main regression numbers. Highest authority.
- `log_files/4_tables_261109.log` — build-up and subset table estimates.
- `log_files/1_build_data_261109.log` — sample construction and coverage counts.
- `tables/results_europe_261109.docx` — main result table.
- `1_build_data_261109.do` (`* Data sources` block) — the five data citations.
