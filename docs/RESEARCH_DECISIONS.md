# Research decisions log

Last updated 16 November 2026. These decisions are frozen unless the team
writes a new decision. Each row names the evidence that supports it. For the
purpose of a handover, a "frozen" decision means: do not reopen it to chase a
better p-value, and do not reintroduce a retired result.

## 0. Direction change of 16 November 2026

The team retired the earlier Europe-primary father-specific-leave design and
adopted the OECD public-childcare panel as the primary and only analysis. The
instructor had suggested focusing on public childcare spending and the
winsorized repeat; the retired father-leave chain remains reproducible from
the git history but none of its samples, coefficients or p-values may be
quoted in the submission. Every decision below belongs to the current chain.

## 1. Scope and sample

| Decision | Rationale | Evidence |
|---|---|---|
| OECD panel (23 countries, 2000-2024, 477 country-years; estimation sample 347) is the primary and only analysis | ILOSTAT household series is defined for parents of children under 6 in every OECD member; the outcome concept is one series, so no pooling question arises | `1_build_data_261109.do`, `3_results_261109.log` |
| Estimation sample is the complete-case flag `childcare_sample` | Every model variable must be observed; the flag is built with `generate`/`replace`/`missing()` and labelled | `1_build_data_261109.do` end block; `tabulate childcare_sample` in `1_build_data_261109.log` |
| `lag_socx_ecec` (prior-year public ECEC spending, % of GDP) is the main explanatory variable | Instructor's suggested direction; SOCX TP521 is the official OECD series for publicly funded early childhood education and care | OECD SOCX; citation block in `1_build_data_261109.do` |
| Every lag is built on its own full annual series before any merge | A lag built after the merge disappears whenever the previous year's outcome is missing, which lets outcome availability decide the estimation sample. Applies to GDP, leave weeks, leave spending and ECEC spending alike | `1_build_data_261109.do` lag blocks |
| `lag_fatherweeks10` stays in the model as a control | Father-specific leave is the strongest competing policy explanation for the same outcome; dropping it would confound the childcare association | `0_master_261109.do` global `controls` |
| All regressions include `lag_lngdp` | The assignment's "single properly specified regression" requires a convergence variable | `Econometric Files for Final Paper.pdf`, rubric p.3; `0_master_261109.do` global `controls` |

## 2. Specification and inference

