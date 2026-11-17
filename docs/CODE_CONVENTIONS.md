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
permitted, are listed in §7. All of them were removed from the do-files by
16 November 2026; §7 records what replaced them.

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
- `egen ... = mean()`; see the documented extensions below for `min()` / `max()`
- functions `missing()`, `inlist()`, `inrange()`, `log()`; `real()` is a
  documented extension (§2)
- operators `== != > < >= <=`, `& | !`
- factor notation `i.` `c.` `#` `##`; lag and lead operators `L1.` `L2.` `F1.`
- reshaping: `reshape long`, `reshape wide`
- `foreach`, `forvalues`, `local`, `global`, `if` / `else`

`recast double` is not on this list; it appeared only in the CheatSheet (see §7).
The `string()` function is not on this list either: two targeted searches of
the two source sets found no verbatim use, and the one place the do-files
needed it (writing corrected leave weeks back into a text column) was replaced
on 16 November 2026 by numeric parsing plus literal `replace` values, which
left every downstream number unchanged.

**Estimation**

- `regress`, including `regress ..., robust` (the verbatim COMET 14 form) and
  factor terms
- `xtreg ..., fe`, `xtreg ..., re`
- `xtpcse ..., het corr(ar1)`
- post-estimation: `estimates store`, `testparm`, `hausman`, `predict`
- diagnostics: `xttest3`, `xtserial`

`vce(cluster id)`, `vce(robust)`, `lincom` and `margins` are not on this list;
they appear only in the CheatSheet and are now out (see §7). The single-coefficient
`test varname = 0` form is not demonstrated in any course material; use
`testparm`, which the panel module shows.

**Tables and figures**

- `etable, estimates(...) keep(...) mstat(N) mstat(r2) showstars showstarsnote`
  `varlabel column(dvlabel) export(...)` — the option set shown in the COMET
  and Test/Quiz materials
- `twoway (scatter ...) (lfit ...) (connected ...) (histogram ...)`,
  `histogram ...`
- graph options `title() xtitle() ytitle() legend() yline() xline()`
  `graphregion(color(white))`, `graph export ..., as(png) replace`
- `coefplot, keep(...) vertical rename(...)`

`dtable`, `collect export` and `column(index)` are not on this list; they are
CheatSheet additions and are now out (see §7). The `note()` option on `etable`
is not demonstrated in any of the three source sets, so the exported table's
fixed-effects statement belongs in a plain comment instead.

**Banned, with no exceptions**

`reghdfe`, `csdid`, `eventdd`, `bacondecomp`, `winsor2`, `outreg2`, `estout`,
`esttab`, `split parse()`, `egen rowmin/rowmax/rownonmiss`,
`cond()`, `[_n±1]` and `[1]` subscripts, `generate double`.

They are either package estimators the course never demonstrates, or
higher-level idioms that make the code harder to read than the equivalent
`generate` / `replace` sequence.

**Removed when the source restriction was applied (16 Nov 2026; re-verified
against the local PDF/MD originals on 16 Nov)**

`isid`, `count` (as a command), `tempfile`, `recast double`, `dtable`,
`collect export`, `column(index)`, `note()` (on `etable`), `test coef = 0`,
`lincom`, `margins`, `vce(cluster id)`, `vce(robust)`, and the `sheet()`,
`cellrange()`, `firstrow()` import options. The exact source status differs:
`isid`, `tempfile`, `recast double`, `dtable`, `collect export`, `column(index)`,
`lincom`, `margins`, `vce(cluster id)`, `vce(robust)` and the three import options
are demonstrated only in the CheatSheet, which is no longer a source. The
`count` command, `test varname = 0` and `etable note()` have no verbatim form in
any of the three source sets. None is demonstrated in the COMET or Test/Quiz
course text. §7 names which of them the current do-files still use.

## 2. The three documented exceptions

These are deliberate and are described here so that they are not treated as
violations. None of them can change an estimated coefficient, standard error
or sample size.

| Exception | Where | Why | Authority |
|---|---|---|---|
| `egen min()` / `egen max()` | `1_build_data_261109.do` (ILOSTAT unreliability flag) | Flag a country-year when any underlying row is flagged; `max()` of a 0/1 expression is the direct form | `egen ... = mean()` in the COMET within-group module; `min()` and `max()` are the same function family |
| `real()` | `1_build_data_261109.do` (leave-week parsing) | The OECD workbook ships leave weeks as text, sometimes with two slash-separated options; the numeric value must be parsed from the text and the slash options replaced by their lower bound | No verbatim form in either source set; `destring` is not course material either, so parsing with `real()` plus literal `replace` values is the only in-vocabulary reading |
| `quietly summarize` | `4_tables_261109.do` (1/99 percentile cut-offs only) | The instructor confirmed on 16 November 2026 that `quietly` may be used to keep logs short because descriptive output does not need to be printed; only the six percentile `summarize` calls are silenced, and every `r(p1)` / `r(p99)` value is still applied | Instructor's verbal permission. **Scope limit:** never on a regression, `test`, `tabulate`, `list`, `estimates` table or any command whose output is evidence for a submitted number. A silenced regression would break the rubric rule that every reported number is traceable to a log. |

