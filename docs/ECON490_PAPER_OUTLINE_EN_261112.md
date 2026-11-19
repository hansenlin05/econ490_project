# ECON 490 Final Paper — English Outline Skeleton

> Historical father-leave outline. Its old samples, clustered inference and
> result placeholders are superseded by the current OECD childcare PCSE AR(1)
> analysis in README.md and HANDOVER.md.

Generated: 12 November 2026
Companion to the 18 November Econometric Files package.

> Direction note (16 November 2026): this skeleton was written for the retired
> father-specific-leave question. The structure, section budgets and format
> rules still apply, but the question, variables, sample and results framing
> must be updated to the OECD childcare chain (see `HANDOVER.md` §2 and §4)
> before any prose is drafted.

## Scope note

The 18 November submission is **one set of do-, log-, data-, and image files** uploaded per team to Canvas (Course Outline, "Econometric Files · 10%"; START HERE, Step 6: "Prepare one complete set of do-, log-, data-, and image files for the Canvas submission"). It contains **no stand-alone written document**. The graded written deliverable is the Final Paper due 11 December (30%), drafted 16–25 November. This skeleton therefore covers the Final Paper; a short README skeleton for the 11/18 package is included at the end in case the posted Canvas checklist asks for a file guide.

This is a skeleton, not draft prose. Every number entered later must be taken from the combined `econ490_all_261109.log` and the exported tables — never from an earlier handover note. No Stata output may be pasted directly into the paper.

---

## Title Page

- Title: [short, reflects the research question, not the result]
- Authors: [three names, in agreed order]
- Abstract (200–250 words): [hypothesis] + [economic argument / mechanism] + [main result, stated honestly] + [one sentence on scope and limitations]
- Formatting: indented, single-spaced, justified; 12-point, 1.5 spacing elsewhere, 2.5 cm margins; Canadian spelling; present tense; no direct quotes.

## 1. Introduction (500–750 words)

1. Opening paragraph: [topic and why it matters; one specific, testable question].
2. Economic theory supporting the hypothesis, in several paragraphs:
   - [household specialisation and the division of paid / unpaid work]
   - [why father-specific, paid, non-transferable leave changes incentives]
   - [expected direction of the effect on the male-minus-female employment gap]
3. Formal hypothesis H1: [directional, testable statement; state the expected sign].
4. **No literature review here** — that belongs in Section 2.
5. Final paragraph: [roadmap of the remainder of the paper].

## 2. Literature Review (1200–1500 words)

For each of at least **eight** published economics journal articles or working papers, use the same four-part block:

- [Author (year): main economic argument]
- [Data source used in that paper]
- [Relevant empirical result, with a page-number citation, e.g. Galor (1992), p. 1235]
- [How it relates to the present question]

Candidate set already screened for this topic (verify metadata and page numbers before citing): [Kleven, Landais & Søgaard (2019); Patnaik (2019); Kotsadam & Finseraas (2011); Ekberg, Eriksson & Friebel (2013); Dunatchik & Özcan (2021); Farré & González (2019); Tamm (2019); Cools, Fiva & Kirkebøen (2015); Rege & Solli (2013); Dahl, Løken & Mogstad (2014)].

Closing paragraph, explicitly answering: [How does my work contribute to this literature?]

## 3. Data (500–750 words)

1. Sources and citations: [OECD Family Database PF2.1 / PF2.5; Eurostat; ILOSTAT; World Bank WDI; SOCX]. All datasets must appear in the Bibliography.
2. Sample definitions, stated separately and never pooled:
   - Primary: [23 European OECD countries, 2006–2019, N = 295; ages 25–54, youngest child under 6; no couple restriction].
   - Extension: [26 ILO countries, 2000–2024, N = 477; different population definition].
