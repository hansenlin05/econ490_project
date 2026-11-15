# Submission status — 18 Nov 2026 Econometric Files

Last updated 14 November 2026, evening. This is the actionable checklist. Code
work is finished and verified; everything left is a manual team action.

## 1. Done and verified

- Five numbered do-files, four numbered logs, nine tables, five PNG figures,
  eight `data_raw` inputs, ten `data_final` outputs.
- Full rerun from `data_raw` on 14 Nov: no `r()` errors; all four analysis CSVs
  and the summary-table CSV keep their md5; all 2396 result floats in
  `3_results_261109.log` unchanged; logs 739 / 330 / 1113 / 560 lines (about
  15 / 7 / 22 / 11 pages, each under the 25-page limit).
- All five data sources cited in the do-file with the exact access date
  14 November 2026 (see `docs/DATA_CITATIONS.md`).
- 2019 single-year summary table, restricted to rows with the main regressor:
  `tables/descriptive_2019_oecd_261109.csv` (23 observations).
- Build-up table (main regressor first, one variable added per column):
  `tables/results_buildup_261109.docx`.
- Three-column subset table: `tables/results_subsets_261109.docx`.
- Overlapping two-subset histogram: `figures/histogram_leave_byregion_261109.png`.
- Comments in the do-files about unmatched merges, the preferred unwinsorized
  specification, and why the non-linear term is not used.

## 2. Manual actions still required

| # | Action | Owner | Why |
|---|---|---|---|
| 1 | Confirm the nine directories are synced in the OneDrive client | Hansen | Canvas submission comes from OneDrive, not GitHub |
| 2 | Upload to Canvas: 5 `.do`, 4 `.log`, `.csv` copies from `data_raw/` and `data_final/`, the `.csv`/`.docx` tables, and 5 `.png` figures | Team | Canvas accepts only `log, csv, png, do, docx, jpeg`; do **not** upload `.xlsx` or `.dta` |
| 3 | Paste the Canvas comments in §3 below | Team | 5 pts for stating whether results support the hypothesis; part of the 8 merge points |
| 4 | Edit the exported Word tables: add explicit "Year FE: yes" / "Country FE: yes" rows, check stars, SEs, N, headings | Sultana | The assignment says the exported table "will need to be edited after it has been exported"; `etable` cannot add those rows with permitted commands |
| 5 | Check whether the Canvas assignment page has an extra upload field or naming rule | Team | Not visible in the exported PDF |
| 6 | Fill `literature/` with the ten article PDFs and `paper/` with the draft | Sultana | Both folders are still empty; 11 Dec paper needs ≥8 peer-reviewed economics articles |
| 7 | Write the group's written freeze of the final model, including how the instructor's verbal "OECD only" suggestion is recorded | Team | Prevents another round of specification drift |
| 8 | Decide the paper wording for the 23-cluster limitation and whether to ask the TA about two minor command extensions | Team | See `docs/RESEARCH_DECISIONS.md` §5 |
| 9 | Confirm 2 Dec and 7 Dec poster requirements; 11 Dec final paper deadline | Team | `ECON 490 Course Outline.pdf` p.14 |

A stale second copy of the project exists in a personal OneDrive folder with
only 4 do-files, 3 logs, 5 tables and 4 figures plus old notes in its root.
It is **not** the submission folder. The authoritative folder is the team
`... - 2_Team/econ490_project` one with nine clean directories.

## 3. Ready-to-paste Canvas comments (English)

> Our results do not support the hypothesis. In the primary sample of 23
> European OECD countries (2006-2019, N=295), the coefficient on lagged
> father-specific paid leave is +0.668 (country-clustered SE 0.344, p=0.065)
> in the two-way fixed effects specification: wrong-signed relative to H1
> and not significant at 5 percent once standard errors are clustered by
> country. The DiD estimate is -0.626 (p=0.653), the event-study leads and
> lags are all insignificant, and the OECD extension columns give
> p=0.352 / 0.583 / 0.746. We therefore report no robust evidence of a
> policy effect, only a conditional association. Course guidance in
> "Preparing for Panel Data Analysis" is to always cluster standard errors,
> and with 23 clusters our inference is itself optimistic.
>
> Merge note: all merges are performed inside `1_build_data_261109.do`.
> Unmatched observations are not errors. The Eurostat source contains
> country groups outside the 23-country OECD sample (568 rows dropped), and
> the OECD policy workbook contains country-years outside the 2006-2019
> research window or without verified entitlement values (631 rows from the
> using file in the Europe merge; 855/430 in the OECD merge). These are
> excluded by design. WDI GDP controls cover all 295 European and all 477
> OECD country-years. In the OECD extension, public leave spending
> (`leave_gdp`) is sparse, so the three reported columns use 333 / 333 / 443
> observations; the third column drops that covariate to show the loss.
>
> Subset note: the three-column subset table splits the 26 OECD countries
> into 19 European and 7 non-European members, following the difference in
> supranational leave mandates. The non-European column has only 6 country
> groups and 102 observations and is shown for the required comparison only;
> its coefficient must not be read as a policy effect.
>
> Preferred specification: the unwinsorized AR(1) PCSE model with country
> and year fixed effects. The 1/99 winsorized repetition changes 4 outcome
> observations and 4 lagged-GDP observations and does not alter the sign,
> magnitude or significance of the main coefficient, so we do not prefer it.
> The quadratic term is insignificant and does not improve fit, so it is
> reported only as robustness, consistent with the assignment instruction
> to add non-linearity only when it improves the model and has a theoretical
> justification.

## 4. After 18 Nov

Sultana drafts the 11 Dec paper from `docs/COURSE_REQUIREMENTS.md` §3,
`docs/LITERATURE_SOURCES.md`, and the four numbered logs. Any number in the
paper must be traceable to a log, and any new empirical work must be added to a
do-file and rerun so the log contains it.
