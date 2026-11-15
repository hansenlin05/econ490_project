# Research decisions log

Last updated 14 November 2026. These decisions are frozen unless the team
writes a new decision. Each row names the evidence that supports it. For the
purpose of a handover, a "frozen" decision means: do not reopen it to chase a
better p-value, and do not reintroduce a retired result.

## 1. Scope and samples

| Decision | Rationale | Evidence |
|---|---|---|
| Europe (23 countries, 2006-2019, N=295) is the primary sample | Eurostat outcome is defined for ages 25-54 with a child under 6 and is comparable across the 23 countries | `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt`, `1_build_data_261109.do` |
| OECD (26 countries, 2000-2024, N=477) is an extension, reported separately | ILOSTAT household-series outcome has a different population definition; pooling would mix two outcome concepts | `3_results_261109.do` project-info block |
| Never swap primary/extension, never delete the `euro` variable | Group decision; instructor's "use OECD only" suggestion was verbal and has no written course requirement behind it | `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt` |
| All regressions include lagged log real GDP per capita | The assignment's "single properly specified regression" requires a convergence variable | `Econometric Files for Final Paper.pdf`, rubric p.3; `0_master_261109.do` global `controls` |

## 2. Specification and inference

| Decision | Rationale |
|---|---|
| Two-way country + year FE; heteroskedasticity and AR(1) serial-correlation correction; DiD and event study are supplements, not separate research designs | One coherent framework keeps the paper's "all work in do and log" gate satisfiable |
| Country-clustered SEs are the reference inference; AR(1) PCSE is a sensitivity check | `Preparing for Panel Data Analysis` says "always cluster your SEs"; with 23 clusters, below the note's rough 30-50 floor, even p=0.065 is optimistic |
| No `weeks x pay_c` interaction in the main model | Five reasons, in order: (i) an interaction is a different question — the coefficient on weeks becomes a conditional slope, not an average association; (ii) the data cost is prohibitive — joining Test7's `policy.dta` to the current panels leaves about 62 European and 71 OECD usable rows against 272 and 333; (iii) weeks, the replacement rate and their product are highly collinear; (iv) bad-control risk — leave length and replacement rate are both set by the same policy design; (v) `pay_c = pay_pct - 100` is never positive, so the interaction cannot identify the hypothesised direction. Test7 is kept as a reproducible artifact only |
| No quadratic term in the main model | The assignment permits non-linearity only if it improves fit and theory predicts it; both coefficients are insignificant (linear -1.299, squared +0.653, cluster p>0.05) and the fit does not improve. Reported as a robustness column in `tables/results_europe_robust_261109.docx` |
| Unwinsorized specification preferred | 1/99 winsorization changes only 4 outcome and 4 lagged-GDP observations; sign, magnitude and significance of the main coefficient are unchanged |
| Conclusion: no robustly significant policy effect, only a conditional association | Clustered p=0.065, DiD p=0.653, OECD p=0.352/0.583/0.746, all event-study leads/lags insignificant |

**Retired results, do not resurrect:** any historically significant p-value came
from (a) unclustered standard errors, (b) a GDP lag built inside the research
panel that dropped the first year and the pre-gap year, or (c) the research
direction retired on 21 October. The event-study k=+1 `+2.020 (p=0.034)` and
DiD `+0.265 (p=0.843)` from the broken lag version are void.

## 3. The 18 Nov rubric tables — including the non-European column

These choices were made against the hard rubric in
`Econometric Files for Final Paper.pdf`, not for statistical convenience.

