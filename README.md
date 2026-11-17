# Public Childcare Spending and the OECD Employment Gap

The analysis tests whether higher public spending on early childhood education and care (ECEC) is associated with a smaller male-minus-female employment gap in couple households with children under six. The estimation sample contains **347 country-years from 23 OECD countries, 2001–2023**.

## Run the current analysis

Place the [Stata do-file](oecd_childcare_live.do) and these four downloaded inputs in the same folder. In Stata, set your working directory to that folder and run `do oecd_childcare_live.do`.

| Local input | Source |
|---|---|
| `ilostat_employment.csv` | [ILOSTAT annual employment data by sex and household composition](https://ilostat.ilo.org/data/) |
| `oecd_leave_history.xlsx` | [OECD Family Database PF2.5 historical leave entitlements](https://webfs.oecd.org/els-com/Family_Database/PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx) |
| `oecd_socx_spending.csv` | [OECD SOCX public spending, ECEC (TP521) and maternity and parental leave (TP512)](https://www.oecd.org/en/data/datasets/social-expenditure-database-socx.html) |
| `wdi_gdp_raw.dta` | [World Bank WDI real GDP per capita (NY.GDP.PCAP.KD)](https://data.worldbank.org/indicator/NY.GDP.PCAP.KD) |

The script builds the lags before merging, prepares the estimation sample, runs the diagnostics and estimates both PCSE models. It writes `oecd_childcare_live_results.log` and exports the build-up and comparison tables as Word files. Stata needs `xttest3`, `xtserial` and a release with `etable`.

## Model and results

The dependent variable is the natural log of the male-minus-female employment gap measured in percentage points. The main explanatory variable is `ln(1 + childcare)`, with prior-year public ECEC spending expressed as a percentage of GDP. The controls are `ln(1 + father’s leave)` using prior-year paid weeks in units of ten, the log of prior-year real GDP per capita, and the log of public maternity and parental leave spending as a percentage of GDP. The `+1` transformations retain zero spending and zero leave observations.

Both specifications include country and year fixed effects, country-specific linear trends, and panel-corrected standard errors (PCSE) with a common AR(1) process.

| PCSE specification | Childcare coefficient | Standard error | p-value | Country-years |
|---|---:|---:|---:|---:|
| Main, unwinsorized | −0.484 | 0.136 | 0.0004 | 347 |
| All five continuous variables winsorized | −0.490 | 0.134 | 0.0002 | 347 |

The main model uses the observed values. Capping the five continuous variables at the 1st and 99th percentiles changes the estimate only slightly. At childcare spending of 0.5% of GDP, a 1% relative increase in spending is associated with an estimated 0.16% relative reduction in the employment gap. The estimates describe conditional associations.

- [Formatted Word tables](tables/oecd_childcare_pcse.docx)
- [Stata results log](log_files/oecd_childcare_live_results.log)
- [Canvas submission text](docs/SUBMISSION_STATUS.md#ready-to-paste-canvas-comment)
- [Course rubric](docs/RUBRIC_REDLINES.md)

The earlier numbered do-files and their associated tables document the prior level specification. Use the standalone do-file and linked tables above for the current log specification.
