# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-08-01

### Added

- ARDL(4,2,1) headline inflation equation and ARDL(4,1,1) food & NAB equation,
  estimated with HAC standard errors over 2009 Q2 – 2026 Q1.
- Exchange-rate, oil and food pass-through scalars (ERPT, OPT, FPT).
- Rolling 40-quarter window estimation producing time-varying pass-throughs.
- Impulse-response decomposition of headline CPI into FX, oil and food channels.
- Domestic Inflationary Pressure Index (DIPI) as the residual of that
  decomposition, annualised as a rolling four-quarter sum.
- Hold-constant projection through 2027 Q4 and mild/moderate/severe Brent shock
  scenarios.
- Published exhibits in `graphics/exhibits/`.
- Project scaffolding: Poetry, Ruff, mypy, pytest, pre-commit, GitHub Actions CI.

### Notes

- A linked shock scenario propagating a Brent shock through FAO and NEER was
  investigated and dropped: the empirical basis did not support it. Brent and the
  rand were found to co-move rather than move inversely, and the Brent-to-FAO
  link, while correctly signed, was weak (R² ≈ 0.22).
