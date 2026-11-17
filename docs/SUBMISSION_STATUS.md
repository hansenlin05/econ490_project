# 18 Nov submission notes — OECD childcare chain

Last updated 16 November 2026. This is the actionable checklist. Code work is
finished and verified; everything left is a manual team action.

## 1. Done and verified

- Five numbered do-files, four numbered logs, six tables (four Word tables
  plus the 2019 summary as `.csv` and `.xlsx`), two PNG figures, eleven
  `data_raw` inputs, seven `data_final` outputs.
- Full rerun from `data_raw` on 16 Nov: no `r()` errors anywhere. Logs are
  586 / 423 / 911 / 749 lines, roughly 12.2 / 8.8 / 19.0 / 15.6 pages with
  80-character wrapping — all under the 35-page limit the instructor
  confirmed on 16 November 2026.
- All five data sources cited in the do-file citation block
  (see `docs/DATA_CITATIONS.md`).
- 2019 single-year summary table, restricted to rows with the main regressor
  observed (23 rows; `leave_gdp` has 20), exported as `.csv` and `.xlsx`.
- Five-column build-up table with every column on the same 347-observation
  estimation sample: `tables/results_childcare_buildup_261109.docx`.
- Three-column subset table (all countries 347 / EU-target group 309 / other
  OECD 38): `tables/results_childcare_subsets_261109.docx`.
- Full 1/99 winsorized repeat of all six continuous model variables; the main
  coefficient stays at −0.581 with the same sign and significance:
  `tables/results_childcare_winsor_261109.docx`.
- Overlapping two-subset histogram of the main regressor:
  `figures/histogram_childcare_byregion_261109.png`; scatter with linear fit:
  `figures/scatter_gap_childcare_261109.png`.
- `testparm` tests for the year effects (p = 0.2904) and the country effects
  (p < 0.001) in `3_results_261109.log`.
- Comments in the do-files about unmatched merges, the preferred
  unwinsorized specification, and why the non-linear term is not used.
- `testparm lag_socx_ecec` lines print the exact p-values behind the quoted
  numbers in every column, and the PCSE column prints chi2(1) = 12.52,
  p = 0.0004.

## 2. Manual actions still required

| # | Action | Owner | Why |
|---|---|---|---|
| 1 | Confirm the nine directories are synced in the OneDrive client | Hansen | Canvas submission comes from OneDrive, not GitHub |
| 2 | Upload to Canvas: 5 `.do`, 4 `.log`, `.csv` copies from `data_raw/` and `data_final/`, the table files, and 2 `.png` figures | Team | Canvas accepts only `log, csv, png, do, docx, jpeg`; try the `.xlsx` summary table first and fall back to its `.csv` if rejected |
| 3 | Paste the Canvas comments in §3 below | Team | 5 pts for stating whether results support the hypothesis; part of the 8 merge points |
| 4 | Edit the exported Word tables: add explicit "Year FE: yes" / "Country FE: yes" rows, check stars, SEs, N, headings | Sultana | The assignment says the exported table "will need to be edited after it has been exported"; `etable` cannot add those rows with permitted commands |
| 5 | Open each numbered log in Word with the final font and margins and confirm the printed page count | Team | The page estimates above are conservative calculations, not a rendering |
| 6 | Check whether the Canvas assignment page has an extra upload field or naming rule, and confirm the live due date | Team | The exported PDF header says "Due No Due Date" and its body says "March 23rd"; Course Outline p.14 says 18 Nov |
| 7 | Fill `literature/` with the article PDFs and `paper/` with the draft | Sultana | Both folders are still empty; 11 Dec paper needs ≥8 peer-reviewed economics articles |
| 8 | Confirm 2 Dec and 7 Dec poster requirements; 11 Dec final paper deadline | Team | `ECON 490 Course Outline.pdf` p.14 |

## 3. Ready-to-paste Canvas comments (English)

