# OECD Childcare Analysis Submission

The [standalone Stata do-file](../oecd_childcare_live.do) reproduces the current
analysis from four locally downloaded input files. The [formatted Word
tables](../tables/oecd_childcare_pcse.docx) and [Stata results
log](../log_files/oecd_childcare_live_results.log) document the current
log specification. See the [README](../README.md) for input filenames and
run instructions.

## Ready-to-paste Canvas comment

Our results support the hypothesis that higher public childcare spending is
associated with a smaller male-minus-female employment gap among parents in
couple households with children under six. The estimation sample contains
347 country-years from 23 OECD countries from 2001 to 2023. The main regression
uses panel-corrected standard errors with a common AR(1) process, country and
year fixed effects, and country-specific linear trends. The coefficient on
the log of one plus prior-year childcare spending is −0.484
(p = 0.0004). At childcare spending of 0.5% of GDP, a 1% relative increase in
spending is associated with an estimated 0.16% relative reduction in the
employment gap.

We prefer the unwinsorized regression because it uses the observed values.
Repeating the same regression on the same sample after capping all five
continuous variables at the 1st and 99th percentiles gives a childcare
coefficient of −0.490 (p = 0.0002). The estimates describe conditional
associations.

We matched the files by three-letter country code and year. After matching
employment, father’s leave and GDP, the panel had 520 country-year records.
The OECD spending merge matched 470, with 50 records appearing only in the
employment panel and 539 appearing only in the spending file. These unmatched
records lacked a corresponding country and year in the other file. Requiring
observed values for the outcome, childcare and all controls excluded a further
123 records, leaving 347 observations. We constructed lags within each source
before merging.

The modified Wald test and the Wooldridge test detected groupwise
heteroskedasticity (p < 0.001) and serial correlation (p = 0.0007),
respectively. The fixed-effects diagnostic supported country effects
(p < 0.001). We kept year effects to account for common shocks across
countries. Their joint test gave p = 0.1232.

## Submission checks

- Submit the do-file, log and Word tables that match the same model.
- Confirm the required formats for the data attachments and the rendered
  log page count in Canvas. The local reproduction folder uses an Excel
  workbook and a Stata data file among its four inputs.
- Review the remaining rubric tables and figures for consistency with the
  current specification before uploading them.
