---
name: android-web-performance-monitoring
description: Lightweight Android/Termux workflow for recurring website performance monitoring, combining Hermes, Python crawlers, CrUX/PageSpeed APIs, PDF extraction, Obsidian reports, and optional remote Lighthouse.
---

# Android Web Performance Monitoring

Use this when the user wants to monitor or audit website performance from Android/Termux, especially when comparing local Hermes results with Google PageSpeed Insights, CrUX, Lighthouse, or GitHub Actions/VPS reports.

## Core approach

On Android, prefer a lightweight monitoring stack:

1. Hermes orchestrates the audit and writes the human summary.
2. Python extracts live HTML/resource facts.
3. CrUX History API supplies real-user trends.
4. PageSpeed Insights API supplies official Google/Lighthouse snapshots when a valid key/quota is available.
5. PDF tools analyze downloaded PageSpeed/CrUX reports.
6. Obsidian keeps the project history and final verdicts.
7. GitHub Actions/VPS/desktop runs heavy Chrome/Lighthouse tests when needed.

Do not make the phone run the heavy browser layer by default. Chrome/Lighthouse/sitespeed-style tests are better on GitHub Actions, VPS, or desktop; Android remains the command center.

## Phone-local stack

Recommended Termux tools:

- `jq` for JSON inspection.
- Python: `requests`, `beautifulsoup4`, `PyYAML` if config is needed.
- PDF/OCR: `poppler`, `qpdf`, `tesseract`, `imagemagick`, `pypdf`, `pypdfium2`, `pdfplumber`, `pytesseract`, `Pillow`.
- Hermes cron/jobs for weekly audits.
- Obsidian project notes for summaries and raw-data links.

Avoid heavy Android defaults unless explicitly needed: full Chromium automation, sitespeed.io, docling/marker-style ML document stacks, pandas/numpy-heavy workflows.

## What Android can extract reliably

A lightweight phone-local crawler can extract:

- HTTP status, redirects/final URL, live HTML size.
- `title`, meta description, robots meta, canonical, headings.
- CSS/JS/image URLs and sizes.
- Fallback to real GET when HEAD omits `Content-Length` for important assets.
- image count, `loading=lazy` count, missing `width`/`height` count.
- JSON-LD blocks, valid/invalid parse counts, schema types.
- robots.txt, sitemap.xml, llms.txt status.
- CrUX History p75 and distribution trends for LCP, FCP, TTFB, INP, CLS.
- local PDF text/layout/OCR from downloaded PageSpeed/CrUX reports.

## What is missing compared with Google PageSpeed Insights

Phone-local extraction is not a real Chrome Lighthouse run. Missing or limited items:

- PSI/Lighthouse Performance score 0-100.
- Browser lab metrics generated from a Chrome trace: lab LCP, FCP, TBT, Speed Index, lab CLS.
- Filmstrip/screenshot timings and exact rendered LCP element.
- Main-thread breakdown and JavaScript execution time.
- Exact Lighthouse opportunities and savings: render-blocking resources in ms, unused CSS/JS, network payload diagnostics, image delivery savings.
- Accessibility tree and Agentic Browsing audits requiring rendered browser context.
- Stable PSI API output when Google returns HTTP 429 without a usable API key/quota.

Use this wording with the user: “Android покрива 80–85% от monitoring-а; липсва тежката browser/Lighthouse lab част.”

## PageSpeed Insights API key setup

Google AI Studio keys are for Gemini/AI model calls, not PageSpeed Insights data. For official PageSpeed data, use Google Cloud:

1. Google Cloud Console → APIs & Services → Library.
2. Enable `PageSpeed Insights API`.
3. APIs & Services → Credentials → Create credentials → API key.
4. Restrict the key to PageSpeed Insights API.

On Termux, keep the key local and private:

```sh
mkdir -p ~/.config/example-project
chmod 700 ~/.config/example-project
touch ~/.config/example-project/.env
chmod 600 ~/.config/example-project/.env
# User edits locally; never ask them to paste the key in chat:
# PAGESPEED_API_KEY=...
```

Never write the API key into Obsidian, GitHub, reports, command output, screenshots, raw JSON, or memory. If a key-like value appears in any saved artifact, replace it with `[REDACTED]`.

## GitHub Actions/VPS role

Use GitHub Actions or VPS when the user wants automatic Lighthouse results close to Google Insights:

1. The remote runner starts Chrome.
2. Lighthouse opens target URLs.
3. It creates HTML/JSON reports with Performance score, LCP, FCP, CLS, TBT, Speed Index, render-blocking/unused-resource diagnostics, and image diagnostics.
4. Hermes on Android downloads/reads the report via `gh`, SSH, or a file URL.
5. Hermes writes a concise Obsidian summary and links the raw report.

Explain clearly: GitHub/VPS gives the same type of Lighthouse data as Google Insights, but numbers may differ because location, network, hardware, Chrome/Lighthouse version, throttling, and PSI settings differ.

## Reporting style for this user

The user often wants a short practical answer. For direct questions, answer first in one or two Bulgarian sentences, then add only the critical caveat.

Examples:

- “Да — можем автоматично чрез PageSpeed Insights API. Трябва Google Cloud API key; без него често получаваме 429.”
- “GitHub Actions дава почти същия тип Lighthouse анализ като Google Insights, но не абсолютно същите числа.”
- “AI Studio API е за Gemini анализ; PageSpeed данните идват от PageSpeed Insights API.”
- “Телефонът остава команден център; GitHub/VPS прави тежкия Chrome тест.”

When producing project work, write/refresh the Obsidian note only after reading the project `Съдържание.md`, and keep Markdown notes linked with Obsidian wikilinks while JSON/PDF files use normal Markdown links.

## Verification checklist

Before saying the stack is ready:

- Verify `jq --version`.
- Verify Python imports in both active Hermes venv and global/fallback layers when the user asks for both.
- Verify CrUX History or explicitly say if unavailable.
- Run at least one live URL crawl and report real values.
- If PSI API returns 429, say it directly and do not fabricate PageSpeed scores.
- If Lighthouse was not run in real Chrome, do not claim Google Insights-equivalent lab results.
