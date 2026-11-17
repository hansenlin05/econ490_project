# Data citations and the official "How to cite" rules

Last updated 14 November 2026. The 18 Nov assignment gives 4 points for "All
data sets are properly cited in the annotations" and item 1 requires "the
citation for all of your data in the do file". This document records where the
citation format came from and the exact strings now used in
`1_build_data_261109.do` (`* Data sources` block).

**Access dates (local date, MST): 14 November 2026 for ILOSTAT, the OECD
Family Database PF2.5 workbook and the World Bank WDI extract; 16 November
2026 for OECD SOCX** (both SOCX programme extracts were downloaded and frozen
in `data_raw/` on 16 November 2026 and the citation block matches the
do-file).
Version / last-update information below was read from the publisher pages and
from the PDFs the team saved as evidence (their filenames are listed at the
end).

## 1. Where the "How to cite" rules come from

| Publisher | Official guidance | Verbatim format |
|---|---|---|
| OECD | "OECD Style Guide (Fourth Edition)", section 2 "Bibliographical references, citations and notes", subsection "Citing data (including for OECD Data Explorer)" — https://www.oecd.org/en/publications/oecd-style-guide-fourth-edition_2ca15c7e-en/full-report/component-5.html | Dataset: `Author (Year or n.d.), Dataset Title: Dataset Subtitle (dataset), Unique URL for identifier (accessed on Day Month Year).` Example given: `OECD (2025), Main Science and Technology Indicators (dataset), https://data-explorer.oecd.org/s/2dc (accessed on 7 July 2025).` The same page's Eurostat example uses a DOI: `Eurostat (2023), Population on 1st January by Age, Sex and Type of Projection (dataset), https://doi.org/10.2908/PROJ_23NP (accessed on 7 July 2025).` |
| ILO / ILOSTAT | "Dissemination and analysis" → "Citations" — https://ilostat.ilo.org/about/dissemination-and-analysis/ | "ILOSTAT data are free to use and should be cited as follows regardless of the data tool used to access the data." Chicago: `International Labour Organization, "ILO modelled estimates database," ILOSTAT, Accessed 14-02-2022, https://ilostat.ilo.org/data/.` APA: `International Labour Organization. (2020). ILO modelled estimates database, ILOSTAT [database]. Available from https://ilostat.ilo.org/data/.` |
| World Bank | "Summary Terms of Use" — https://data.worldbank.org/summary-terms-of-use | "You must include attribution for the data you use in the manner indicated in the metadata included with the data. Generally, you agree to provide attribution to The World Bank and its data providers in the following format: The World Bank: Dataset name: Data source (if known)." World Bank reproducibility packages cite the DataBank WDI dataset as `World Bank. "World Development Indicators" [dataset]. https://databank.worldbank.org/source/world-development-indicators. Accessed <month year>.` (example at https://reproducibility.worldbank.org/catalog/604) |
| European Commission / Eurostat | "Data citation" in the EU data-provider manual — https://dataeuropa.gitlab.io/data-provider-manual/data-citation | `European Commission, Eurostat, 'Real GDP growth rate – volume' (tec00115), updated 18 September 2021, https://ec.europa.eu/eurostat/databrowser/view/tec00115/default/table?lang=en`. The page also documents the "Cite" button that generates EU Data Citation / APA / Harvard / Vancouver strings. Dataset DOIs are explained at https://ec.europa.eu/eurostat/web/user-guides/data-browser/blockchain-pilot/anchoring-datasets : prefix `10.2908` plus the dataset code |
| OECD SOCX | "Cite this dataset" on the OECD Social Expenditure Statistics data page — https://doi.org/10.1787/data-00167-en | `OECD`, years covered 1980 onwards, DOI `10.1787/data-00167-en`. Landing page of the current SOCX release: https://www.oecd.org/en/data/datasets/social-expenditure-database-socx.html |

The do-file uses AER / Chicago author-date form (institution, year, dataset
title, publisher, URL, access day), which is consistent with all five of the
above and with the paper's AER-style bibliography requirement.

## 2. The four citation strings now in `1_build_data_261109.do`

Only these four external sources are actually read by the do-file. Both SOCX
programmes (TP521 childcare and TP512 maternity and parental leave spending)
come from the same SOCX release and were frozen in `data_raw/` on the same
day, so the two policy spending controls share one versioned source. Variables
that exist in the retired policy donor file but are never read (wage
replacement rates, nominal GDP, unemployment, total fertility) are **not**
cited as used sources. The Eurostat series the earlier father-leave chain used
is no longer read by any do-file and is therefore no longer cited.

1. **ILOSTAT** — `International Labour Organization. 2026. "Employment rate by
   sex and household composition" [GED_PEPR_SEX_HHT_CHL_RT_A] (database),
   ILOSTAT. Geneva: ILO. https://ilostat.ilo.org/data/ (accessed 14 November
   2026).`
