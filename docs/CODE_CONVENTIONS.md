# Code conventions — permitted commands, comment rules, and coding level

This file is the gate for any change to the do-files. It restates what the
course materials themselves demonstrate, so that a reader who has only this
repository can check a patch without owning the handouts.

Sources, by filename: `StataCheatSheet_analysis_19.pdf`, the COMET Notebook
modules 02–18 (including `18 - Stata Workflow Guide – COMET.pdf`), and the
`StataTest` / `ECON490Quizzes` question sets. A command is permitted when one of
those materials shows or explains it.

## 1. Permitted command set

If a command is not on this list, it is not permitted. Do not substitute a
package command.

**Data input and output**

- `import delimited ..., varnames(1)`, `import excel ..., sheet() cellrange() clear`
- `use`, `save`, `clear`, `preserve`, `restore`, `tempfile`
- `export excel using ..., firstrow(variables)`, `export delimited using ...`
- `log using ..., text replace`, `log close`, `capture noisily`
- `cd`, `dir`

**Inspection and descriptive work**

- `describe`, `list`, `count`, `summarize varlist` and `summarize v, detail`
- `isid varlist`, `duplicates report varlist` — key checks before a merge
- `tabulate` (one-way and two-way, `missing`, `gen()`)
- `collapse (mean) (sd) (min) (max) (count)`
- `sort`, `bysort`, `order`, `drop`, `keep`, `rename`, `label variable`
- `encode`, `xtset panel time, yearly`

**Variable construction**

- `generate`, `replace`, `recast double`
- `egen ... = mean()`; see the documented extension below for `min()` / `max()`
- functions `missing()`, `inlist()`, `inrange()`, `log()`, `real()`
- operators `== != > < >= <=`, `& | !`
- factor notation `i.` `c.` `#` `##`; lag and lead operators `L1.` `L2.` `F1.`
- `foreach`, `forvalues`, `local`, `global`, `if` / `else`

**Estimation**

- `regress`, including `vce(cluster id)` and factor terms
- `xtreg ..., fe`, `xtreg ..., re`, `xtreg ..., fe vce(robust)`
- `xtpcse ..., het corr(ar1)`
- post-estimation: `estimates store`, `testparm`, `test coef = 0`, `lincom`,
  `hausman`, `predict`, `margins`
- diagnostics: `xttest3`, `xtserial`

**Tables and figures**

- `etable, estimates(...) keep(...) mstat(N) mstat(r2) showstars showstarsnote`
  `varlabel column(index) note(...) export(...)`
- `dtable ..., export(...)`
- `collect export ...`
- `twoway (scatter ...) (lfit ...) (connected ...) (histogram ...)`,
  `histogram ...`
- graph options `title() xtitle() ytitle() legend() yline() xline()`
  `graphregion(color(white))`, `graph export ..., as(png) replace`
- `coefplot, keep(...) vertical rename(...)`

**Banned, with no exceptions**

`reghdfe`, `csdid`, `eventdd`, `bacondecomp`, `winsor2`, `outreg2`, `estout`,
`esttab`, `quietly`, `split parse()`, `egen rowmin/rowmax/rownonmiss`,
`cond()`, `[_n±1]` and `[1]` subscripts, `generate double`.

They are either package estimators the course never demonstrates, or
higher-level idioms that make the code harder to read than the equivalent
`generate` / `replace` sequence.

## 2. The four documented exceptions

Each is deliberate and is described here so that it is not treated as a
violation. None of them can change a coefficient, a standard error or a sample
size; all four affect presentation.