| Choice | Decision | Why it meets the rubric |
|---|---|---|
| "All countries" column | 26-country OECD panel | The rubric asks for one regression with all countries plus two subsets. Team agreement |
| Representative year | 2019 | Single-year summary table, broad coverage, 23 non-missing rows on the main regressor (`tables/descriptive_2019_oecd_261109.csv` and `.docx`) |
| Subsets | European OECD 19 / non-European OECD 7 | Rubric p.3: "The choice of subsets must be a reasonable one ... dedicated by the economic theory that explains the hypothesis." European OECD members share supranational work-life-balance mandates; EU Directive (EU) 2019/1158 is listed in "Further Reading" of `PF2_5_Trends_in_leave_entitlements_around_childbirth.pdf` (https://eur-lex.europa.eu/eli/dir/2019/1158/oj/eng). No supranational mandate exists for the others, so the policy regime genuinely differs |
| Alternative subset rejected | Split by initial leave generosity | The median initial father-specific entitlement in the 26-country panel is 0, so all countries fell into one group (checked on the built CSV) |
| Keep the weak non-European column | **Keep it**, with an explicit warning | Deleting it would break the explicit three-column requirement (10 pts) and the overlapping subset histogram (6 pts), which uses the same split. The column has 6 country groups and 102 observations; its coefficient 23.576 is a small-sample artifact. The table note now states it must not be read as a policy effect, and the paper should base conclusions on the all-countries and European columns only |
| Controls in the subset table | Core controls (`lag_fatherweeks10 lag_lngdp lag_gdp_growth`), estimated once for all countries and once per subset | `leave_gdp` (SOCX) is sparse outside Europe; using the full control set would leave only 33 observations in the non-European column. The all-countries column is estimated on the full 443 observations (not on the 333-observation build-up sample) so that 341 + 102 adds back to 443 and the denominator closes |
| Estimation sample in the build-up table | All four columns fixed at the 333 observations with complete data on every variable | Previously the first three columns used 443 and only the fourth used 333 because `leave_gdp` is missing for 110 country-years. Comparing coefficients across columns then mixed the effect of an added control with a change of sample. `4_tables_261109.do` now builds one `same_sample` flag with `generate` then one `replace ... if missing()` per covariate and applies `if same_sample==1` to all four regressions. This is the stricter reading of "a series of regressions with one variable added at a time" (15 pts) |
| Histogram | Two overlapping histograms of `lag_fatherweeks10` by the same two subsets | Rubric item 10 asks for histograms for the subsets chosen above; `figures/histogram_leave_byregion_261109.png` |

**Net assessment.** The non-European column is the weakest part of the
submission, but removing it loses two explicit rubric items and breaks the
link between the table and the histogram. Keeping it with a clear caveat is the
higher-scoring and more honest choice. If the team later changes the subset
definition, BOTH `4_tables_261109.do` and `2_descriptive_261109.do` must change
together, and the whole chain must be rerun.

## 4. Code, data and logistics

| Decision | Rationale |
|---|---|
| Five numbered do-files, four numbered logs | Added regressions repeatedly pushed a single log past 25 pages. Workflow Guide 18 §18.2.2 permits a separate do-file for tables. On 15 Nov the quadratic specification, the full winsorized repeat and their robustness table moved from `3_results_261109.do` into `4_tables_261109.do`; conservative page estimates are now 14.7 / 7.3 / 17.9 / 22.6 |
| Full 1/99 winsorized repeat | Rubric item 7 says "with all variables winsorized". The repeat now winsorizes all five continuous variables; country and year dummies keep their coding. Measured changes: outcome 4, lagged leave weeks 0, lagged log GDP 4, lagged GDP growth 5, leave spending 5 observations. The main coefficient moves +0.560 -> +0.571 with the same sign and significance, so the unwinsorized model stays preferred |
| 2019 summary table as Word | Rubric p.4 requires "an Excel or Word document" while Canvas file types exclude `.xlsx`. `2_descriptive_261109.do` now exports a `.docx` alongside the existing `.xlsx` and `.csv`; the CSV remains the byte-for-byte content authority |
| Frozen snapshots in `data_raw/`, no live endpoint reads | A live-revision source would make the submitted log irreproducible. Measured failures: ILOSTAT HTTP 200 with 0 bytes for `.csv` and `.csv.gz`; Eurostat SDMX 3.0 response 12.7 MB and unfinished after 20 s. Official sites are cited as provenance only |
| `global proj_main "."` with **no** `cd` line | The team folder was renamed on 15 November; an absolute `cd` under `capture` fails silently and every later path resolves against the wrong directory. With a relative `proj_main`, the folder can be renamed, moved, or opened on another machine (macOS included) without touching the code. The cost is that the working directory must be set to the project root before running, which the header states |
| Only demonstrated Stata syntax; `L1.` / `F1.` after `encode` + `xtset` + `sort` | Course handout constraint; the permitted list, the banned list and the four documented exceptions are in `docs/CODE_CONVENTIONS.md` |
| Prefer whitelist compliance over byte-identical CSVs when only storage precision changes | Removing the two import options (`stringcols(_all)`, `allstring`) changed at most 1.03e-05 percentage points in three rate columns (Europe) and 7.08e-06 (OECD); every coefficient, standard error, p-value and sample size was unchanged, and the only discrete side effect was that outcome winsorization changed 4 instead of 5 observations. The rule that follows: if a change affects only float/double storage, take the fully permitted syntax |
| All five data sources "accessed 14 November 2026" | Team decision on the day the final citations were written; see `docs/DATA_CITATIONS.md` |
| OneDrive is the submission source; GitHub is a mirror | Standing instruction. GitHub is updated only on explicit request |

## 5. Still open (team decisions, not AI decisions)

- Written group freeze of the final model, including how to record the
  instructor's verbal "OECD only" suggestion.
- Whether to keep or drop the non-European column after seeing TA feedback
  (current answer: keep).
- Whether to ask the TA about the four documented command extensions
  (`egen min()/max()`, the three-step double-precision construction, the
  `dtable, continuous() statistic()` options used for the Word summary table, and
  `etable`'s `note()` used to carry the fixed-effects statement). All four are
  option-level and cannot change a coefficient; none is a banned add-on package.
  See `docs/CODE_CONVENTIONS.md` §2.
- Whether `format %10.0g` is acceptable in the final paper tables.
- Exact wording in the paper for the 23-cluster limitation.
