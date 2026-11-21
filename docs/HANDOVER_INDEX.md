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
| `ECON490_PAPER_OUTLINE_EN_261112.md` | Final-paper outline with word budgets and the authoritative numbers to use |

## 4. Retired directions and files

The earlier Europe-primary father-specific-leave design and its Chinese working
notes were retired on 16 November 2026, when the team adopted the OECD childcare
panel. Their content is either superseded or already carried forward:

- Interaction-term decision, precision/float decision and the rubric gap audit → `RESEARCH_DECISIONS.md`, `docs/COURSE_REQUIREMENTS.md`.
- Status and file-provenance notes → `HANDOVER.md` and `CHANGELOG.md`.
- Command syntax indexes → `CODE_CONVENTIONS.md` §1–§2 and §7.
- Any father-leave coefficient, sample size or p-value from that design is retired and must not reappear in the paper.

The single-file childcare PCSE variant is preserved in `legacy/prior_pcse/`
for rollback only; see §6 below.

## 5. Authoritative outputs elsewhere in this repository

- `log_files/econ490_all_261109.log` — the single combined log holding everything:
  sample construction and coverage counts, diagnostics, 2019 summary, figures,
  main, subset, build-up and winsorized estimates. Highest authority; this is
  the only log file in the repository.
- `tables/results_oecd_childcare_261109.docx` — main result table.
- `1_build_data_261109.do` (`* Data sources` block) — the four data citations.

## 6. Archived single file childcare variant

`legacy/prior_pcse/` contains the earlier single-file do-file, its log, and
its formatted PCSE table. These belong to a superseded specification with
different controls and data handling. They are excluded from the current
master chain and submission package.
