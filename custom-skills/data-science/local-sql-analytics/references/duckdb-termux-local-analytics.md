# DuckDB on Termux for local analytics

Session-derived facts from inspecting `duckdb/duckdb` and PyPI/Termux package availability.

## Repo facts checked

- GitHub repo: `https://github.com/duckdb/duckdb`
- Description: high-performance analytical in-process SQL database system
- License: MIT
- Topics: SQL, database, OLAP, analytics, embedded database
- The source repo is large for a phone workflow: shallow filtered clone still checked out ~15k files and ~398 MB.
- Build stack is CMake + C++17 with many tests/extensions; do not build from source on Termux unless the user explicitly wants DuckDB development.

## Termux package state observed

Termux package search showed native packages:

```text
duckdb/stable 1.5.4 aarch64
libduckdb/stable 1.5.4 aarch64
libduckdb-static/stable 1.5.4 aarch64
```

This makes the CLI path preferable on Android/Termux:

```sh
pkg install duckdb
duckdb -c "SELECT 42 AS ok;"
```

## PyPI package state observed

PyPI `duckdb` was available as version `1.5.5` with wheels for CPython 3.10-3.14 on macOS, manylinux aarch64/x86_64, and Windows. There was no Android/Termux-specific wheel in the checked list.

Implication: do not install the Python package into the main Hermes venv/global as the first move on Termux. If the user needs the Python API, test in an isolated throwaway venv and keep Hermes working envs clean.

## When to recommend DuckDB

Recommend for:

- CSV/Parquet/JSON/JSONL exports
- SEO/GEO/Search Console/Ads/Analytics datasets
- Product feed and price-list analysis
- SQL joins/grouping/filtering over local files
- CSV → Parquet conversion
- Replacing pandas when the task is mostly SQL and the files are large

Do not position it as improving Hermes chat quality. It is a local analytics tool.

## Safe evaluation flow

```sh
pkg search duckdb
pkg install duckdb
duckdb --version
duckdb -c "SELECT 42 AS ok;"
```

Then use direct file queries:

```sh
duckdb -c "DESCRIBE SELECT * FROM 'file.csv';"
duckdb -c "SELECT count(*) FROM 'file.csv';"
duckdb -c "COPY (SELECT * FROM 'file.csv') TO 'file.parquet' (FORMAT PARQUET);"
```

For final reports, include version, input files, row counts, and output paths. On CLI/Termux, keep the Bulgarian answer compact and practical.