| Decision | Rationale |
|---|---|
| LSDV `regress` with `i.year i.country_id c.year_centered#i.country_id` and standard errors clustered by country is the main specification | The lecture note `Preparing for Panel Data Analysis` states "Always cluster your SEs" and demonstrates `xtreg y x, fe vce(cluster id)` and `reg y x1 x2, vce(cluster id)` verbatim; the do-files use the same spelling with `country_id` as the panel unit. The LSDV form also makes the country-effect test possible, which `xtreg, fe` does not (`testparm i.country_id` aborts there). With 23 clusters the note's rough floor of 30-50 is not met, so clustered inference must be read as optimistic and this limitation is disclosed in the paper |
| Unclustered heteroskedasticity-robust SEs and PCSE with common AR(1) are the sensitivity checks | `xttest3` rejects groupwise homoskedasticity (chi2(23) = 5332.23, p < 0.001) and `xtserial` rejects no serial correlation (p = 0.0009), so both corrections matter. The main coefficient is −0.582 with clustered SEs (p = 0.003), −0.582 with robust SEs (p < 0.001), and −0.477 under PCSE AR(1) (p < 0.001) |
| Country-specific linear trends are part of the main specification, and the flip without them is reported as a core finding | Justification: the Barcelona targets are progressive goals, so countries started from different childcare systems and expanded along different institutional paths; a common slope would conflate that drift with the spending response, and the same institutional-divergence logic is what defines the eu_childcare subset. Reported honestly: keeping both fixed effects and dropping only the trends moves the coefficient to +0.131 (clustered SE 0.199, p = 0.518), so the negative association is identified relative to each country's own trajectory rather than unconditionally. The paper and the Canvas comment state this; the comparison column is in the main table |
| No quadratic term in the main model | The assignment permits non-linearity only if it improves fit and theory predicts it; the squared term is insignificant (F(1, 22) = 0.02, p = 0.8891) and no theory is offered for curvature in this range |
| Unwinsorized specification preferred | The full 1/99 winsorized repeat of all six continuous model variables keeps the main coefficient at −0.581 with clustered SEs (p = 0.002); the do-file comment states the preference, as rubric item 7 requires |
| Conclusion: a statistically significant negative conditional association, conditional on the country-specific trends | The main coefficient is negative and significant with clustered SEs (p = 0.003), unclustered robust SEs (p < 0.001), PCSE AR(1) (p < 0.001), and winsorized (p = 0.002); the EU subset is −0.566 (p = 0.005). Dropping the country trends removes the association (+0.131, p = 0.518), and this is disclosed wherever the headline is quoted. It is an association across countries and years, not a causal effect; the paper must say so |
| Year and country effects are tested, not assumed | `testparm i.year` F(22, 276) = 1.15, p = 0.2904; `testparm i.country_id` in the LSDV form F(19, 22) = 6.7e+06, p < 0.001, both printed in `3_results_261109.log` |
| The fully logged specification is the headline | The COMET quiz on Mankiw, Romer and Weil (1992) notes that the long-run growth regression "uses logged versions of the dependent and explanatory variables"; the instructor raised the point again on 16 November 2026. In `1_build_data_261109.do` the outcome and leave spending use `ln(x)`, ECEC spending uses `ln(1+x)`, and father leave uses `ln(1+lagged weeks/10)`. GDP per capita is logged. GDP growth is the WDI annual percentage growth series and stays in levels. The childcare coefficient is an elasticity with respect to `1+x`, with local spending elasticity `beta*x/(1+x)` (about -0.20 at the sample mean). The headline column gives the transformed-variable association (`ln_spending` −0.582, clustered SE 0.172, p = 0.003; testparm F(1, 22) = 11.39). The level specification is retained as a comparison column (−9.456, clustered p = 0.009). The change was adopted on 16 November 2026; the cost of rewriting code, comments, tables and text was not treated as a reason to keep the weaker interpretation. |

**Retired results, do not resurrect:** every coefficient and p-value of the
retired father-leave chain (Europe N=292/295, OECD extension N=348/463, DiD,
event study, Test7 interaction). They came from a different research question
and a different panel, and several of their significant readings were traced
to unclustered standard errors or a broken lag construction.

## 3. The 18 Nov rubric tables and figures

These choices were made against the hard rubric in
`Econometric Files for Final Paper.pdf`, not for statistical convenience.

| Choice | Decision | Why it meets the rubric |
|---|---|---|
| Representative year | 2019 | Single-year summary table; 23 country-years have the main regressor observed; `leave_gdp` has 20 (`tables/descriptive_2019_oecd_childcare_261109.csv` and `.xlsx`) |
| Subsets | EU childcare-targets group (19 members) vs other OECD members (4) | Rubric p.3: "The choice of subsets must be a reasonable one ... dedicated by the economic theory that explains the hypothesis." The EU's Barcelona targets and the 2022 Council Recommendation link ECEC provision to parental employment (https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)); no comparable supranational target exists outside the EU |
| Keep the weak "other OECD" column | **Keep it**, with an explicit warning | Deleting it would break the explicit three-column requirement (10 pts) and the overlapping subset histogram (6 pts), which uses the same split. The column has 38 observations and its coefficient (−0.327, p = 0.149 clustered) is not readable as a policy effect; the table note states this, and the paper bases conclusions on the all-countries and EU columns |
| Build-up table sample | All five columns on the same 347-observation estimation sample | Comparing coefficients across columns then reads purely as the effect of adding controls, the stricter reading of "a series of regressions with one variable added at a time" (15 pts) |
| Histograms | Two overlapping histograms of `lag_socx_ecec` by the same two subsets | Rubric item 10 asks for the subsets chosen above; `figures/histogram_childcare_byregion_261109.png` |
| Scatter | Spending versus the employment gap with a linear fit, estimation sample | Rubric item 3 asks for a graph that illustrates the story; `figures/scatter_gap_childcare_261109.png` |
| Fixed-effects rows in the Word tables | `etable` has no fixed-effects row option, so the exported tables get "Year FE yes / Country FE yes" rows in post-export Word editing | The rubric itself says the exported table "will need to be edited after it has been exported" |

