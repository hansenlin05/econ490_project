# Pitfalls and corrections — what went wrong and what replaced it

Last updated 14 November 2026. Read this before proposing a "fix": several
plausible-looking fixes have already been tried and rejected. Every row names
the file or log where the correction can be verified.

## A. Wrong research conclusions

| Pitfall | Correction | Evidence |
|---|---|---|
| "The European subsample gives more meaningful p-values" | False. The Test7 subsample condition is high-income countries and includes Chile and Colombia, not a Europe-only group | `OECD_WEEK_LENGTH_TEST7.do`, its original log |
| Earlier wage-gap / 17-industry / 26-European-country significant results | Retired research direction (21 Oct). Do not reuse any coefficient | `START_HERE_Research_Context.txt` |
| "Europe-only p-values are significant, so roll back the specification" | All historically significant p-values came from unclustered SEs, a broken lag, or the retired direction. Rolling back for stars conflicts with academic integrity and the checklist | `log_files/3_results_261109.log` |
| "Only one course checklist exists, so there is no separate 18 Nov requirement" | Over-inference. The Course Outline's "posted checklist" is the Canvas assignment page `Econometric Files for Final Paper.pdf`, which is a different document from `Final Paper Checklist_ ... .pdf` | Both PDFs; `docs/COURSE_REQUIREMENTS.md` §0 |
| "March 23rd is the deadline" in the Canvas PDF | Stale template from an earlier term; header says "Due No Due Date". Deadline is 18 Nov 2026 per `ECON 490 Course Outline.pdf` p.14 | Both PDFs |

## B. Data-construction bugs

| Pitfall | Correction |
|---|---|
| A newly uploaded "new version" of Test7 was assumed to be different | md5 and line-by-line diff proved it was byte-identical to the 5 Nov handoff. Always compare content, not filename or timestamp |
| GDP lag computed inside the research panel | Dropped the first year and the year before each gap. Now the lag is taken on the full annual WDI series before merging: Europe 295/295, OECD 477/477. The old event-study k=+1 `+2.020 (p=0.034)` and DiD `+0.265 (p=0.843)` are void |
| Winsorization reported as "handled" | All four `replace` commands returned `0 real changes made`. Current chain uses `generate` -> `recast double` -> `replace` and prints the real change counts (4 outcome rows, 4 lagged-GDP rows) |
| `generate double` used for precision | Not in the permitted command vocabulary; the three-step `generate` / `recast double` / `replace` construction preserves precision with allowed syntax |
| Four `destring` commands were no-ops | Log printed "already numeric; no replace"; removed |
| Two verbatim-duplicated policy-history build blocks | Merged into one; `1_build_data_261109.do` shrank from 357 to 275 lines |
| Removing `stringcols(_all)` / `allstring` changed CSV md5 | Only float/double storage precision (max 1.03e-05 pp Europe, 7.08e-06 pp OECD). All coefficients, SEs, p-values and N unchanged. Team rule: prefer full whitelist compliance over byte-identical CSVs when only precision changes |
| Assuming dropping `leave_gdp` restores OECD N=477 | It does not: N stays 443 because `lag_fatherweeks10` binds | 
| `CheatSheet` literally shows `cellrange()` but it had been listed as out-of-bounds | Index corrected |
| Splitting countries by initial leave generosity | Median initial father-specific entitlement is 0 across 26 countries, so all fell into one group. Rejected |

## C. Stata syntax and workflow errors

| Pitfall | Correction |
|---|---|
| `etable drop()` | Returns r(198); use `keep()` everywhere |
| `dtable` expected to give min/max | It does not; `collapse` + `export excel` is used |
| `inlist()` with 19 string country codes | Stata hangs; split into three `replace` lines of at most 9 codes each |
| `clear all` in a numbered do-file | Wipes the globals defined by the master and breaks the chain. Master uses `clear`; sub-do-files keep log blocks only |
| Six added regressions made `3_results` ~30-33 pages | Moved the build-up and subset tables into a fifth numbered do-file with its own log; every log is now under 25 pages |
| `bin()` and `subtitle()` in the two-group histogram | Neither option appears in the course handouts. Removed, and `lcolor(black)` added from the handouts' literal two-histogram example so both overlaid series remain visible |
| `quietly` suggested to shorten logs | Zero occurrences in the course handouts; not used |
| `split parse()`, `egen rowmin/rowmax/rownonmiss`, `cond()`, `[_n-1]` subscripts | Replaced with `generate` / `replace` / `real()` / `missing()` and the course-taught `L1.` / `F1.` operators after `encode` + `xtset` + `sort` |
| Live official-endpoint imports (PR #1, commit `8efda45`) | Rejected, on reproducibility rather than availability. The ILOSTAT API endpoint returns HTTP 200 with 0 bytes for `.csv` and `.csv.gz` and the Eurostat SDMX 3.0 call did not finish in 20 s, but the ILOSTAT bulk download works: a 15 November re-download was byte-identical to the snapshot. The decisive reason is that a live revision would change the numbers the submitted log reports |
| Do-file comments that read like AI delivery notes | Removed change logs, date/version tags, module numbers, course-checklist references, paper-writing hints and syntax justifications. One short `* ` line per block now. `display` is kept only for two `r()` counts |

## D. Submission-format traps

| Pitfall | Correction |
|---|---|
| `.xlsx` submitted as the summary table | Canvas allows only log, csv, png, do, docx, jpeg. Both `.csv` and `.xlsx` are produced locally; upload the `.csv` (and a `.docx` version if a Word table is wanted) |
| `.dta` uploaded | Not an allowed type. Upload the `.csv` copies from `data_raw/` and `data_final/` |
| One merged log | Would be roughly 55 pages. Four numbered logs are kept separate, each generated by its own do-file, as Workflow Guide 18 allows |
| Build-up table with mixed estimation samples | The first three columns used 443 observations and the fourth 333 because `leave_gdp` is missing for 110 country-years; coefficient changes across columns were not interpretable as control-variable effects. All four columns now share one `same_sample` flag (`generate` then one `replace` per covariate with `missing()`), while the subset table keeps a separate 443-observation all-countries column so 341 + 102 closes |
| "All variables winsorized" applied to only two variables | The original repeat winsorized the outcome and lagged log GDP. It now covers all five continuous variables with course-taught `summarize, detail` + `generate` / `recast double` / `replace`, and records that lagged leave weeks changes 0 observations under a 1/99 rule rather than claiming it was "handled" |
| Canvas comments quoting N=295 beside a 272-observation coefficient | 295 is the input panel and the DiD / event-study N; all main FE regressions use 272. The draft now separates the two and also distinguishes unmatched merge rows from matched rows lost to missing covariates |
| Build-up table without FE "yes/no" rows | Stata's `etable` can only put this in a note using permitted commands. The assignment explicitly says the exported Word file needs editing afterwards; adding the two rows is a manual step for the person formatting tables |
| Non-European subset column read as a real estimate | 6 country groups, 102 observations, coefficient 23.576. Kept for the required three columns, but the table note and this handover say it must not be interpreted |
| Assuming a GitHub commit equals a Canvas submission | It does not. Canvas upload is a manual team action |

## E. Method of working (process rules)

- Primary course PDFs > original logs and data > official web sources > any
  earlier AI conclusion, which must be re-verified line by line.
- Never treat a summary or second-hand paraphrase as primary evidence.
- Keep statistical denominators closed; check that subsample N always sums back
  to the parent sample.
- Do not infer knowledge or agreement from silence.
- After any do-file edit, rerun the whole chain: a stale log that still contains
  deleted commands is a grading problem.
