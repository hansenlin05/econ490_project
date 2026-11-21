# ECON 490 Final Paper — Outline and writing skeleton

Current direction: public childcare spending and the gender employment gap.
Generated from the frozen OECD childcare chain; every number below is located
in `log_files/econ490_all_261109.log` or the exported tables.

This is an outline, not draft prose. Any figure entered later must be traceable
to the combined log or an exported table. No raw Stata output may be pasted
into the paper.

---

## Title Page

- Title: short, reflects the research question, not the result.
- Authors: three names in the agreed order.
- Abstract (200–250 words): hypothesis + economic argument/mechanism + main result stated honestly + one sentence on scope and limitations.
- Format: abstract indented, single-spaced, justified; elsewhere 12-point, 1.5 spacing, 2.5 cm margins; Canadian spelling; present tense; no direct quotes.

## 1. Introduction (500–750 words)

1. Opening: topic, why it matters, one specific testable question — does prior-year public ECEC spending narrow the male-minus-female employment gap among parents of young children?
2. Economic argument in several paragraphs: household specialisation and the division of paid/unpaid work; how public childcare changes the opportunity cost of female employment; expected sign.
3. Formal hypothesis H1: a negative coefficient on lagged public ECEC spending.
4. No literature review in this section.
5. Final paragraph: roadmap for the remainder of the paper.

## 2. Literature Review (1200–1500 words)

At least **eight** peer-reviewed economics journal articles or working papers. For each, use the same four-part block:

- [Author (year): main economic argument]
- [Data source used in that paper]
- [Relevant empirical result with a page-number citation, e.g. Author (year), p. 1235]
- [How it relates to this question]

Required closing paragraph: "How does my work contribute to this literature?"

The nine PDFs currently held (Patnaik 2019; Kleven, Landais & Søgaard 2019; Kotsadam & Finseraas 2011; Ekberg, Eriksson & Friebel 2013; Dunatchik & Özcan 2021; Farré & González 2019; Tamm 2019; Cools, Fiva & Kirkebøen 2015; Rege & Solli 2013) are parental-leave papers and serve as related-policy context. **Core early-childhood-education-and-care literature must still be added**; see `docs/LITERATURE_SOURCES.md`. Verify all metadata and page numbers before citing; do not invent them.

## 3. Data (500–750 words)

1. Sources and citations: ILOSTAT household employment series; OECD Family Database PF2.1/PF2.5; OECD SOCX (TP521 for ECEC spending); World Bank WDI. All datasets must appear in the bibliography.
2. Sample: 23 OECD countries, 2000–2024 source window (477 panel rows); estimation sample 347 complete cases over 2001–2023. The lag consumes the first year and missing covariates consume the rest; explain why this is not an error.
3. Variable construction and units: employment gap in percentage points; ECEC spending as a share of GDP lagged one year; father and mother paid-leave weeks in 10-week units, lagged; log real GDP per capita lagged; public maternity and parental leave spending as a share of GDP. Explain the one-year lag and the slash-coded leave-cell rule.
4. Required table: mean, sd, min, max, N for **all** model variables, with appropriate decimal places and CAPS variable names used consistently. The 2019 summary is in `tables/descriptive_2019_oecd_childcare_261109.csv`.
5. Required graph: a properly formatted figure illustrating the hypothesised relationship, with title, axis labels, units, sample and source. `figures/scatter_gap_childcare_261109.png` and the subset histogram are candidates.
6. For **every** explanatory variable: predicted sign plus economic reasoning.
7. Data weaknesses: unbalanced panel; gaps in the SOCX series; 23 country units; missing values that reduce 477 rows to 347; the outcome's population definition.
8. Logs are not used in this section — the log specification belongs in Results.

## 4. Empirical Results and Discussion (1000–1250 words)

