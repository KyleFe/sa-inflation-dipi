# Contributing

Thanks for your interest. This is a personal research project, so the scope is
narrow — but corrections to the econometrics, bug reports and methodological
critique are genuinely welcome.

## Ground rules

- **Do not add proprietary data or documents.** No vendor research reports, no
  licensed data files. If a source cannot be redistributed, cite it instead.
- **Do not commit `.env` or database files.** Both are gitignored. Point the
  notebook at your own data via `DUCKDB_DIR`.

## Getting set up

```bash
poetry install --with dev
poetry run pre-commit install
cp .env.example .env    # then set DUCKDB_DIR
```

## Before you open a pull request

```bash
make ci
```

That runs `ruff check`, `ruff format`, `mypy src` and `pytest`. CI runs the same
four checks plus a verification that notebook outputs have been stripped.

## Notebooks

Notebook outputs are stripped by the `nbstripout` pre-commit hook, and CI fails if
an unstripped notebook is committed. Install the hooks and this is handled for
you. If you need to strip manually:

```bash
poetry run nbstripout notebooks/*.ipynb
```

Only `notebooks/01_dipi_model.ipynb` is tracked. Exploratory notebooks are
excluded by `.gitignore` by design — please don't add more to the repository.

## Branches

`main` is the release branch. `uat` and `dev` are the integration branches that CI
is configured around. Open pull requests against `dev` unless the change is a
documentation-only fix.

## Reporting issues

Use the issue templates. For a methodological objection, please state the
specification, the sample and the result you would expect — it makes the
discussion much faster.
