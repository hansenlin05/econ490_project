# Research question — official statement and direction-level red lines

Last updated 16 November 2026. This file states the team's research question
and the rules that protect it. It exists because two review rounds (a pull
request closed on 15 November and a side branch found on 16 November) replaced
the research question itself — a different main explanatory variable, a
rewritten README, a different topic — while every code-level rule was followed.
Code compliance does not make a direction change acceptable.

## 1. The official research question (team wording)

> We ask whether the gender employment gap among adults living with children
> is smaller in countries where fathers hold individual paid leave rights.
> It is a comparison across 23 European countries from 2006 to 2019.

- Dependent variable: the male-minus-female employment rate among 25-54
  year-olds living with children (Eurostat household-type series, Europe
  panel; ILOSTAT household series, OECD extension panel).
- Main explanatory variable: **father-specific, individual, non-transferable
  paid leave weeks, lagged one year** (`lag_fatherweeks10`, weeks per 10).
- Hypothesis (H1): the gap is smaller where fathers hold such rights; the
  predicted coefficient sign is **negative**.
- Mechanism: household time allocation (the Becker model of the family).
  Reserved, use-it-or-lose-it rights change the relative price of each parent
  staying home, so households shift some leave to the father, the mother keeps
  her job attachment, and her employment rises.

This wording is the team's official answer set for the oral exams, the Canvas
comments and the paper. Do not reword the question, the hypothesis or the
mechanism.

## 2. Direction-level red lines

These sit **above** the code rules in `docs/CODE_CONVENTIONS.md` and the frozen
decisions in `README.md` §5. A pull request that crosses any line below is
closed with a written reason, however clean the code is.

| # | Red line | Why |
|---|---|---|
| R1 | **Do not replace the main explanatory variable.** Childcare spending, maternity leave, total parental leave or any other measure is a different research question | The hypothesis, the subset theory, the histograms, the build-up table and the 11 Dec paper are all built around father-specific leave. Changing the variable restarts the project |
| R2 | **Do not swap the primary and extension samples.** Europe (23 countries, 2006-2019) stays primary; OECD (26 countries, 2000-2024) stays an extension; never pooled | Frozen in `README.md` §5.1; the two panels use different outcome definitions |
| R3 | **Do not select a specification because it is significant.** Country-specific linear trends, alternative lag lengths, dropped controls or dropped countries chosen "after exploratory comparisons" are specification search | The rubric requires "a single properly specified regression" (10 pts) and subsets "dedicated by the economic theory" (10 pts). Choosing a model by its p-value is the opposite of both |
| R4 | **Do not treat significance as a grading criterion.** The rubric's hypothesis item reads "whether or not the results support the hypothesis" (5 pts); answering "no" earns full marks | Our result is a positive, not robustly significant association — opposite in sign to H1. That is the finding; it is reported as such |
| R5 | **Do not reintroduce retired results.** Every historically significant p-value came from unclustered SEs or the broken lag construction and is void | `docs/RESEARCH_DECISIONS.md` §2, "Retired results" paragraph |

## 3. What happened twice, and why these lines exist

- **15 Nov 2026:** a pull request made the OECD panel the primary analysis and
  rebuilt the leave lag outside the policy panel, reverting a verified fix.
  Closed unmerged.
- **16 Nov 2026:** a side branch replaced the main explanatory variable with
  public early-childhood spending and added country-specific linear trends
  "selected after exploratory comparisons". The reported p = 0.0070 exists only
  with those trends: without them the same sample gives +1.159 (p = 0.6904),
  and keeping the trends but dropping one country gives p = 0.069. Closed
  unmerged.

Both rounds followed the code rules. The failure was directional, which is why
this file now exists.

## 4. Direction change versus code change

A **code-level change** — comments, table formatting, export options, an added
robustness column that does not touch the headline model — can be proposed in
a pull request and reviewed normally against `README.md` §2.

A **direction-level change** — anything on the red-line list above, a new
dependent variable, a new research question, a new primary specification —
requires all three of:

1. a written team decision by all three members, recorded in
   `docs/RESEARCH_DECISIONS.md`;
2. a full rerun of the chain from `data_raw` with every reported number
   re-derived, so the logs stay the only evidence base;
3. matching updates to the ready-to-paste Canvas comments in
   `docs/SUBMISSION_STATUS.md` and to the 11 Dec paper outline.

No assistant may perform step 1 on the team's behalf. If an assistant believes
a direction change is warranted, it writes the proposal and stops there.
