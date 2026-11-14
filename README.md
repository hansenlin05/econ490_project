# ECON 490 Team Project

Father-specific paid leave and the gender employment gap.

Primary sample: 23 European OECD countries, 2006-2019 (N=295).
Extension: 26 ILO countries, 2000-2024 (N=477). The two panels are never pooled.

## Reproduce

Run `0_master_261109.do` in Stata 17+. It sets all paths, rebuilds both locked
panels from `data_raw`, and calls the three numbered do-files in order. The
OneDrive project folder holds the raw sources, the exported .docx/.xlsx tables
and the .png figures; those binary deliverables are not mirrored here.

## Layout

- Root: the four numbered do-files (`0_master`, `1_build_data`, `2_descriptive`, `3_results`).
- `log_files/`: the three numbered logs, each created by its do-file.
- `data_final/`: CSV copies of the two locked panels and the two analysis files.
- `docs/`: handover, sample-scope note, teammate report, command whitelists and working notes.

## Course files

The 18 Nov submission is one set of do, log, data and image files (Course
Outline p.14). The only checklist is the Final Paper Checklist; its Stata Files
section requires uploaded do/log files, logs created by the do-file, fully
annotated do-files, and all reported work present in do and log.

See `docs/SYNC_STATUS_2026-11-14.md` for the 14 Nov 2026 sync state.
