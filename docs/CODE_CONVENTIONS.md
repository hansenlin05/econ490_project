# Code conventions — permitted commands, comment rules, and coding level

This file is the gate for any change to the do-files. It restates what the
course materials themselves demonstrate, so that a reader who has only this
repository can check a patch without owning the handouts.

Sources, by filename: the COMET Notebook modules 02–18 (including
`18 - Stata Workflow Guide – COMET.pdf`) and the `StataTest` /
`ECON490Quizzes` question sets. A command is permitted when one of those two
sources shows or explains it. `StataCheatSheet_analysis_19.pdf` is **not** a
source: as of 16 November 2026 it has been removed from the whitelist, and
nothing is permitted on the strength of that handout alone.

Commands that appeared only in the CheatSheet, and are therefore no longer
permitted, are listed in §7. Several of them are still present in the current
do-files; those are named explicitly as outstanding items to replace before
submission, not silently treated as allowed.

## 1. Permitted command set

If a command is not on this list, it is not permitted. Do not substitute a
package command.

**Data input and output**

- `import delimited`, `import excel` (the command names; the `sheet()`,
  `cellrange()` and `firstrow()` options came from the CheatSheet and are not
  covered by this whitelist — see §7)
- `use`, `save`, `clear`, `preserve`, `restore`
- `export excel`, `export delimited`
- `log using ..., text replace`, `log close`, `capture noisily`
- `cd`, `dir`

**Inspection and descriptive work**

- `describe`, `list`, `summarize varlist` and `summarize v, detail`
- `duplicates report varlist` — key check before a merge
- `tabulate` (one-way and two-way, `missing`, `gen()`)
- `collapse (mean) (sd) (min) (max) (count)`
- `sort`, `bysort`, `order`, `drop`, `keep`, `rename`, `label variable`
- `encode`, `xtset panel time, yearly`

The commands `count`, `isid` and `tempfile` are not on this list; they appear
only in the CheatSheet and are now out (see §7).

**Variable construction**

- `generate`, `replace`
- `egen ... = mean()`; see the documented extension below for `min()` / `max()`
- functions `missing()`, `inlist()`, `inrange()`, `log()`, `real()`, `string()`
- operators `== != > < >= <=`, `& | !`
- factor notation `i.` `c.` `#` `##`; lag and lead operators `L1.` `L2.` `F1.`
- `foreach`, `forvalues`, `local`, `global`, `if` / `else`

`recast double` is not on this list; it appeared only in the CheatSheet (see §7).

**Estimation**

- `regress`, including factor terms
- `xtreg ..., fe`, `xtreg ..., re`
- `xtpcse ..., het corr(ar1)`
- post-estimation: `estimates store`, `testparm`, `hausman`, `predict`
- diagnostics: `xttest3`, `xtserial`

`vce(cluster id)`, `vce(robust)`, `test coef = 0`, `lincom` and `margins` are
not on this list; they appear only in the CheatSheet or in its derived
appendix, and are now out (see §7).

**Tables and figures**

- `etable, estimates(...) keep(...) mstat(N) mstat(r2) showstars showstarsnote`
  `varlabel column(dvlabel) export(...)` — the option set shown in the COMET
  and Test/Quiz materials
- `twoway (scatter ...) (lfit ...) (connected ...) (histogram ...)`,
  `histogram ...`
- graph options `title() xtitle() ytitle() legend() yline() xline()`
  `graphregion(color(white))`, `graph export ..., as(png) replace`
- `coefplot, keep(...) vertical rename(...)`

`dtable`, `collect export`, `column(index)` and `note()` are not on this list;
they are CheatSheet additions and are now out (see §7).

**Banned, with no exceptions**

`reghdfe`, `csdid`, `eventdd`, `bacondecomp`, `winsor2`, `outreg2`, `estout`,
`esttab`, `quietly`, `split parse()`, `egen rowmin/rowmax/rownonmiss`,
`cond()`, `[_n±1]` and `[1]` subscripts, `generate double`.

They are either package estimators the course never demonstrates, or
higher-level idioms that make the code harder to read than the equivalent
`generate` / `replace` sequence.

**Removed when the CheatSheet source was dropped (16 Nov 2026)**

`isid`, `count` (as a command), `tempfile`, `recast double`, `dtable`,
`collect export`, `column(index)`, `note()` (on `etable`), `test coef = 0`,
`lincom`, `margins`, `vce(cluster id)`, `vce(robust)`, and the `sheet()`,
`cellrange()`, `firstrow()` import options. None of these is demonstrated in
the COMET or Test/Quiz course text. §7 names which of them the current
do-files still use.

## 2. The one documented exception

This one is deliberate and is described here so that it is not treated as a
violation. It cannot change a coefficient, a standard error or a sample size.

| Exception | Where | Why | What the handouts do show |
|---|---|---|---|
| `egen min()` / `egen max()` | `1_build_data_261109.do` | Smallest and largest policy year per country | `egen ... = mean()` in the COMET within-group module; `min()` and `max()` are the same function family |