3. Variable construction and units: [GAP, LEAVE10, lagged log real GDP per capita, lagged real GDP growth, public leave spending as % of GDP]; [explain the one-year lag, the 10-week scaling, and the lower-bound rule for slash-coded cells].
4. Required table: [mean, sd, min, max, N for **all** variables; appropriate decimal places; variable names in CAPS used throughout].
5. Required graph: [properly formatted figure illustrating the hypothesised relationship; title, axis labels, units, sample, source].
6. For **every** explanatory variable: [predicted sign] + [economic reasoning].
7. Data weaknesses: [missing `leave_gdp`, the lag's first-year loss (N = 292 vs 295), differing ILO/Eurostat population definitions, 23 country clusters below the 30–50 rule of thumb].
8. **Logs are not used in this section** (that belongs in Results).

## 4. Empirical Results and Discussion (1000–1250 words)

1. Econometric method, fully explained: [two-way country and year fixed effects; why it is appropriate here; DiD and event study as supplementary specifications within the same framework].
2. Explicit regression equation with **every term defined**: [GAP_it = b1·L1.LEAVE10_it + b2·L1.LNGDP_it + b3·L1.GROWTH_it + b4·SPEND_it + country_i + year_t + e_it].
3. Note that lagged GDP per capita enters **every** regression (Checklist requirement).
4. Main results table: [coefficients, standard errors, significance stars with a key, N for each column]. Format as a publication table — suppress country and year dummies, use variable labels, add units and a source note. Never paste raw Stata output.
5. One sentence stating the result in a way a non-specialist reader finds meaningful: [economic magnitude, not only sign and p-value].
6. Post-regression diagnostics and corrections, each discussed:
   - [Fixed effects; joint test of year dummies; FE vs RE / Hausman]
   - [Heteroskedasticity (modified Wald) and the robust / clustered response]
   - [Serial correlation (Wooldridge) and the AR(1) PCSE sensitivity]
   - [Winsorized variable: report how many observations actually changed, and whether it alters the conclusion]
7. Interpretation against economic theory: [does the analysis support H1 or refute it? write associations, not causal effects].
8. Required questions, answered explicitly:
   - [Is this the appropriate econometric model?]
   - [How well does the data fit the model?]
   - [In what ways could the analysis be improved with better data?]
9. Results graph: [event-study coefficient plot with CI, zero line, k = −1 omitted, title, units, source].
10. Robustness / extension: [OECD extension reported separately; explain why its N falls to 348 / 348 / 463; quadratic and winsorized models in a separate table].

## 5. Conclusion (500–700 words)

1. [Restate the original thesis].
2. [Summarise statistical findings relative to H1].
3. [Compare findings with the current literature — a comparison, not a repeat of Section 2].
4. [Policy implications, discussed in detail].
5. [Suggestions for future research].

## Bibliography

- AER / Chicago Author-Date style; [all in-text references]; [all datasets cited]; [verify journal volume, issue and page numbers — do not invent them].

---

## Numbers to verify before drafting (placeholders, not content)

| Item | Source | Value |
|---|---|---|
| Primary / extension N | `1_build_data_261109.log` | [295 / 477] |
| Estimation N, six Europe columns | `3_results_261109.log` | [292, 292, 292, 295, 292, 295] |
| Estimation N, three OECD columns | `3_results_261109.log` | [348, 348, 463] |
| LEAVE10 coefficient and SE, FE / robust / clustered / PCSE | `3_results_261109.log` | [fill from final log] |
| DiD coefficient, SE, p | `3_results_261109.log` | [fill from final log] |
| Event-study four coefficients, SEs, p | `3_results_261109.log` | [fill from final log] |
| OECD three coefficients and p | `3_results_261109.log` | [fill from final log] |
| Mean / sd / min / max / N, all variables | `descriptive_261109.xlsx` | [fill from final table] |
| Observations changed by winsorization | `3_results_261109.log` | [fill from final log] |
| R² type per column | `3_results_261109.log` | [within-R² for xtreg, fe; overall for xtpcse] |

Verification rule: the do-file and its log are the only source of truth. If any number above disagrees with the final log, the paper follows the log.

---

## Optional: 11/18 package README skeleton

```
ECON 490 — Econometric Files, 18 November 2026

Reproduction
  0_master_261109.do -> 1_build_data_261109.do -> 2_descriptive_261109.do -> 3_results_261109.do
  Open Stata, cd to the project root on UBC OneDrive, then: do do_files/0_master_261109.do
  All three numbered logs are written by the do-files into log_files/.

Samples
  Primary   : 23 European OECD countries, 2006-2019, N = 295 (Eurostat).
  Extension : 26 ILO countries, 2000-2024, N = 477. Reported separately, never pooled.

Folders
  do_files/    four numbered do-files
  log_files/   three numbered logs
  data_raw/    source data
  data_final/  built analysis data (two .dta and two .csv)
  tables/      descriptive and regression tables
  figures/     descriptive figures and the event-study plot

Known limitations
  Lagged-leave regressions use N = 292; DiD and event study use N = 295.
  OECD estimation N falls to 348 / 348 / 463 because of missing leave_gdp.
  Country clusters: 23 (Europe) / 26 (OECD), below the usual 30-50 rule of thumb.
```
