---
name: local-sql-analytics
description: Analyze local CSV, Parquet, JSON, SQLite, and exported business/SEO datasets with embedded SQL tools, especially DuckDB on Termux, without loading everything into pandas.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, android-termux, macos, windows]
metadata:
  hermes:
    tags: [duckdb, sql, analytics, csv, parquet, json, termux, data-analysis]
---

# Local SQL Analytics

Use this skill when the user wants to inspect, summarize, join, clean, or convert local tabular data: CSV exports, Parquet files, JSON/JSONL, analytics/search-console/ads exports, product feeds, price lists, logs, or SQLite-style local databases.

Prefer an embedded SQL tool when the task is mostly filtering, grouping, joining, schema inspection, or conversion. For large files, avoid loading the whole dataset into pandas unless Python-specific processing is necessary.

## Default tool choice

1. DuckDB CLI for local analytics, especially on Termux.
2. Python `duckdb` package only in an isolated project venv when Python API is required and install compatibility is verified.
3. SQLite for app-state DBs and transactional/local relational stores.
4. pandas/Polars when the workflow needs custom Python transformations, plotting, or in-memory dataframe APIs.

## Termux / Android guidance

On Termux, prefer the native package manager for DuckDB:

```sh
pkg search duckdb
pkg install duckdb
```

Then smoke test:

```sh
duckdb -c "SELECT 42 AS ok;"
```

Avoid installing `duckdb` into the main Hermes venv/global with `pip install duckdb` as the first move. PyPI wheels commonly target manylinux/macOS/Windows, not Android/Termux; pip can fall back to source builds or incompatible binaries. If a Python API is needed, test it in a throwaway venv first.

See `references/duckdb-termux-local-analytics.md` for the inspected repo/package facts and a safe install/evaluation pattern.

## Common workflows

### Inspect a CSV quickly

```sh
duckdb -c "DESCRIBE SELECT * FROM 'file.csv';"
duckdb -c "SELECT count(*) AS rows FROM 'file.csv';"
duckdb -c "SELECT * FROM 'file.csv' LIMIT 10;"
```

### Aggregate business/export data

```sh
duckdb -c "
SELECT category, count(*) AS rows, sum(revenue) AS revenue
FROM 'sales.csv'
GROUP BY category
ORDER BY revenue DESC;
"
```

### Query multiple files

```sh
duckdb -c "SELECT * FROM 'exports/*.csv' LIMIT 20;"
```

### Convert CSV to Parquet

```sh
duckdb -c "COPY (SELECT * FROM 'input.csv') TO 'output.parquet' (FORMAT PARQUET);"
```

### Read JSON/JSONL

```sh
duckdb -c "SELECT * FROM read_json_auto('data.json') LIMIT 10;"
duckdb -c "SELECT * FROM read_json_auto('data.jsonl') LIMIT 10;"
```

## Reporting pattern

For this Bulgarian-speaking Termux user, report concise sections:

```text
Проверено:
- rows: ...
- columns: ...
- schema: ...

Извод:
...

Следваща стъпка:
...
```

Do not claim a package works until you have run a real SQL smoke test.

## Pitfalls

- DuckDB repo source is large; do not clone/build it on a phone unless the user explicitly wants source development.
- Native Termux `duckdb` CLI is usually safer than Python package installation for local SQL tasks.
- `duckdb` is not a replacement for Hermes state DB management; use SQLite tools/Python `sqlite3` for live Hermes `state.db` backup/integrity workflows.
- If strict reproducibility matters, record DuckDB version and exact input file paths in the final answer.