| Exception | Where | Why | What the handouts do show |
|---|---|---|---|
| `egen min()` / `egen max()` | `1_build_data_261109.do` | Smallest and largest policy year per country | `egen ... = mean()`; `min()` and `max()` are the same family |
| `generate` + `recast double` + `replace` | `1_build_data_261109.do` | Country-year keys exceed float precision after a merge on log GDP | `recast double mpg` |
| `dtable ..., continuous(varlist, statistic(n mean sd min max))` | `2_descriptive_261109.do` | A Word summary table needs N, mean, sd, min and max per variable | `dtable price mpg i.rep78, export(table1.pdf)` |
| `etable ..., title(...) note(...)` | `3_results_261109.do`, `4_tables_261109.do` | The exported table has to carry the fixed-effects statement and the warning that the six-group column is not a policy effect | The cheat sheet writes the `etable` option slot as `/* */`, i.e. options omitted; `title()` is also listed for `etable` in the course notes |

Stata rejects a bare `statistic()` or `stat()` in `dtable` (error 198); the
option must sit inside `continuous()`. The cheat sheet's `stat(mean price mpg)`
line is a condensed form and cannot be copied literally.

## 3. Comment rules

The purpose of a comment is to tell a reader what the next block of code does.
One short sentence, on its own line, is almost always enough.

**Required**

- Every section of a do-file starts with a comment saying what it does.
- Data merges carry a comment saying why rows do not match.
- A specification choice that a reader would question (why the non-linear term
  is dropped, why the unwinsorized model is preferred, why the sample is fixed)
  carries one sentence of justification.

**Forbidden**

| Do not write | Example of the problem |
|---|---|
| Delivery or version records | "merged from the 13 Nov version", "previously documented", a date-and-version line |
| Course-material references | "Module 18 requires", "the checklist asks", "as the rubric says" |
| Instructions to the paper's author | "the paper must explain why theory predicts non-linearity" |
| Defences of a command choice | "plain `generate` stores a float, so the replace refills at double precision" |
| Process labels | "Step 0", "locked panels", "apply the existing sample rule" |
| Decoration | `==========` rules, banner lines, emoji |

The test: a grader who has never seen this project should be able to read the
comment and learn what the code does — not what the team did last week.

**`display` is not a commenting device.** It is used only where an `r()` result
has to be written into the log. Currently that is the five winsorization change
counts in `4_tables_261109.do`. Sample sizes, section headers and "done"
messages are not printed.

## 4. Coding level

The code is written at the level of an undergraduate who has taken the course's
Stata sequence, and it is read by a teaching assistant who may run it line by
line.

- One operation per line where possible; `generate` + `replace` rather than a
  nested expression.
- Lagged and leading variables use `L1.` / `F1.` after `encode` + `xtset` +
  `sort`, not subscript arithmetic.
- Panel setup is explicit: `encode`, `xtset`, then `sort`.
- No macro metaprogramming beyond `global` for paths and controls and `local`
  for percentile cut-offs.
- One build of each raw source, reused through `tempfile`; no copy-pasted
  blocks that differ only in a suffix.
- No no-op commands. A `destring` that prints "already numeric; no replace", or
  a winsorization step that changes zero observations, must be either removed or
  recorded with a `count` that shows the zero.

## 5. Structure of a do-file

Every numbered do-file follows the course workflow guide:

```
/* Project info
   <file name> | <one line on what this file produces>. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_<name>}==1 {
    cap log close
    capture noisily log using "${log_dir}/<file>.log", text replace
}

... body ...

//Close log if needed
if ${store_log_<name>}==1 {
    cap log close
}
```

`0_master` sets the paths and the run/store globals, then calls the four
numbered files with `capture noisily do`. It uses `clear`, never `clear all`,
because the numbered files depend on the globals it defines.

## 6. Pre-commit checks

Run these before any push. All six are cheap and each has caught a real defect.

1. `grep` the do-files for the banned list in §1 — expect zero hits.
2. `grep` the comments for the forbidden categories in §3 — expect zero hits.
3. Rerun `0_master` from `data_raw`; expect no `r()` error in any log.
4. Compare the analysis CSV checksums with the previous run; a difference must
   be explainable.
5. Recheck the four log lengths after 80-character wrapping against the
   assignment's 25-page limit.
6. Confirm the root do-file copies and the `do_files/` copies are identical.

