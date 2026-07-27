---
name: duckdb-local-analytics
description: "Analyze CSV, JSON, Parquet, and local datasets with DuckDB CLI, especially on Termux where the packaged CLI is safer than pip wheels."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, android, termux]
metadata:
  hermes:
    tags: [duckdb, sql, csv, parquet, json, analytics, termux, data-analysis]
    related_skills: [xlsx, jupyter-live-kernel, codebase-inspection]
prerequisites:
  commands: [duckdb]
---

# DuckDB Local Analytics

Use this skill when the user needs fast local analysis of CSV, JSON, Parquet, logs, exports, product feeds, Search Console/Ads/Analytics reports, or other tabular files.

DuckDB is an embedded OLAP SQL engine. It runs locally, needs no server, and can query files directly.

## Termux/Android rule

On Termux, prefer the system package:

```bash
pkg install duckdb
```

Do NOT casually run `pip install duckdb` inside Hermes venv/global on Termux. PyPI publishes manylinux wheels, not Android/Termux wheels; pip may attempt an expensive source build or fail. The CLI package is the safe default and is visible to both `hermes` and `hermes-global`.

Verify:

```bash
duckdb --version
duckdb -csv -c "SELECT 42 AS ok;"
```

## Core command pattern

Use foreground terminal calls:

```bash
duckdb -csv -c "SELECT * FROM 'file.csv' LIMIT 10;"
```

For paths supplied by the user, quote carefully. Prefer absolute paths for Android shared storage, e.g. `/storage/emulated/0/...`.

## Inspect a file

CSV:

```bash
duckdb -c "DESCRIBE SELECT * FROM 'input.csv';"
duckdb -csv -c "SELECT count(*) AS rows FROM 'input.csv';"
duckdb -csv -c "SELECT * FROM 'input.csv' LIMIT 20;"
```

Parquet:

```bash
duckdb -c "DESCRIBE SELECT * FROM 'input.parquet';"
duckdb -csv -c "SELECT count(*) AS rows FROM 'input.parquet';"
```

JSON:

```bash
duckdb -csv -c "SELECT * FROM read_json_auto('input.json') LIMIT 20;"
```

Multiple files:

```bash
duckdb -csv -c "SELECT filename, count(*) AS rows FROM read_csv_auto('folder/*.csv', filename=true) GROUP BY filename ORDER BY rows DESC;"
```

## Common analysis recipes

Top values:

```bash
duckdb -csv -c "SELECT category, count(*) AS n FROM 'input.csv' GROUP BY category ORDER BY n DESC LIMIT 20;"
```

Null/empty check:

```bash
duckdb -csv -c "SELECT count(*) AS rows, count(column_name) AS non_null FROM 'input.csv';"
```

Deduplicate:

```bash
duckdb -c "COPY (SELECT DISTINCT * FROM 'input.csv') TO 'deduped.csv' (HEADER, DELIMITER ',');"
```

CSV to Parquet:

```bash
duckdb -c "COPY (SELECT * FROM 'input.csv') TO 'output.parquet' (FORMAT PARQUET);"
```

Parquet to CSV:

```bash
duckdb -c "COPY (SELECT * FROM 'input.parquet') TO 'output.csv' (HEADER, DELIMITER ',');"
```

Join two CSVs:

```bash
duckdb -csv -c "SELECT a.*, b.extra_col FROM 'a.csv' a LEFT JOIN 'b.csv' b USING (id) LIMIT 50;"
```

## Example project / SEO / Ads export recipes

Search Console query/page export:

```bash
duckdb -csv -c "SELECT query, SUM(clicks) AS clicks, SUM(impressions) AS impressions, AVG(position) AS avg_position FROM 'search_console.csv' GROUP BY query ORDER BY impressions DESC LIMIT 50;"
```

Product feed category revenue/count style analysis:

```bash
duckdb -csv -c "SELECT category, count(*) AS products, min(price) AS min_price, max(price) AS max_price, avg(price) AS avg_price FROM 'products.csv' GROUP BY category ORDER BY products DESC;"
```

Find missing SEO fields:

```bash
duckdb -csv -c "SELECT count(*) AS rows, sum(CASE WHEN title IS NULL OR title='' THEN 1 ELSE 0 END) AS missing_title, sum(CASE WHEN description IS NULL OR description='' THEN 1 ELSE 0 END) AS missing_description FROM 'pages.csv';"
```

## Output format choices

- `-csv` for machine-readable output back into Hermes.
- `-json` when the result will be parsed programmatically.
- Default table output for human inspection.

Examples:

```bash
duckdb -json -c "SELECT 1 AS ok;"
duckdb -csv -c "SELECT 1 AS ok;"
```

## Safety and pitfalls

1. Do not run unbounded `SELECT *` on huge files; always start with `LIMIT`.
2. Use `DESCRIBE SELECT * FROM ...` before writing complex queries.
3. Quote Android paths and filenames with spaces carefully.
4. For very large exports, write results to a file with `COPY (...) TO ...` instead of dumping everything into the terminal.
5. Avoid `pip install duckdb` in Hermes environments on Termux unless the user explicitly accepts source-build risk.

## Verification checklist

After installing or changing this workflow, verify:

```bash
duckdb --version
duckdb -csv -c "SELECT 42 AS ok, 'duckdb_cli_ok' AS status;"
printf 'category,revenue\na,10\nb,20\na,15\n' > "$PREFIX/tmp/duckdb-smoke.csv"
duckdb -csv -c "SELECT category, sum(revenue) AS total FROM '$PREFIX/tmp/duckdb-smoke.csv' GROUP BY category ORDER BY category;"
```

Expected final rows:

```text
category,total
a,25
b,20
```
