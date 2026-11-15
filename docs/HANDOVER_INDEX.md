# Document index

The single authoritative handover is **`HANDOVER.md` at the repository root**.
Read it first, then use this index. All documents listed in sections 1-3 are
English and self-contained: they cite filenames and URLs, not a private
document collection.

## 1. Start here (authoritative, English)

| File | What it answers |
|---|---|
| `../HANDOVER.md` | Full project state: research direction, progress, results, explicit and implicit course rules, pitfalls, frozen decisions, open items, reproduction |
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

## 4. Permitted-command indexes (reference tables)

| File | What it answers |
|---|---|
| `COMET_Notebook_命令与语法汇总.md` | Stata syntax literally shown in the COMET notebooks |
| `StataTest与ECON490Quizzes_命令与语法汇总.md` | Syntax from Tests One-Seven, quizzes and `StataCheatSheet_analysis_19.pdf`; boundary items and their resolution |

These two are Chinese-language reference tables. They are only needed when
checking whether a command is permitted; paper writing does not need them.

## 5. Legacy background — not authoritative

The following older files are kept for provenance only. They are in Chinese,
some of them contain conclusions that have since been retired, and they must
**not** be used as the current state:

- `ECON490_ECONOMETRIC_FILES_GAP_261114.txt` — the original 18 Nov gap audit;
  its status note says the code gaps have been closed, but the item-by-item
  body describes the pre-fix state. Use `COURSE_REQUIREMENTS.md` and
  `SUBMISSION_STATUS.md` instead.
- `ECON490_NEAL_REPORT_261113_CN.txt` — Chinese status report from 13 Nov.
- `ECON490_SULTANA_TASKS_261111.txt` — kept for the ready-to-paste message to
  Sultana, but its "Notes for Hansen" section predates the 18 Nov rubric.
- `COMET_Notebook_命令与语法汇总.md`, `StataTest与...汇总.md` — see §4.

The Chinese-language handover that had been uploaded to the repository root
and to `docs/` has been removed; `HANDOVER.md` replaces it. The team keeps its
own Chinese copy in the local working folder, outside this mirror.

## 6. Authoritative outputs elsewhere in this repository

- `log_files/3_results_261109.log` — all main regression numbers. Highest authority.
- `log_files/4_tables_261109.log` — build-up and subset table estimates.
- `log_files/1_build_data_261109.log` — sample construction and coverage counts.
- `tables/results_europe_261109.docx` — main result table.
- `1_build_data_261109.do` (`* Data sources` block) — the five data citations.
