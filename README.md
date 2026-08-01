# gs-dipi — Decomposing South African Inflation

[![CI](https://github.com/KyleFe/gs-dipi/actions/workflows/ci.yml/badge.svg)](https://github.com/KyleFe/gs-dipi/actions/workflows/ci.yml)
[![Python 3.14](https://img.shields.io/badge/python-3.14-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Code style: ruff](https://img.shields.io/badge/code%20style-ruff-261230.svg)](https://github.com/astral-sh/ruff)

An ARDL-based decomposition of South African headline CPI into its **external**
drivers — the exchange rate, oil and global food prices — and a residual
**Domestic Inflationary Pressure Index (DIPI)** read as a proxy for underlying
domestic price pressure.

> **Disclaimer.** This is an independent replication and extension of a published
> Goldman Sachs research methodology, built for personal research purposes. It is
> **not affiliated with, endorsed by, or connected to Goldman Sachs** in any way.
> No proprietary Goldman Sachs code, data or documents are contained in this
> repository. Nothing here is investment advice.

---

## Motivation

Headline inflation is a poor read on domestic demand pressure, because a large
share of its variance is imported. Between 2021 and 2026 South African headline
CPI made a full round trip — from below 3% to a 7.46% peak in 2022 Q3 and back to
3.17% in 2026 Q1 — while the underlying domestic component moved far less. If you
want to know whether a disinflation reflects genuinely weaker domestic demand or
a transitory external tailwind, you need to strip the external channels out.

That matters more than usual right now: the SARB replaced its 4.5% midpoint and
3–6% band with a 3% point target and a 2–4% band in 2026 Q1, so a near-target
headline print can flatter a domestic gauge sitting materially higher in the new
band.

## Method

Two ARDL equations are estimated on quarterly q/q data, both with HAC standard
errors.

**Headline equation** — headline inflation on its own lags, the nominal effective
exchange rate and Brent:

$$\pi_t = \alpha + \sum_{i=1}^{4}\beta_i\pi_{t-i} + \sum_{j=0}^{2}\gamma_j\Delta NEER_{t-j} + \sum_{k=0}^{1}\delta_k\Delta Oil_{t-k} + \varepsilon_t$$

**Food & NAB equation** — food inflation on its own lags, the FAO Food Price
Index, and USD/ZAR as a control:

$$\pi_t^{food} = \alpha + \sum_{i=1}^{4}\beta_i^{food}\pi_{t-i}^{food} + \sum_{k=0}^{1}\theta_k\Delta FAO_{t-k} + \sum_{k=0}^{1}\phi_k\Delta USDZAR_{t-k} + \varepsilon_t$$

The USD/ZAR terms exist only to strip currency effects out of the
dollar-denominated FAO index and are **deliberately excluded** from the food
pass-through scalar.

Long-run sensitivities are summarised in three pass-through scalars:

$$ERPT = -\frac{\sum_j\gamma_j}{1-\sum_i\beta_i}, \quad OPT = \frac{\sum_k\delta_k}{1-\sum_i\beta_i}, \quad FPT_{headline} = \frac{\sum_k\theta_k}{1-\sum_i\beta_i^{food}} \times w_{food}$$

The denominator is the long-run multiplier — because inflation feeds on its own
lags, an impulse is amplified by the persistence in the AR coefficients. The
leading minus sign on ERPT reflects the IMF NEER convention (a *rise* in the index
is an appreciation), so the scalar reports the response to a *depreciation*. The
food scalar is rescaled by the food & NAB basket weight so it enters headline on a
comparable footing.

Both equations are then re-estimated over a **rolling 40-quarter window** with lag
orders held fixed at their full-sample selected values, producing time-varying
pass-through scalars. Impulse responses over a 12-quarter horizon convert each
channel's actual driver moves into a quarterly contribution to headline. The
**DIPI is the residual** once those three external contributions are subtracted
from headline. All series are annualised as a rolling four-quarter sum for
comparison against the SARB's yoy target band.

**Selected specifications:** ARDL(4,2,1) for headline, ARDL(4,1,1) for food & NAB.
Sample 2008 Q2 – 2026 Q1; effective estimation sample 2009 Q2 onward after the
four-quarter lag structure.

## Data

| Series | Source | Notes |
|---|---|---|
| Headline CPI (`CPS00000`) | Stats SA | Monthly → quarterly mean |
| Core CPI (`CPS00014`) | Stats SA | |
| Food & NAB CPI (`CPS01000`) | Stats SA | Basket weight ≈ 18.2% |
| Nominal effective exchange rate | BIS / IMF | Rise = appreciation |
| Brent crude (USD) | Commodity price data | |
| FAO Food Price Index (`FFPI`) | UN FAO | Nominal index |
| USD/ZAR | Exchange rate data | Food-equation control only |

Every series is native monthly, resampled to quarterly as the mean of its
constituent months, then converted to q/q percentage change.

**The source databases are not distributed with this repository.** The notebook
reads six read-only DuckDB files whose location is supplied via the `DUCKDB_DIR`
environment variable:

```
country_info.duckdb              inflation.duckdb
fao.duckdb                       commodity_prices.duckdb
effective_exchange_rates.duckdb  exchange_rates.duckdb
```

To run the notebook you will need to build equivalent databases from the public
sources above. The SQL in the first few cells documents the exact schema each
query expects.

## Getting started

```bash
# 1. Install dependencies
poetry install --with dev

# 2. Point the notebook at your DuckDB databases
cp .env.example .env
$EDITOR .env          # set DUCKDB_DIR

# 3. Install git hooks (ruff + nbstripout)
poetry run pre-commit install

# 4. Launch
poetry run jupyter lab notebooks/01_dipi_model.ipynb
```

## Repository layout

```
notebooks/01_dipi_model.ipynb   Full model: ingest → estimate → decompose → chart
graphics/exhibits/              Published exhibits produced by the notebook
graphics/                       Working charts
src/gs_dipi/                    Package scaffold
tests/                          Test suite
```

Notebook outputs are stripped on commit via `nbstripout`, so the `.ipynb` diffs
stay readable. Rendered figures live in `graphics/` instead.

## Exhibits

| Exhibit | Content |
|---|---|
| `exhibit_04_decomposition.png` | Headline CPI decomposed into FX, oil, food and DIPI |
| `exhibit_04b_headline_core_dipi.png` | Headline, core and DIPI, full sample |
| `exhibit_05_passthrough.png` | Time-varying ERPT, OPT and FPT |
| `exhibit_06_dipi_vs_target.png` | DIPI against the SARB target regimes |
| `exhibit_07_hold_constant.png` | Hold-constant projection to 2027 Q4 |
| `exhibit_08_oil_scenarios.png` | Mild / moderate / severe Brent shock scenarios |
| `exhibit_A1–A3_irf_*.png` | Impulse responses for oil, FX and food |

## Development

```bash
make lint        # ruff check
make format      # ruff format
make typecheck   # mypy src
make test        # pytest with coverage
make ci          # all of the above
```

CI runs the same checks on every push and pull request, and verifies that
notebook outputs have been stripped.

## Reference

The methodology replicated here is from:

> Gedminas, T. and Daly, K. (2021). *EM Macro Themes: Modelling EM Inflation —
> Domestic Weakness, But Commodities to Drive Headline Higher.* Goldman Sachs
> Economics Research, 16 March 2021.

That report is proprietary and is **not** redistributed in this repository. The
implementation, the South African application, the rolling-window extension and
the scenario analysis are original work.

## License

Code is released under the [MIT License](LICENSE). Figures in `graphics/` are the
author's own output and may be reused with attribution.
