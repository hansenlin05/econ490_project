# Sync status — 14 Nov 2026 (evening update)

Companion to `HANDOVER.md` and `docs/SUBMISSION_STATUS.md`; this page only
explains what is in this mirror versus what stays in OneDrive.

## What is mirrored here

The complete 18 Nov deliverable package: five numbered do-files, four numbered
logs, ten tables, five PNG figures, eight `data_raw` inputs and ten
`data_final` outputs, plus the English handover set (`HANDOVER.md`,
`README.md`, `CHANGELOG.md`, `docs/*.md`). Root-level do-file copies are
byte-identical to the `do_files/` copies.

This is a **mirror only**. Canvas submissions come from the team's OneDrive
project, never from GitHub. A GitHub commit is not evidence of a submission.

## Corrections to earlier versions of this page

An earlier version said the OneDrive project had 4 do-files, 3 logs, 5 tables
and 4 figures, and that "the single course checklist (Final Paper Checklist)"
was the only grading document. Both statements are now wrong:

- The current package has **5 do, 4 logs, 10 tables, 5 figures, 8 `data_raw`,
  10 `data_final`**.
- There are **two different documents**: `Econometric Files for Final Paper.pdf`
  (18 Nov, 100-point rubric, allowed file types) and
  `Final Paper Checklist_ ECON_V 490 003 2026W1 Seminar in Applied Economics.pdf`
  (11 Dec, 50-point paper rubric plus four Stata Files gates). See
  `docs/COURSE_REQUIREMENTS.md` §0.

## Latest verification (15 Nov 2026)

A full rerun from `data_raw` after the rubric-compliance edits produced: no
`r()` errors; logs of 737 / 354 / 858 / 1087 lines (conservative page estimates
14.7 / 7.3 / 17.9 / 22.6, all under 25); all four analysis CSVs and the 2019
summary CSV with unchanged md5; every headline coefficient, SE, p-value and N
in `3_results_261109.log` unchanged. The quadratic and winsorized checks moved
into `4_tables_261109.do` so neither log exceeds the page limit; their numbers
are now in `log_files/4_tables_261109.log`, and the older "2396 floats in
`3_results`" figure no longer applies.

New in this update: a `.docx` version of the 2019 summary table, a full 1/99
winsorized repeat of all five continuous variables, and one fixed 333-observation
sample across all four build-up columns. The Canvas comments draft was corrected
(295 input rows versus 272 estimation rows; two kinds of observation loss;
both country-clustered p-values).

All five data citations now carry the exact access date **14 November 2026**.
The Chinese-language handover previously uploaded to the root and to `docs/`
has been removed from this mirror; `HANDOVER.md` replaces it.

## Still only in OneDrive / local

- The actual Canvas upload and Canvas comments.
- The team's course PDFs and the ten article PDFs (only their filenames are
  listed in `docs/LITERATURE_SOURCES.md`).
- Working notes, changelogs in Chinese, and archived superseded do-files; these
  are deliberately kept out of the submission root and out of this mirror.
