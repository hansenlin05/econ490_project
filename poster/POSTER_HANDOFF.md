# Poster Handoff Guide — childcare_poster_261125

This document is the self-contained continuation guide for the ECON 490 Team 2
research poster (`poster/childcare_poster_261125.pptx/.pdf/.png`). It records
the current design system, the content that must never change, where every
number and figure comes from, the edits that were evaluated and rejected, and
the workflow used to edit, render, verify, and sync the poster. Read it fully
before changing anything.

## 1. Deliverables and current state

- `poster/childcare_poster_261125.pptx` — single slide, 48 x 36 in, 100 shapes, all fonts Arial.
- `poster/childcare_poster_261125.pdf` — exported with LibreOffice headless, one page 48 x 36 in.
- `poster/childcare_poster_261125.png` — rendered from the PDF at 200 dpi (9600 x 7200).
- The OneDrive team-share copy under `econ490_project/` is the authoritative
  version; this GitHub repository is a mirror for collaborators. When the two
  disagree on checksums, compare actual content first: OneDrive rewrites file
  metadata and changes hashes without changing content.

## 2. Design system

### 2.1 Color palette (do not add colors)

- Header bars and title band: dark teal `#185A58` (solid fill, white Arial text).
- Mid-teal accent `#338078` (small panels/labels), Q1–Q4 labels `#147D87`.
- Body text: dark navy `#17364B` on white panels.
- Exactly one accent element: the headline number "≈ 3% smaller gap" in orange
  `#B85414`, 60 pt. Everything else stays in the teal/navy family. A previous
  one-off yellow highlight on a sub-heading was removed for this reason.
- Total palette is four colors + white; keep it that way.

### 2.2 Font-size tiers (integer pt only)

| Tier | Size | Used for |
|---|---|---|
| Title | 72 | Two-line title in top band |
| Section headers | 36 | White text in teal header bars |
| Sub-headings | 30–33 | Panel sub-headings |
| Sub-labels | 25–26 | Panel kickers, figure titles, table section labels |
| Body and tables | 24 | All body text, both results tables, stat rows |
| Auxiliary | 22 | Variable-definition legend, policy timeline |
| Captions | 20 | Figure source caption |

Rules: never use fractional pt sizes; never put body or table text below
24 pt; auxiliary text (legends, timelines) at 22 pt and captions at 20 pt are
the accepted minimums. Before enlarging any text, estimate the rendered height
as roughly 1.35–1.4 × the font size per line (including cell padding) and
check it fits the panel, because LibreOffice renders taller than PowerPoint's
declared row heights.

### 2.3 Layout skeleton

Three columns on a 48 x 36 in canvas (inches, approximate):

- Title band across the top (~0.4–4.2).
- Left column x ≈ 0.6–13.5: Research question (Q1–Q4), Principal finding,
  Why childcare can narrow the gap (theory, policy timeline, hypothesis),
  Data and measurement, Country coverage and sample selection, Adjusted
  spending scatter.
- Middle column x ≈ 13.75–33.9: Panel model and variable transformations
  (formula + legend), Childcare estimates as controls enter (table + buildup
  chart), Country-specific employment trends (two panels), Results with and
  without national trends (two tables).
- Right column x ≈ 34.15–47.4: Principal finding recap, Interpretation of the
  main estimate (orange headline), Model diagnostics table, What the
  robustness checks tell us (mechanism table + robustness table), Policy
  implications, Further reading (QR code).
- Table row heights are set explicitly: mechanism table 0.55 in, robustness
  table 0.50 in per row at 24 pt. Panels below were positioned to match; if
  you change table font sizes, re-flow the whole column, not just the table.

## 3. Content invariants (never change without re-checking against the paper and logs)

- Title: "Minding the Gap: Public Childcare Spending & the Gender Employment
  Gap". The outcome is always the **gender** employment gap (never
  "parental"); wording matches the paper title.
- Authors line: "Zewen Jin · Hanzheng Lin · Sultana Razia | Team 2, ECON 490 |
  Vancouver School of Economics, UBC".
- Headline estimate: β = −0.472 (SE 0.135), p < 0.001 (precise p = 0.0005);
  headline translation "≈ 3% smaller gap" for 0.5%→0.6% of GDP.
- Mechanism table: mothers +0.113 (0.073), p = 0.123; fathers −0.033 (0.028),
  p = 0.245; father–mother gap −0.472 (0.135), p < 0.001.
- Robustness table: data through 2019 (N=307) −0.441**; drop any one country
  −0.550 to −0.372*; winsorized 1st/99th −0.479**; EU-target countries
  (N=309) −0.447**; other OECD members (N=38) −0.198; with next-year spending
  (N=330) −0.425**. Stars: ** p<0.01, * p<0.05.
- Sample framing: 23 OECD countries in the estimation sample (N = 347
  country-years, 2001–2023); 12 excluded without matching parental employment
  records; 3 without matched leave spending (Costa Rica, Mexico, United
  States).