1. Econometric method, fully explained: initial two-way fixed effects (`xtreg, fe`) with diagnostics; reported `xtpcse, het corr(ar1)` with country and year effects and country-specific linear trends; why this fits the question.
2. Explicit regression equation with every term defined:
   ln(GAP_it) = β1·ln(1+ECEC_{i,t-1}) + β2·ln(1+LEAVE_F_{i,t-1}) + β3·ln(1+LEAVE_M_{i,t-1}) + β4·ln(GDPpc_{i,t-1}) + β5·ln(LEAVE_SPEND_it) + country_i + year_t + trend_i·t + e_it.
3. Note that lagged GDP per capita enters every regression (Checklist requirement) and that GDP growth is excluded.
4. Main results table: coefficients, standard errors, significance stars with a key, N for each column, explicit FE/trend rows. Use readable variable labels, units and a source note. Never paste raw Stata output.
5. One sentence stating the result meaningfully for a non-specialist reader: at sample mean spending the local elasticity is about −0.17, i.e. a 1 percent relative spending increase is associated with roughly a 0.17 percent smaller gap.
6. Post-regression diagnostics and corrections, each discussed:
   - Fixed effects: year FE joint test p = 0.1342; country effects F(22,276) = 56.83, p < 0.001.
   - Heteroskedasticity: modified Wald p < 0.001; PCSE panel-specific heteroskedasticity.
   - Serial correlation: Wooldridge p = 0.0006; common AR(1) in PCSE.
   - Winsorization: all six continuous variables winsorized at 1/99; coefficient −0.479 (SE 0.133, p = 0.0003); report how many observations actually changed and state that the observed-data model is preferred.
7. Interpretation against economic theory: does the analysis support or refute H1? Write associations, not causal effects.
8. Answer explicitly: is this the appropriate econometric model? How well does the data fit the model? How could better data improve the analysis?
9. Results graph: a properly formatted figure with CI, zero line, title, units and source.
10. Robustness in separate tables: three-column subset table (347 / 309 EU-target / 38 other OECD), build-up table, winsorized table. The 38-observation column is descriptive only.

**Central caveat to state plainly:** keeping both fixed effects but removing country-specific trends gives +0.092 (SE 0.148, p = 0.5357). The negative association is conditional on the trend specification. The quadratic term is insignificant (p = 0.5702) and excluded.

## 5. Conclusion (500–700 words)

1. Restate the original thesis.
2. Summarise statistical findings relative to H1, including the trend dependence.
3. Compare findings with the current literature — a comparison, not a repeat of Section 2.
4. Policy implications, discussed in detail, with the causal caveat intact.
5. Suggestions for future research.

## Bibliography

AER / Chicago Author-Date style. Include all in-text references and all dataset citations. Verify journal volume, issue and page numbers; do not invent them.

---

## Numbers to use (authority: `log_files/econ490_all_261109.log`)

| Item | Value |
|---|---|
| Input panel / estimation sample | 477 rows / 347 complete cases |
| Countries / years | 23 OECD / 2001–2023 |
| Main PCSE AR(1) childcare coefficient | −0.472 (SE 0.135, p = 0.0005) |
| Winsorized (1/99) coefficient | −0.479 (SE 0.133, p = 0.0003) |
| Level-model comparison | −7.496 (SE 2.668, p = 0.0050) |
| No-country-trend comparison | +0.092 (SE 0.148, p = 0.5357) |
| EU-target subset / other OECD | −0.447 (SE 0.143, p = 0.002) / −0.198 (SE 0.243, p = 0.416) |
| Father / mother leave controls | +0.032 (p = 0.247) / +0.021 (p = 0.538) |
| Year FE p / country FE F test | 0.1342 / F(22,276) = 56.83, p < 0.001 |
| Modified Wald / Wooldridge | p < 0.001 / p = 0.0006 |
| Quadratic term p | 0.5702 |
| Local elasticity at mean spending 0.538 | about −0.17 |

Verification rule: the do-file and its combined log are the only source of truth. If any number above disagrees with the log, the paper follows the log.