There used to be four exceptions. The other three relied on the CheatSheet and
were removed with it on 16 November 2026: the three-step `generate` +
`recast double` + `replace` pattern, the `dtable ..., continuous(...,
statistic(...))` form, and `etable ..., note(...)`. The `string()` function was
removed from the do-files the same day for lack of a first-hand source.

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
has to be written into the log. None of the current do-files needs it; sample
sizes, section headers and "done" messages are not printed.

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
- One build of each raw source, written to fixed intermediate files
  (`tmp_*.dta` in `data_final/`) and reused by the later `use` and `merge`
  steps.
- No no-op commands. A command that prints "already numeric; no replace" or
  "(0 real changes made)" must be removed or restructured. The two `weeks_all`
  slash-option replaces print "(0 real changes made)" because the slash text
  occurs only in the paid column; they stay as the symmetric counterpart of the
  `fatherweeks` replaces and are documented here.
- Fixed-effects tests belong where the coefficients exist: `testparm
  i.country_id` runs after the LSDV `regress` that includes `i.country_id`.
  After `xtreg, fe` the country effects are absorbed and the test aborts with
  "no such variables".

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
   assignment's log limit (the instructor confirmed a 35-page ceiling on
   16 November 2026).

## 7. Where each permitted command is demonstrated

This table records the two remaining sources only: the COMET Notebook modules
and the StataTest / ECON490Quizzes question sets. It replaces the two
Chinese-language command indexes that used to sit in `docs/`. If a command is
not demonstrated in one of those two sources and is not one of the two
exceptions in §2, it is not permitted. The CheatSheet is not a source.

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
| 08a Reshaping | `reshape long`, `reshape wide` |
| 09 Visuals | `twoway (scatter) (lfit) (connected) (histogram)`, `histogram`, `title()`, `xtitle()`, `ytitle()`, `legend()`, `graphregion(color(white))`, `graph export ..., as(png) replace` |
| 11 Regression | `regress`, `i.var`, `c.var`, `#`, `##`, `predict` |
| 12 Exporting output | `etable, estimates() mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) keep() export()`, `coefplot` |
| 13 Dummies and interactions | `i.` and `c.` notation, `##` adding both main effects and the product |
| 14 Good regression practice | `regress ..., robust` (the verbatim form; equivalent to the CheatSheet `vce(robust)` but that spelling is not in the course text), winsorizing with `generate` + `replace` + `r(p1)` / `r(p99)`, omitted base categories, collinearity warnings, `regress ... c.age##c.age`, `predict yhat, xb` |
| 15 Panel data | `xtset`, `xtreg ..., fe`, `xtreg ..., re`, `hausman`, `testparm i.year`, `xttest3`, `xtserial`, `xtpcse ..., het corr(ar1)`, `L1.` / `F1.` |
| 16 Differences-in-differences | `1.treated#1.post`, event-time dummies built with `generate` + `replace` |
| 18 Stata Workflow Guide | `/* Project info */` header, directory globals, `capture noisily do` in a fixed order, `clear` rather than `clear all` |

**Removed with the CheatSheet, and no longer used anywhere.** Each row names
what replaced it in the current do-files.

| Command or option | Replacement in the current chain |
|---|---|
| `isid` | `duplicates report` on the panel key |
| `tempfile` | fixed intermediate files `tmp_*.dta` written to `data_final/` and reused by `use` / `merge` |
| `recast double` | not needed; the corrections are literal numeric replaces |
| `count` | `tabulate`, `duplicates report`, or the per-variable `(count)` statistics in `collapse` |
| `dtable` / `collect export` | `collapse` with `(mean) (sd) (min) (max) (count)` plus `export excel` / `export delimited` |
| `vce(cluster id)` / `vce(robust)` | the course-demonstrated `regress ..., robust` spelling; PCSE with `het corr(ar1)` as the serial-correlation correction |
| `test coef = 0` | `testparm` on the same term |
| `column(index)` | `column(dvlabel)` |
| `note()` on `etable` | the fixed-effects statement goes into the exported Word table by post-export editing |
| `sheet()`, `cellrange()`, `firstrow()` on `import excel` | the workbook content is pre-converted to a plain CSV (`oecd_leave_timeseries.csv`, latin-1) and read with `import delimited ..., varnames(1)` |
| `string()` function | numeric parsing with `real()` plus literal `replace` values; the built panel is bit-identical |

**Not used, and not to be introduced:** `reghdfe`, `csdid`, `eventdd`,
`bacondecomp`, `winsor2`, `outreg2`, `estout`, `esttab`, `putdocx`, `collect
style`, `split parse()`, `egen rowmin/rowmax/rownonmiss`, `cond()`,
subscript arithmetic such as `[_n-1]`, `generate double`.
