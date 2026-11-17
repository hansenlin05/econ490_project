# Pitfalls and corrections — what went wrong and what replaced it

Last updated 16 November 2026. Read this before proposing a "fix": several
plausible-looking fixes have already been tried and rejected. Every row names
the file or log where the correction can be verified.

## A. Wrong research conclusions

| Pitfall | Correction | Evidence |
|---|---|---|
| Quoting numbers from the retired father-leave chain | The Europe-primary design (N=292/295, OECD extension 348/463, DiD, event study, Test7 interaction) was retired on 16 November 2026 when the team adopted the OECD childcare panel. None of its coefficients or p-values may appear in the submission | `docs/RESEARCH_DECISIONS.md` §0 |
| "Roll back the specification to get stars" | Any historically significant reading traced to unclustered SEs, a broken lag, or a retired direction stays retired. Rolling back for significance conflicts with academic integrity and the checklist | `log_files/3_results_261109.log` |
| "Only one course checklist exists, so there is no separate 18 Nov requirement" | Over-inference. The Course Outline's "posted checklist" is the Canvas assignment page `Econometric Files for Final Paper.pdf`, which is a different document from `Final Paper Checklist_ ... .pdf` | Both PDFs; `docs/COURSE_REQUIREMENTS.md` §0 |
| "March 23rd is the deadline" in the Canvas PDF | Stale template from an earlier term; header says "Due No Due Date". Deadline is 18 Nov 2026 per `ECON 490 Course Outline.pdf` p.14 | Both PDFs |

## B. Data-construction bugs

| Pitfall | Correction |
|---|---|
| A newly uploaded "new version" of a file was assumed to be different | md5 and line-by-line diff proved one such file byte-identical to its predecessor. Always compare content, not filename or timestamp |
| A lag computed inside the research panel | It drops the first year and the year before each gap, letting outcome availability select the sample. Every lag in the current chain — GDP, father-specific leave weeks, maternity/parental leave spending, and the SOCX spending lag — is computed on its own full annual series before any merge |
| The UTF-8 leave timeseries broke the merge | Stata misread the workbook's UTF-8 export as ISO-8859-1, so the Türkiye rows failed to match and 56 observations dropped. The pre-converted CSV is written in latin-1 (`data_raw/oecd_leave_timeseries.csv`) |
| Leave weeks stored as text with slash-separated options | Parsed with `real()`; the two slash options are replaced by their lower bound; the three year corrections and four late-snapshot corrections are hardcoded literal values taken from the recorded next year. The `string()` construction was removed on 16 Nov 2026 for lack of a first-hand course source; the literal version leaves the built panel bit-identical |
| Winsorization reported as "handled" | An earlier attempt left every `replace` at "(0 real changes made)". The current repeat covers all six continuous model variables with `summarize, detail` percentiles plus `generate` / `replace` |
| `generate double` / `recast double` used for precision | Not in the permitted command vocabulary; neither is needed now that corrections are literal replaces |
| Four `destring` commands were no-ops | Log printed "already numeric; no replace"; removed |
| Two verbatim-duplicated build blocks | Merged into one build per raw source |
| Removing `stringcols(_all)` / `allstring` changed CSV md5 | Only float/double storage precision changed. All coefficients, SEs, p-values and N unchanged. Team rule: prefer full whitelist compliance over byte-identical CSVs when only precision changes |
| Assuming dropping a control restores the full panel | The complete-case count is set by whichever variable binds first. Check the `childcare_sample` breakdown in the build log before claiming an N |
| Splitting countries by initial leave generosity | Median initial father-specific entitlement is 0 across the OECD panel, so all countries fell into one group. Rejected |

## C. Stata syntax and workflow errors