2. **OECD SOCX** — `OECD. 2026. Social Expenditure Database (SOCX) (dataset),
   public spending on early childhood education and care (TP521) and on
   maternity and parental leave (TP512), percent of GDP. Paris: OECD.
   https://doi.org/10.1787/data-00167-en (accessed 16 November 2026).`
3. **OECD Family Database PF2.5** — `OECD. 2026. "PF2.5 Trends in leave
   entitlements around childbirth" (dataset), OECD Family Database, updated
   November 2026. Paris: OECD.
   https://webfs.oecd.org/els-com/Family_Database/PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx
   (accessed 14 November 2026).`
4. **World Bank WDI** — `World Bank. 2026. World Development Indicators
   (dataset), NY.GDP.PCAP.KD and NY.GDP.MKTP.KD.ZG, last updated 11 November
   2026. Washington, DC: World Bank.
   https://databank.worldbank.org/source/world-development-indicators
   (accessed 14 November 2026).`

## 3. Version evidence saved by the team (PDF filenames)

- `DataBank _ The World Bank.pdf` — DataBank home page; "World Development
  Indicators was updated on November 11, 2026"; "Last Updated: 11/11/2026";
  "© 2026 The World Bank Group".
- `webfs.oecd.org - _Els-com_Family_Database_.pdf` — directory listing of the
  OECD Family Database; `PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx`
  and its PDF are timestamped 11/5/2026.
- `PF2_5_Trends_in_leave_entitlements_around_childbirth.pdf` — "UPDATED:
  NOVEMBER 2026", "OECD Family Database, oe.cd/fdb", covers 1970-2026; its
  "Further Reading" cites EU Directive (EU) 2019/1158, part of the EU policy
  context that separates the EU childcare-targets group from the other OECD
  members in the subset table.
- `[lfst_hhacwnc] Adults by number of children, age of youngest child and
  labour status.pdf` — Eurostat Data Browser page: "Online data code:
  lfst_hhacwnc | DOI: 10.2908/lfst_hhacwnc | last update: 10/09/2026 15:00".
  Kept as version evidence only; the series itself is no longer read by the
  current chain.
- `Econometric Files for Final Paper.pdf` — the assignment that requires the
  citations.

## 4. Two rules that follow from this

- Cite the frozen snapshot that the do-file actually reads; official sites are
  provenance, not run-time inputs. Do not switch the do-file to live URLs
  (see `docs/RESEARCH_DECISIONS.md` §4).
- If a citation changes, the do-file changes, so the whole chain must be rerun
  to keep the log consistent with the do-file.

## 8. Snapshot vintages and the 15 November refresh check

The five sources in `data_raw/` are frozen files, so their vintage matters as
much as the citation string. On 15 November every source was queried again to
see whether a newer release changed anything we use.

| Source | Publisher version on 15 Nov 2026 | Local snapshot | Outcome |
|---|---|---|---|
| Eurostat `lfst_hhacwnc` | dataset `updated: 2026-09-10` (Eurostat API metadata) | 4 Nov 2026 | no newer release exists; unchanged |
| OECD PF2.5 | file `Last-Modified: 5 Nov 2026 08:56 GMT`, 272,022 bytes | **replaced with the 5 Nov file** | 2,128 overlapping country-years, **0 changed cells** in `total_all_raw` and `total_paid_raw`; the new file only adds 2025 rows, which `keep if inrange(year,1970,2024)` drops |
| ILOSTAT `GED_PEPR_SEX_HHT_CHL_RT_A` | bulk download `GED_PEPR_SEX_HHT_CHL_RT_A-20261116T0002.csv.gz`, whence 18,854,904 bytes and 169,679 rows over 2000-2026 | 4 Nov 2026 | **re-downloaded on 15 Nov and byte-for-byte identical**, md5 `e45765c52e64a428dc28819e9d06e5a0` for both files. The API endpoint on `rplumber.ilo.org` still answers HTTP 200 with `Content-Length: 0`, so only the bulk download works |
| World Bank WDI | API `lastupdated: 2026-11-11` | 4 Nov 2026 `.dta` | 14,561 overlapping cells for GDP per capita and 14,388 for GDP growth, **0 differences above 1e-9**. The file is kept as is: it carries 14 variables including the World Bank metadata columns, and rebuilding it would change bytes without changing a single number |
| OECD SOCX donor | no public version stamp on the donor extract | 9 Nov 2026 | unchanged |

The ILOSTAT check is the strongest of the five: the freshly downloaded file is
byte-for-byte the same as the snapshot, not merely equal cell by cell, so no
value comparison was needed. The API route quoted in earlier notes returns an
empty body; the bulk download route does not. What that changes is only the
explanation of why the do-file reads a snapshot — reproducibility, not
unavailability.

After replacing the PF2.5 workbook the whole chain was rerun from `data_raw`:
all four analysis CSVs and both table CSVs kept their md5, the four logs kept
their line counts, and no `r()` error appeared. So the two November releases are
value-neutral for this project, and the numbers in the paper are unaffected.

The practical rule this establishes: a source update is adopted only if it
changes a value we use. If it does not, the snapshot stays and the citation
continues to describe the dataset, not the day the file was copied.
