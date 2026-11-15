# Sync status - 14 Nov 2026

## Current state

The root do-files are the 14 Nov versions (275-line `1_build_data_261109.do`).
All do-file commands are in the course whitelist: the two import options,
`cond()`, panel subscripts, no-op `destring` lines and the duplicated
policy-build block were removed. A full rerun keeps all 2396 numbers in
`3_results_261109.log` unchanged apart from float/double storage precision in
three rate columns; all reported coefficients, standard errors, p-values and
sample sizes are identical.

As of the second 14 Nov sync, do-file derivatives ARE mirrored here:
`tables/` (5), `figures/` (4), `data_raw/` (8), `data_final/` (10) and the
three numbered logs. This makes the repository a complete working mirror for
teammate and AI handoff. It is still a mirror only: Canvas submissions come
from the OneDrive project, not from GitHub.

## Submission state

The OneDrive project has 4 do-files, 3 numbered logs, 5 tables, 4 PNG figures,
8 `data_raw` and 10 `data_final` items. Against the single course checklist
(Final Paper Checklist), the Stata Files requirements are met: do/log uploaded
by the deadline (pending the manual Canvas upload), logs created by do-files,
fully annotated sections, and all reported work present in do and log.


## 20:55 update (commit 9598fc6)

The 18 Nov Canvas assignment rubric is now covered in code: AER data
citations, 2019 single-year summary table, build-up regression table,
three-column subset table, overlapping histograms, and the required
specification comments. A fifth numbered do-file (4_tables) and a fourth
log keep every log under the 25-page limit. Final package: 5 do, 4 logs,
9 tables, 5 figures, 8 data_raw, 10 data_final. All 2396 original result
floats and all four analysis CSV md5 are unchanged.

Live official-endpoint imports from PR #1 were reverted in favour of frozen
snapshots; see README.md and CHANGELOG.md for the measured reasons.