## 7. Where each permitted command is demonstrated

This table replaces the two Chinese-language command indexes that used to sit in
`docs/`. It records, for every command this project uses, the course material
that demonstrates it. If a command is not in this table and not in §2, it is not
permitted.

**COMET Notebook modules 02–18** (`02 - Working with Do-Files` through
`18 - Stata Workflow Guide`):

| Area | Commands used here |
|---|---|
| 02 Do-files and logs | `do`, `log using ..., text replace`, `log close`, `capture noisily`, `*` comments, `//` comments |
| 03 Stata essentials | `use`, `describe`, `list`, `summarize`, `summarize, detail`, `tabulate`, `count`, `keep`, `drop`, `sort`, `clear`, `missing()`, `inlist()`, `inrange()`, `foreach`, `forvalues` |
| 04 Locals and globals | `local`, `global`, `` `local' ``, `$global` |
| 05 Opening data | `import delimited ..., varnames(1)`, `import excel ..., sheet() cellrange() clear`, `export excel using ..., firstrow(variables)`, `save` |
| 06 Generating variables | `generate`, `replace`, `label variable`, `rename`, `encode`, `xtset`, arithmetic and comparison operators |
| 07 Within-group analysis | `bysort`, `collapse (mean) (sd) (min) (max) (count)`, `preserve`, `restore`, `keep if`, `egen ... = mean()` |
| 08 Combining datasets | `merge m:1`, `merge 1:1`, `duplicates report`, `isid` |
| 09 Visuals | `twoway (scatter) (lfit) (connected) (histogram)`, `histogram`, `title()`, `xtitle()`, `ytitle()`, `legend()`, `graphregion(color(white))`, `graph export ..., as(png) replace` |
| 11 Regression | `regress`, `i.var`, `c.var`, `#`, `##`, `predict` |
| 12 Exporting output | `etable, estimates() mstat(N) mstat(r2) showstars showstarsnote varlabel column() keep() export()`, `coefplot`, `export delimited` |
| 13 Dummies and interactions | `i.` and `c.` notation, `##` adding both main effects and the product |
| 14 Good regression practice | `testparm`, omitted base categories, collinearity warnings, `test coef = 0` |
| 15 Panel data | `xtset`, `xtreg ..., fe`, `xtreg ..., re`, `xtreg ..., fe vce(robust)`, `hausman`, `xttest3`, `xtserial`, `xtpcse ..., het corr(ar1)`, `L1.` / `F1.` |
| 16 Differences-in-differences | `1.treated#1.post`, event-time dummies built with `generate` + `replace` |
| 18 Stata Workflow Guide | `/* Project info */` header, directory globals, `capture noisily do` in a fixed order, `clear` rather than `clear all` |

**`StataCheatSheet_analysis_19.pdf` and the `StataTest` / `ECON490Quizzes`
sets** — these are the only sources for the commands below, which is why each
one is explained in the review notes rather than assumed:

| Command | What it adds |
|---|---|
| `isid varlist` | stops the run if the key is not unique, before a merge can duplicate rows |
| `tempfile` + `` `name' `` | a session-scoped path, so the policy history is built once and merged twice without leaving files behind |
| `recast double` | storage type; used only in the three-step `generate` + `recast double` + `replace` pattern (see §2) |
| `dtable` | descriptive-statistics table; see §2 for the `continuous(...)` form |
| `test coef = 0` | exact p-value for a single coefficient, printed into the log |
| `column(index)` | numbers the columns of a multi-model `etable` instead of repeating the dependent-variable name |
| `note()` | see §2, fourth exception |

**Not used, and not to be introduced:** `reghdfe`, `csdid`, `eventdd`,
`bacondecomp`, `winsor2`, `outreg2`, `estout`, `esttab`, `putdocx`, `collect
style`, `quietly`, `split parse()`, `egen rowmin/rowmax/rownonmiss`, `cond()`,
subscript arithmetic such as `[_n-1]`, `generate double`.
