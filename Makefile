install:
	poetry install --with dev

lint:
	poetry run ruff check .

format:
	poetry run ruff format .

typecheck:
	poetry run mypy src

test:
	poetry run pytest

ci: lint format typecheck test

pre-commit:
	poetry run pre-commit run --all-files

.PHONY: install lint format typecheck test ci pre-commit