| Pitfall | Correction |
|---|---|
| `etable drop()` | Returns r(198); use `keep()` everywhere |
| `dtable` expected to give min/max | It does not; `collapse` plus `export excel` / `export delimited` is used |
| `testparm i.country_id` after `xtreg, fe` | Aborts with "no such variables" (r(111)) because the fixed-effects estimator absorbs the country effects. Run it after the LSDV `regress` that includes `i.country_id` |
| `inlist()` with 19 string country codes | Stata hangs; split into three `replace` lines of at most 9 codes each |
| `clear all` in a numbered do-file | Wipes the globals defined by the master and breaks the chain. Master uses `clear`; sub-do-files keep log blocks only |
| Table work pushing a log past its page limit | The build-up and winsorized work live in a fourth numbered do-file with its own log; Workflow Guide 18 §18.2.2 allows it |
| `bin()` and `subtitle()` in the two-group histogram | Neither option appears in the course handouts. Removed, and `lcolor(black)` added from the handouts' literal two-histogram example so both overlaid series remain visible |
| `quietly` suggested to shorten logs | Zero occurrences in the course handouts; not used |
| `split parse()`, `egen rowmin/rowmax/rownonmiss`, `cond()`, `[_n-1]` subscripts | Replaced with `generate` / `replace` / `missing()` and the course-taught `L1.` / `F1.` operators after `encode` + `xtset` + `sort` |
| Live official-endpoint imports (PR #1, commit `8efda45`) | Rejected, on reproducibility rather than availability. The ILOSTAT API endpoint returns HTTP 200 with 0 bytes for `.csv` and `.csv.gz` and the Eurostat SDMX 3.0 call did not finish in 20 s, but the ILOSTAT bulk download works: a 15 November re-download was byte-identical to the snapshot. The decisive reason is that a live revision would change the numbers the submitted log reports |
| Do-file comments that read like delivery notes | Removed change logs, date/version tags, module numbers, course-checklist references, paper-writing hints and syntax justifications. One short `* ` line per block now |

## D. Submission-format traps

| Pitfall | Correction |
|---|---|
| `.xlsx` submitted as the summary table | Canvas lists only log, csv, png, do, docx, jpeg. The summary table is exported as both `.xlsx` and `.csv`; try the Excel file first and fall back to the CSV if Canvas rejects it |
| `.dta` uploaded | Not an allowed type. Upload the `.csv` copies from `data_raw/` and `data_final/` |
| One merged log | Would be roughly 50 pages. Four numbered logs are kept separate, each generated by its own do-file, as Workflow Guide 18 allows |
| Build-up table with mixed estimation samples | All five build-up columns share the same 347-observation complete-case sample, so coefficient changes read purely as the effect of added controls |
| "All variables winsorized" applied to only some variables | The current repeat covers all six continuous model variables (outcome, lagged spending, lagged leave weeks, lagged log GDP, lagged GDP growth, leave spending) |
| Canvas comments quoting the panel N beside the estimation N | 477 is the input panel; 347 is the complete-case estimation sample; 309 + 38 = 347 in the subset table. The draft separates the two and also distinguishes unmatched merge rows from matched rows lost to missing covariates |
| Build-up table without FE "yes/no" rows | `etable` has no fixed-effects row option in the permitted vocabulary. The assignment explicitly says the exported Word file needs editing afterwards; adding the two rows is a manual step for the person formatting tables |
| "Other OECD" subset column read as a real estimate | 4 country groups, 38 observations, coefficient −4.111 (p = 0.411). Kept for the required three columns, but the table note and this repository say it must not be interpreted |
| Assuming a GitHub commit equals a Canvas submission | It does not. Canvas upload is a manual team action |

## E. Method of working (process rules)

- Primary course PDFs > original logs and data > official web sources > any
  earlier conclusion from a conversation, which must be re-verified line by line.
- Never treat a summary or second-hand paraphrase as primary evidence.
- Keep statistical denominators closed; check that subsample N always sums back
  to the parent sample.
- Do not infer knowledge or agreement from silence.
- After any do-file edit, rerun the whole chain: a stale log that still contains
  deleted commands is a grading problem.
