---
name: termux-web-performance-monitoring
description: Monitor Core Web Vitals, PageSpeed/CrUX, and lightweight SEO/performance regressions from Android Termux/Hermes without relying on local Chrome.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [android, linux]
metadata:
  hermes:
    tags: [termux, android, performance, core-web-vitals, crux, pagespeed, seo, monitoring, obsidian]
    related_skills: [seo-technical, watchers, obsidian-project-brain-sync, pdf, ocr-and-documents]
---

# Termux Web Performance Monitoring

Use this skill when the user wants ongoing website performance/CWV monitoring from Android Termux/Hermes, asks whether the phone stack can extract enough data, or wants a lightweight alternative to desktop Lighthouse/sitespeed.io.

## Core approach

On Android/Termux, use a lightweight monitoring stack first:

1. CrUX History API for real-user trends.
2. PageSpeed Insights API when quota/key is available; if it returns 429, report that honestly and fall back to CrUX + local PSI PDF extraction.
3. Python lightweight crawler for live HTML/resource diagnostics.
4. PDF toolchain for downloaded PageSpeed/CrUX reports.
5. Obsidian/project notes for summaries and raw JSON history.
6. GitHub Actions/VPS/desktop only for Chrome-heavy Lighthouse/rendered-DOM/waterfall tests.

Do not try to make Android Termux the primary Chrome/Lighthouse lab environment unless the user explicitly asks for that experiment.

## Recommended phone dependencies

Termux packages:

```bash
pkg install -y jq poppler qpdf tesseract imagemagick
```

Python packages for both system/global Python and Hermes venvs:

```bash
python -m pip install requests==2.33.0 beautifulsoup4 PyYAML
~/.hermes-venv/hermes-agent/venv/bin/python -m pip install requests==2.33.0 beautifulsoup4 PyYAML
```

PDF/document extras when needed:

```bash
python -m pip install --user pypdf pypdfium2 pdfplumber pytesseract
~/.hermes-venv/hermes-agent/venv/bin/python -m pip install pypdf pypdfium2 pdfplumber pytesseract
```

Pitfall: avoid blind `pip install --upgrade requests` inside Hermes environments. Hermes may pin `requests` to a specific version. If pip upgrades it and prints a dependency conflict, restore the Hermes-pinned version and verify `hermes --version`, `hermes-venv --version`, and `hermes-global --version`.

## What to extract from live HTML

For each important URL, collect:

- HTTP status, final URL, fetch time.
- HTML bytes.
- title, meta description length, canonical, robots meta.
- H1 count and sample.
- CSS/JS asset URLs and sizes.
- image count, `loading=lazy` count, missing `width`/`height` count.
- largest sampled images/assets.
- JSON-LD block count, parse success/failure, `@type` values.
- third-party scripts/resources.
- `/robots.txt`, `/sitemap.xml`, `/llms.txt` status.

For critical first-party assets, prefer real `GET` with `Accept-Encoding: identity` to measure bytes, because some servers omit `Content-Length` on `HEAD` and regex/HTMLParser can miss assets embedded in framework preload tags.

## What to extract from CrUX / PSI

CrUX History:

- LCP
- FCP
- TTFB / `experimental_time_to_first_byte`
- INP
- CLS distribution/p75 where available
- latest collection period
- week-over-week deltas and earliest visible regression period

PSI API:

- mobile/desktop strategy
- performance/accessibility/best-practices/SEO scores
- lab metrics and opportunities when API succeeds
- `HTTP 429` or quota failures when it does not

Never invent PSI scores. Use actual PSI API output, a downloaded PSI PDF, Lighthouse output, or explicitly label the data as unavailable.

## PDF workflow for reports

For downloaded PageSpeed/CrUX PDFs:

```bash
pdfinfo file.pdf
pdftotext -layout file.pdf output.txt
qpdf --check file.pdf
pdftoppm -png -r 180 file.pdf page
```

Use `pdfplumber` for layout/tables and `tesseract -l eng+bul` or vision for scanned/chart-heavy pages.

## Android limitations

Treat these as unavailable from the lightweight phone stack unless specifically configured elsewhere:

- real Lighthouse CLI lab audit with Chrome/Chromium;
- rendered DOM/a11y tree audit;
- browser screenshots, waterfalls, videos;
- reliable PSI API snapshots without quota/key.

For these, recommend GitHub Actions, VPS, or desktop Chrome. The phone remains the command center, data collector, and Obsidian reporting surface.

## Report pattern for this user

Keep Bulgarian output concise and practical:

1. Short verdict: `Да/Не — можем да извличаме ...`.
2. `Успешно извличаме:` bullet list.
3. `Остава ограничено:` bullet list.
4. Key numbers from the live test.
5. Exact Obsidian/project/raw JSON paths.

For Example project-style project work, read `Съдържание.md` first and update Obsidian after creating a report.

## References

- `references/example-project-extraction-test-pattern.md` — session-proven Android/Termux extraction-test pattern, including bounded crawler pitfalls, CSS/JS size measurement quirks, PSI 429 handling, and concise Bulgarian verdict style.
- `references/google-pagespeed-crux-api-termux-workflow.md` — session-proven PageSpeed Insights API + Chrome UX Report API setup on Termux, safe key handling, common Google API errors, lightweight crawler size pitfalls, and CrUX regression-start detection.

## Verification checklist

After installation or changes, verify:

```bash
jq --version
python - <<'PY'
import requests, bs4, yaml
print(requests.__version__, bs4.__version__, yaml.__version__)
PY
~/.hermes-venv/hermes-agent/venv/bin/python - <<'PY'
import requests, bs4, yaml
print(requests.__version__, bs4.__version__, yaml.__version__)
PY
hermes --version
hermes-venv --version
hermes-global --version
```

For PDF readiness, also verify `pdfinfo`, `pdftotext`, `pdftoppm`, `qpdf`, `tesseract`, and the Python PDF imports.