## 4. Code, data and logistics

| Decision | Rationale |
|---|---|
| Five numbered do-files, four numbered logs | Workflow Guide 18 §18.2.2 permits a separate do-file for tables; the fourth do-file keeps every log under the 35-page limit the instructor confirmed on 16 November 2026 (conservative estimates 12.2 / 8.8 / 19.0 / 15.6 pages) |
| Leave-week corrections as literal numeric replaces | The workbook stores weeks as text with occasional slash-separated options; values are parsed with `real()` and every year correction is a hardcoded literal taken from the recorded next year. The `string()`/`F1.snapshot` construction was removed on 16 November 2026 as it had no first-hand course source; the literal version is bit-identical in the built panel |
| `real()` is a documented exception | The slash-text column cannot be parsed without it; `destring` is not course material either. Documented in `docs/CODE_CONVENTIONS.md` |
| Full 1/99 winsorized repeat | Rubric item 7 says "with all variables winsorized"; the repeat covers all six continuous model variables via `summarize, detail` percentiles plus `generate`/`replace` |
| 2019 summary table as `.csv` + `.xlsx` | Rubric p.4 requires "an Excel or Word document" while Canvas file types do not list `.xlsx`; the CSV is the upload-safe fallback and the content authority |
| Frozen snapshots in `data_raw/`, no live endpoint reads | A live-revision source would make the submitted log irreproducible. Measured failures: ILOSTAT HTTP 200 with 0 bytes for `.csv` and `.csv.gz`; Eurostat SDMX 3.0 response unfinished after 20 s. Official sites are cited as provenance only |
| Leave spending comes from the frozen SOCX TP512 extract | `data_raw/oecd_socx_tp512_leave.csv` was adopted on 16 November 2026 to align TP512 with the TP521 childcare release. The donor intermediate is no longer read. The 347-observation estimation sample is unchanged |
| One editable `capture noisily cd "<path>"` line in the master | The course index shows this verbatim (module 02 prefix commands), so it is the fully permitted form of the Workflow 18 directory block. A relative-path design without `cd` was tried on 15 November and reverted the same evening: running the master from any other working directory failed with silent "file not found" errors. An editable path is the course's own expectation |
| Only demonstrated Stata syntax; `L1.` / `F1.` after `encode` + `xtset` + `sort` | Course handout constraint; the permitted list, the banned list and the documented exceptions are in `docs/CODE_CONVENTIONS.md` |
| Prefer whitelist compliance over byte-identical CSVs when only storage precision changes | The `string()` removal is the latest application: the built panel's values were unchanged bit-for-bit, so every coefficient, standard error, p-value and sample size was unchanged |
| Access dates: SOCX 16 November 2026, the other three sources 14 November 2026 | Kept exactly as written in the do-file citation block; see `docs/DATA_CITATIONS.md` |
| OneDrive is the submission source; GitHub is a mirror | Standing instruction. GitHub is updated only on explicit request |

## 5. Still open (team decisions, not yet settled)

- Whether Canvas accepts the `.xlsx` summary table; if it rejects the file,
  upload the `.csv` instead.
- Final check of the four post-export formatted Word tables. Headings and
  year FE, country FE, and trend rows are complete. Repeat the formatting if
  Stata is rerun because raw exports overwrite it.
- Whether to ask the TA about the three documented command extensions
  (`egen min()/max()`, `real()` for the slash-text column, and instructor-
  approved `quietly summarize` for percentile cut-offs). None can change a
  coefficient; none is a banned add-on package. See `docs/CODE_CONVENTIONS.md` §2.
- Whether `format %10.0g` is acceptable in the final paper tables.
- Exact wording in the paper for the association-versus-causation caveat.
