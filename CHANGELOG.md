# Changelog

All entries describe the local OneDrive project; this repository only mirrors
them for teammate / AI handoff. Dates are local (MST).

## 2026-11-14 — full deliverables mirror and whitelist cleanup

Added to this mirror: `tables/` (5), `figures/` (4), `data_raw/` (8),
`data_final/` (10), plus `CHANGELOG.md`, `docs/HANDOVER_INDEX.md` and
`docs/AI_HANDOFF_NOTES.md`.

Do-file changes on this date, all verified by a full rerun from `data_raw`:

- Removed `stringcols(_all)` and `allstring` from the import commands. This is a
  float/double storage-precision change only: three rate columns differ by at
  most 1.03e-05 percentage points (Europe) and 7.08e-06 (OECD); every reported
  coefficient, standard error, p-value and sample size is unchanged. The only
  discrete side effect is that outcome winsorization now changes 4 instead of 5
  observations.
- Replaced `cond()`, `[_n-1]` subscripts and `egen max(cond())` with the
  course-taught `L1.` / `F1.` operators, `generate` + `replace`, and
  `egen min()` after `encode` + `xtset` + `sort`.
- Deleted four `destring` lines that had become no-ops (log printed
  "already numeric; no replace").
- Merged two verbatim-duplicated policy-history build blocks into one;
  `1_build_data_261109.do` went from 357 to 275 lines.

Verification: four data CSVs keep their md5 across the last three cleanups;
all 2396 floating-point numbers in `3_results_261109.log` are unchanged; no
`r()` errors; all three numbered logs close normally. Main results are still
+0.668 (cluster p=0.065), AR(1) PCSE +0.560 (p=0.007), DiD -0.626 (p=0.653),
OECD columns p=0.352 / 0.583 / 0.746. Conclusion: no robustly significant
policy effect / conditional association.

## 2026-11-14 — do-files refreshed (web upload)

Four numbered do-files uploaded, including the 275-line `1_build_data`.

## 2026-11-13 — repository created

Initial commit with four do-files and a short README.

## Standing notes

- Europe is the primary sample; OECD is an extension. The two are never pooled.
  See `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt` for the course-based rationale.
- The `weeks x pay_c` interaction is not in the main model. See
  `docs/ECON490_DECISION_2026-11-11.txt` and
  `docs/ECON490_PRECISION_STYLE_DECISION_261114.txt`.
- Historical significant p-values are retired and must not be reinstated.
- Default sync target is OneDrive only. This GitHub mirror is updated only on
  explicit instruction.