There used to be four exceptions. The other three relied on the CheatSheet and
were removed with it on 16 November 2026: the three-step `generate` +
`recast double` + `replace` pattern, the `dtable ..., continuous(...,
statistic(...))` form, and `etable ..., note(...)`. They are now listed in §1
as removed commands, and §7 names where the do-files still use them.

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
- One build of each raw source, reused rather than rebuilt under different
  suffixes. The current build uses `tempfile` for this, but `tempfile` is no
  longer on the whitelist (§7); the replacement has not been made yet.
- No no-op commands. A `destring` that prints "already numeric; no replace", or
  a winsorization step that changes zero observations, must be removed or
  recorded. The current code records zero-change winsorization with `count`,
  which is likewise no longer on the whitelist (§7).

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

This table records the two remaining sources only: the COMET Notebook modules
and the StataTest / ECON490Quizzes question sets. It replaces the two
Chinese-language command indexes that used to sit in `docs/`. If a command is
not demonstrated in one of those two sources and is not the single exception in
§2, it is not permitted. The CheatSheet is not a source.

**COMET Notebook modules 02–18** (`02 - Working with Do-Files` through
`18 - Stata Workflow Guide`) and the **Test / Quiz** question sets, combined:

| Area | Commands permitted here |
|---|---|
| 02 Do-files and logs | `do`, `log using ..., text replace`, `log close`, `capture noisily`, `*` and `//` comments |
| 03 Stata essentials | `use`, `describe`, `list`, `summarize`, `summarize, detail`, `tabulate`, `keep`, `drop`, `sort`, `clear`, `missing()`, `inlist()`, `inrange()`, `foreach`, `forvalues` |
| 04 Locals and globals | `local`, `global`, `` `local' ``, `$global` |
| 05 Opening data | `import delimited`, `import excel`, `export excel`, `export delimited`, `save` (command names only; the CheatSheet import options are out) |
| 06 Generating variables | `generate`, `replace`, `label variable`, `rename`, `encode`, `xtset`, arithmetic and comparison operators |
| 07 Within-group analysis | `bysort`, `collapse (mean) (sd) (min) (max) (count)`, `preserve`, `restore`, `keep if`, `egen ... = mean()` |
| 08 Combining datasets | `merge m:1`, `merge 1:1`, `duplicates report` |
| 09 Visuals | `twoway (scatter) (lfit) (connected) (histogram)`, `histogram`, `title()`, `xtitle()`, `ytitle()`, `legend()`, `graphregion(color(white))`, `graph export ..., as(png) replace` |
| 11 Regression | `regress`, `i.var`, `c.var`, `#`, `##`, `predict` |
| 12 Exporting output | `etable, estimates() mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) keep() export()`, `coefplot` |
| 13 Dummies and interactions | `i.` and `c.` notation, `##` adding both main effects and the product |
| 14 Good regression practice | `testparm`, omitted base categories, collinearity warnings |
| 15 Panel data | `xtset`, `xtreg ..., fe`, `xtreg ..., re`, `hausman`, `xttest3`, `xtserial`, `xtpcse ..., het corr(ar1)`, `L1.` / `F1.` |
| 16 Differences-in-differences | `1.treated#1.post`, event-time dummies built with `generate` + `replace` |
| 18 Stata Workflow Guide | `/* Project info */` header, directory globals, `capture noisily do` in a fixed order, `clear` rather than `clear all` |

**Dropped with the CheatSheet, and still used in the current do-files.** These
are recorded so the gap is visible. They are not permitted under this
whitelist, and must be replaced before the files are submitted. The do-files
were deliberately left unchanged in this round.

| Command or option | Where the current do-files use it |
|---|---|
| `isid` | `1_build_data_261109.do`; `1_build_data_261116.do` |
| `tempfile` | `1_build_data_261109.do`; `1_build_data_261116.do`; `5_childcare_robust` |
| `recast double` | `1_build_data_261109.do`; `4_tables_261109.do`; `1_build_data_261116.do`; `4_tables` in the childcare branch |
| `count` | `4_tables_261109.do`; `4_tables` in the childcare branch |
| `dtable` | `2_descriptive_261109.do` in both directions |
| `vce(cluster id)` | `3_results_261109.do` (original direction) |
| `vce(robust)` | `3_results` and tables in both directions |
| `test coef = 0` | `3_results_261109.do` in both directions |
| `column(index)` | `3_results_261109.do`, `4_tables_261109.do`, `2_descriptive_261109.do`, and the childcare tables |
| `note()` on `etable` | `3_results_261109.do`, `4_tables_261109.do`, `2_descriptive_261109.do`, and the childcare tables |
| `sheet()`, `cellrange()` on `import excel` | `1_build_data_261109.do`; `1_build_data_261116.do` |

**Not used, and not to be introduced:** `reghdfe`, `csdid`, `eventdd`,
`bacondecomp`, `winsor2`, `outreg2`, `estout`, `esttab`, `putdocx`, `collect
style`, `quietly`, `split parse()`, `egen rowmin/rowmax/rownonmiss`, `cond()`,
subscript arithmetic such as `[_n-1]`, `generate double`.
