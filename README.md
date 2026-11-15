# ECON 490 Team Project — English handoff mirror

**Read `HANDOVER.md` first.** It is the single authoritative, self-contained
project handover in English. This README is only a map.

This repository is an information-sync mirror between the teammates and their
AI assistants. It is **not** a course submission. The 18 Nov 2026 "Econometric
Files" and the 11 Dec 2026 final paper are uploaded from the team's OneDrive
project to Canvas. By standing instruction, changes are synced to OneDrive by
default; GitHub is updated only when the user explicitly asks.

Everything in `HANDOVER.md` and `docs/*.md` is written for a reader who has
only this repository: rules are justified with **filenames or web URLs** that
anyone can check. If you cannot find a source, ask the team instead of guessing.

## Start here

| File | What it answers |
|---|---|
| `HANDOVER.md` | Current research direction, progress, results, explicit and implicit course rules, pitfalls, frozen decisions, open items |
| `docs/COURSE_REQUIREMENTS.md` | Every 18 Nov rubric item and point value, allowed file types, 12 Dec checklist gates, implicit conventions |
| `docs/RESEARCH_DECISIONS.md` | Why each sample, subset, control set and specification was chosen — including why the weak non-European column is kept |
| `docs/PITFALLS_AND_CORRECTIONS.md` | Mistakes already made, and what replaced them. Read before proposing a fix |
| `docs/DATA_CITATIONS.md` | Official "How to cite" rules with URLs, and the five citation strings used in the do-file |
| `docs/SUBMISSION_STATUS.md` | What is done, the manual Canvas checklist, and the ready-to-paste Canvas comments |
| `docs/LITERATURE_SOURCES.md` | The ten article PDFs by filename and the paper-writing format rules |
| `docs/HANDOVER_INDEX.md` | Full document map, including which older files are legacy background |

## Research in one paragraph

Question: does longer father-specific paid leave reduce the male-minus-female
employment gap? Primary panel: 23 European OECD countries, 2006-2019, N=295
(Eurostat). Extension: 26 OECD countries, 2000-2024, N=477 (ILOSTAT). The two
are never pooled because their outcome definitions differ. Two-way fixed
effects with lagged log GDP per capita in every regression; country-clustered
standard errors are the reference inference. Main coefficient +0.668
(cluster p=0.065), DiD -0.626 (p=0.653), OECD p=0.352 / 0.583 / 0.746.
**Conclusion: no robustly significant policy effect, only a conditional
association.** All historically significant p-values are retired; do not roll
back a specification to obtain stars.

## Reproduce

Set Stata's working directory to the project root and run
`do do_files/0_master_261109.do`. The root copies of the five do-files are
byte-identical to the `do_files/` copies; `do_files/` mirrors the folder
structure expected by `18 - Stata Workflow Guide – COMET.pdf`. The master calls
the four numbered do-files in order; `1_build_data` rebuilds both panels from
the frozen files in `data_raw/`. No network access is used at run time.

Requirements: Stata 17 or newer (developed on StataNow/SE 19), plus the
user-written `xttest3`, `xtserial` and `coefplot`. On a new machine only the
single `capture noisily cd "..."` line in `0_master_261109.do` needs editing.
Use `clear`, not `clear all`: the master defines globals that the numbered
do-files need.

**Inputs are frozen local snapshots.** A change that read five official
endpoints at run time was reverted (PR #1 / commit `8efda45`): ILOSTAT returned
HTTP 200 with 0 bytes for both `.csv` and `.csv.gz`, the Eurostat SDMX 3.0
response was 12.7 MB and unfinished after 20 s, and live source revisions
would make the submitted log irreproducible. Official sites are cited as
provenance only; access date for all five sources is **14 November 2026**.

## Layout

- `do_files/` and root — the same five numbered do-files (`0_master`,
  `1_build_data`, `2_descriptive`, `3_results`, `4_tables`).
- `log_files/` — four numbered logs, each created by its do-file and each under
  the assignment's 25-page limit (conservative estimates 14.8 / 7.3 / 17.4 /
  22.6 pages).
- `tables/` — ten exported tables; `figures/` — five PNG figures.
- `data_raw/`, `data_final/` — frozen inputs and built panels.
- `docs/` — the English handover set plus older background notes.
- `CHANGELOG.md` — dated change record.

## Where the authoritative numbers live

`log_files/3_results_261109.log` holds the main estimates; build-up and subset
estimates are in `log_files/4_tables_261109.log`. Any number in a teammate
document that disagrees with these logs is wrong. Evidence order: primary
course PDFs > original logs and data > official web sources > conclusions from
any earlier AI conversation (verify each one).

## Division of labour

Hansen and Neal own the Stata code. Sultana owns the paper text and the
formatted tables. An assistant without the course's own Stata handouts should
not judge which commands are permitted, should not propose `reghdfe`, `csdid`,
`eventdd` or `bacondecomp`, and should not reinterpret p-value conventions —
see `docs/AI_HANDOFF_NOTES.md`.