- Model formula (Unicode subscripts, mother/father leave weeks divided by 10):
  ln(Gapᵢ,ₜ) = β₀ + β₁ ln(1 + Childcareᵢ,ₜ₋₁) + β₂ ln(1 + FatherWeeksᵢ,ₜ₋₁/10)
  + β₃ ln(1 + MotherWeeksᵢ,ₜ₋₁/10) + β₄ ln(GDPpcᵢ,ₜ₋₁) + β₅ ln(LeaveSpendᵢ,ₜ)
  + αᵢ + λₜ + δᵢ(t − 2010) + εᵢ,ₜ. Estimator: Prais–Winsten (xtpcse het
  corr(ar1)), country and year fixed effects, country-specific linear trends
  with 2010 as reference year.
- QR code: points to the Google Drive copy of the reference list
  (https://drive.google.com/file/d/1On3paI5UJayycj6gCgeUHNSO8PpcRDI1/view).
  To update the reference list, overwrite that Drive file in place — deleting
  and re-uploading breaks the link and the QR.
- Diagnostics: country effects F(22,276)=56.83 p<0.001; year effects joint
  p=0.134; heteroskedasticity χ²(23)=4213.28 p<0.001; serial correlation
  p=0.0006.

## 4. Where every number and figure comes from

- All statistics come from the Stata chain (`do_files/0_master_261109.do`
  calling `1_build_data` … `6_additional_checks`); the authoritative log is
  `log_files/econ490_all_261109.log`. The precise p-values in the mechanism
  table come from `testparm` blocks appended to
  `do_files/6_additional_checks_261125.do` (χ²(1): 12.17 / 2.38 / 1.35 →
  0.0005 / 0.1233 / 0.2446). Rerun the chain and check the log before
  quoting any new number.
- The five poster figures are all generated by
  `do_files/poster/childcare_poster_figures_261125.do`:
  - `stata_sample_coverage.png` → left column, sample selection
  - `stata_adjusted_scatter.png` → left column bottom
  - `stata_buildup_graph.png` → middle column, controls-enter panel
  - `stata_country_paths.png` and `stata_country_slopes.png` → middle column
- The paper chain also emits `figures/scatter_gap_childcare_261109.png`
  (raw bivariate scatter) and `figures/scatter_adjusted_261125.png`. The raw
  scatter was deliberately not added to the poster: the adjusted scatter
  already carries the association story. Keep the poster at five content
  figures plus the QR code.

## 5. Evaluated and rejected — do not reintroduce

- Baker, Gruber & Milligan (2008) as a citation: wrong source; the childcare–
  maternal-employment reference is Borowsky et al. (2022), NBER WP 30140.
- A coefficient of −0.075: no source anywhere in the logs; the headline is
  −0.472.
- A constructed "theoretical formula" for the gap: no literature source
  (checked across the full reference list; Borowsky's production function is
  a childcare-inputs function, not a gap equation). The estimating equation
  above is the model.
- "Parental Employment Gap" phrasing and any parent-split headline: conflicts
  with the paper's terminology.
- Fractional font sizes and body/table text below 24 pt: rejected for
  readability; the UBC reference posters show no hard rubric rule, but the
  project convention above is binding.
- Additional accent colors (e.g., a second highlight color): the single
  orange headline is the intended emphasis device.
- Archived/alternative decks: an earlier collaborator redesign lives at the
  OneDrive share root (`final poster.pptx`). Its figures come from the same
  do-files, but the deck itself is superseded; do not merge it wholesale.

## 6. Editing and verification workflow

1. Before editing, confirm nobody has the file open (no `~$` lock files) and
   pull the latest from the authoritative OneDrive copy.
2. Edit the pptx (PowerPoint or a script). After any structural change,
   re-check: single page, no shape off-canvas, no text overlapping a header
   bar, every table's last row fully visible above the next section header.
   Inspect region-by-region crops of the rendered output, not just the full
   page — a clipped table row is invisible at full-page zoom.
3. Re-render the PDF: delete the old PDF first, then convert with LibreOffice
   headless (it does not reliably overwrite an existing PDF), then render the
   PNG at 200 dpi.
4. Verify invariants: title/author line unchanged, headline −0.472 and
   "≈ 3% smaller gap" present, table values match Section 3, five figures +
   QR present with unchanged image bytes, no banned strings from Section 5.
5. Sync: copy the pptx/pdf/png trio to both the OneDrive share
   (`econ490_project/poster/`) and this repository, then commit. Compare
   content (shape-by-shape) when checksums disagree across OneDrive; OneDrive
   hash changes alone do not mean someone edited the file.
6. Commit messages describe research content only (what changed on the
   poster and why), with no process narration.

## 7. Open (optional, low priority) items

- Rounded panel corners: no reference or rubric rule governs box shape;
  rounding is permissible but low value. Circles are not suitable for content
  panels.
- The title uses a two-line hook construction that is unusual among the UBC
  reference posters (all descriptive titles); it was kept deliberately for
  attention and matches the paper terminology. Revert to the plain descriptive
  title if a reviewer objects.
