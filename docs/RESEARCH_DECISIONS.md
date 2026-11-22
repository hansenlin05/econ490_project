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
| OECD panel (23 countries, 2000-2024, 477 country-years; estimation sample 347) is the primary and only analysis | ILOSTAT household series is defined for parents of children under 6 in every OECD member; the outcome concept is one series, so no pooling question arises | `1_build_data_261109.do`, `econ490_all_261109.log` |
| Estimation sample is the complete-case flag `childcare_sample` | Every model variable must be observed; the flag is built with `generate`/`replace`/`missing()` and labelled | `1_build_data_261109.do` end block; `tabulate childcare_sample` in `econ490_all_261109.log` |
| `lag_socx_ecec` (prior-year public ECEC spending, % of GDP) is the main explanatory variable | Instructor's suggested direction; SOCX TP521 is the official OECD series for publicly funded early childhood education and care | OECD SOCX; citation block in `1_build_data_261109.do` |
| Every lag is built on its own full annual series before any merge | A lag built after the merge disappears whenever the previous year's outcome is missing, which lets outcome availability decide the estimation sample. Applies to GDP, leave weeks, leave spending and ECEC spending alike | `1_build_data_261109.do` lag blocks |
| `lag_fatherweeks10` stays in the model as a control | Father-specific leave is the strongest competing policy explanation for the same outcome; dropping it would confound the childcare association | `0_master_261109.do` global `controls` |
| `lag_motherweeks10` added as a control (17 November) | Sultana raised the omitted-variable concern that father leave and mother leave are distinct variables. Verified on the frozen panel first: the estimation sample stays at 347 and the childcare coefficient moves only from −0.4734 to −0.4721. The source column sits in the same PF2.5 workbook as the father series, so no new citation is needed | `1_build_data_261109.do` leave-weeks block; `3_results_261109.do` |
| All regressions include `lag_lngdp` as the sole GDP control | It controls economic development level. GDP growth was removed at the user’s request. The employment-gap regression is not a Solow growth equation or an employment-gap convergence test | `1_build_data_261109.do`; `3_results_261109.do` |

## 2. Specification and inference

The user's 17 November instruction sets the active workflow to Test7:
`xtreg, fe`, `testparm`, `xttest3`, `xtserial`, then
`xtpcse ..., het corr(ar1)`. VCE options and the separate robust comparison
are excluded from the current do-files. Earlier documentation of those
options is historical and does not override this instruction.

| Decision | Rationale |
|---|---|
| PCSE with panel-specific heteroskedasticity and common AR(1) is the main estimator | This is the Test7 form requested by the user. Childcare is −0.472, SE 0.135, p = 0.0005 |
| Country and year effects and country-specific trends remain | This preserves the existing mean model. Removing only the trends gives +0.092, SE 0.148, p = 0.5357. The negative association is conditional on the trend specification |
| No quadratic term in the main model | The PCSE quadratic test has p = 0.5702 and the term is excluded |
| Observed data preferred | Full 1/99 winsorization of all six continuous variables gives −0.479, SE 0.133, p < 0.001 |
| Diagnostics precede PCSE | `testparm i.year` p = 0.1342, country-effects F(22,276) = 56.83 with p < 0.001 in the `xtreg` output, `xttest3` p < 0.001 and `xtserial` p = 0.0006 |
| Log transformations match the build code | Outcome and leave spending use ln(x), childcare and both leave-week controls use ln(1+x), lagged GDP per capita is logged and is the only GDP control |
| Spending magnitudes use the local elasticity | beta*x/(1+x) is about −0.17 at mean spending of 0.538 percent of GDP. The coefficient itself is an elasticity with respect to 1+x |
| Report association with limitations | PCSE relies on the specified error structure. The unbalanced sample and dependence on country trends remain relevant. No causal claim is made |

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
| Keep the weak "other OECD" column | **Keep it**, with an explicit warning | Deleting it would break the explicit three-column requirement (10 pts) and the overlapping subset histogram (6 pts), which uses the same split. The column has 38 observations and its coefficient (−0.159, p = 0.538 under PCSE) is not readable as a policy effect; the table note states this, and the paper bases conclusions on the all-countries and EU columns |
| Build-up table sample | All four columns on the same 347-observation estimation sample | Comparing coefficients across columns then reads purely as the effect of adding controls, the stricter reading of "a series of regressions with one variable added at a time" (15 pts) |
| Histograms | Two overlapping histograms of `lag_socx_ecec` by the same two subsets | Rubric item 10 asks for the subsets chosen above; `figures/histogram_childcare_byregion_261109.png` |
| Scatter | Spending versus the employment gap with a linear fit, estimation sample | Rubric item 3 asks for a graph that illustrates the story; `figures/scatter_gap_childcare_261109.png` |
| Fixed-effects rows in the Word tables | `etable` has no fixed-effects row option, so the exported tables get "Year FE yes / Country FE yes" rows in post-export Word editing | The rubric itself says the exported table "will need to be edited after it has been exported" |

## 4. Code, data and logistics

| Decision | Rationale |
|---|---|
| Five do-files (one master + four numbered), one combined log | Workflow Guide 18 §18.2.2 permits a separate do-file for tables. The 18 Nov instruction prefers a single log containing every do-file's output; the master opens `econ490_all_261109.log`, all numbered do-files write into it, and `quietly` on intermediate regressions keeps it under the 35-page limit confirmed on 16 November 2026 |
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
| OneDrive is the submission source; GitHub is the public reproducibility record | Standing instruction. Graded files go to Canvas from OneDrive; this repository is updated as a public record when the team asks |

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