> Our results support the hypothesis. The primary panel covers 23 OECD
> countries over 2000-2024 (477 country-year observations in the employment
> panel); the regressions use the 347 observations with complete data on every
> model variable. The main explanatory variable is the prior-year share of GDP
> that a country spends on publicly funded early childhood education and care.
> Following the course's discussion of logged growth regressions, the outcome
> and every nonnegative continuous variable are in logs, so the coefficients
> are elasticities. The spending coefficient is negative and statistically
> significant in every specification: -0.582 with year and country fixed
> effects, country-specific linear trends and standard errors clustered by
> country, as the course lecture note requires (SE 0.172, p = 0.003); -0.582
> with unclustered robust standard errors (p < 0.001); -0.477 under
> panel-corrected standard errors with a common AR(1) process (p < 0.001); and
> -0.581 in the full 1/99 winsorized repetition (p = 0.002). A 1 percent increase in prior-year ECEC
> spending is therefore associated with a 0.582 percent smaller
> male-minus-female employment gap among parents of young children, read as an
> elasticity from the log specification. Spending enters as ln(1 + x), so at
> the sample mean of 0.538 percent of GDP the effect of a 1 percent relative
> increase is about 0.20 percent (−0.582 × 0.538/1.538). We report this as a
> conditional association across countries and years, not as proof of a causal
> effect.
>
> Merge note: all merges are performed inside `1_build_data_261109.do`. Two
> distinct kinds of observation loss occur and neither is an error. (i) Rows
> that do not match: the OECD SOCX spending series contains 582 country-years
> outside the employment panel (spending history for countries and years the
> ILOSTAT outcome series does not cover), and 50 employment-panel country-years
> have no SOCX spending record; both groups are excluded after harmonising
> country codes, and the merge output printed in the log shows the split
> (427 matched, 50 master-only, 582 using-only). (ii) Rows that do match but
> still leave the regression: requiring a numeric lagged spending value, the
> outcome, and all controls (lagged father-specific leave weeks, lagged log
> GDP per capita, lagged GDP growth, and public maternity and parental leave
> spending) reduces the panel from 477 to the 347 complete cases marked by
> `childcare_sample`. Every lag in the build is computed on its own full
> annual series before any merge, so a country-year is never lost merely
> because the previous year's employment observation is missing.
>
> Subset note: the three-column subset table splits the sample into the EU
> countries covered by the EU childcare targets (the Barcelona targets and the
> 2022 Council Recommendation on early childhood education and care) and the
> other OECD members, because a supranational ECEC commitment exists only on
> the EU side. The EU column has 309 observations and the other-OECD column
> 38; the smaller column is shown for the required comparison only and its
> coefficient must not be read as a policy effect.
>
> Diagnostics: a modified Wald test rejects groupwise homoskedasticity
> (p < 0.001) and Wooldridge's test rejects no serial correlation (p = 0.0009),
> which is why the main column clusters standard errors by country, as the
> lecture note "Preparing for Panel Data Analysis" requires, with unclustered
> robust SEs and panel-corrected AR(1) SEs as sensitivity checks. With 23
> country clusters the note's rough floor of 30-50 is not met, so clustered
> inference may be optimistic and we disclose this. `testparm` does not reject the
> year effects (p = 0.2904) and rejects no country effects (p < 0.001). Year
> effects are retained by design because the assignment requires them. The
> quadratic spending term is insignificant (p = 0.8891) and has no theoretical
> basis here, so it is assessed in the log but not added, consistent with the
> instruction to add non-linearity only when it improves the model and has a
> theoretical justification.
>
> Preferred specification: the unwinsorized model. The 1/99 winsorized
> repetition covers all six continuous model variables and keeps the main
> coefficient at -0.581 with clustered SEs (p = 0.002), so we
> keep the observed-data specification and use the winsorized column as the
> required robustness repeat.
>
> File note: the 2019 single-year summary table is supplied in Excel form;
> a `.csv` copy with identical content is included in case Canvas rejects the
> Excel format.

## 4. After 18 Nov

Sultana drafts the 11 Dec paper from `docs/COURSE_REQUIREMENTS.md` §3,
`docs/LITERATURE_SOURCES.md`, and the four numbered logs. Any number in the
paper must be traceable to a log, and any new empirical work must be added to
a do-file and rerun so the log contains it.
