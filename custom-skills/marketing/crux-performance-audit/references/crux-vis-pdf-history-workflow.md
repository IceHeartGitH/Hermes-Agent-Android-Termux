# CrUX Vis PDF + CrUX History Workflow

Use this when the user provides CrUX Vis PDFs such as:

- `CrUX Vis - Core Web Vitals.pdf`
- `CrUX Vis - Loading Performance.pdf`
- `CrUX Vis - Interactivity.pdf`
- `CrUX Vis - Visual Stability.pdf`

## Goal

Do not rely only on the visual PDF chart. Extract PDF text/metadata, render pages when useful, and use CrUX History time-series data when possible to identify exact periods, values, and trend changes.

## PDF extraction on Termux

```bash
pdfinfo file.pdf
pdftotext -layout file.pdf output.txt
pdftoppm -png -r 140 -f 1 -l 1 file.pdf page
qpdf --check file.pdf
```

Use rendered images plus vision/OCR only when chart values or labels are not extractable from text.

## CrUX History query pattern

If CrUX Vis PDF gives only visual trend lines, query CrUX History for the same origin/form factor.

Endpoint:

```text
https://chromeuxreport.googleapis.com/v1/records:queryHistoryRecord
```

When using the public CrUX Vis frontend key, requests may require:

```text
Origin: https://cruxvis.withgoogle.com
Referer: https://cruxvis.withgoogle.com/
```

Do not print or save the API key in reports. Save only returned metric data.

Typical payload:

```json
{
  "origin": "https://example.com",
  "formFactor": "PHONE",
  "collectionPeriodCount": 40
}
```

Prefer origin-level data when URL-level history returns 404 or is unavailable.

## Metrics to extract

Loading Performance:

- `largest_contentful_paint` p75s and histogram
- `first_contentful_paint` p75s and histogram
- `experimental_time_to_first_byte` p75s and histogram
- `round_trip_time` p75s
- `largest_contentful_paint_resource_type` fractions
- LCP image subparts:
  - `largest_contentful_paint_image_time_to_first_byte`
  - `largest_contentful_paint_image_resource_load_delay`
  - `largest_contentful_paint_image_resource_load_duration`
  - `largest_contentful_paint_image_element_render_delay`

Interactivity:

- `interaction_to_next_paint` p75s and histogram

Visual Stability:

- `cumulative_layout_shift` histogram/distribution. Some origins may not expose a p75 CLS series; do not invent one.
- `navigation_types` fractions when available.

## Rolling-window interpretation

CrUX is a rolling 28-day dataset. If the first bad visible point is a period like `2026-05-24 → 2026-06-20`, report:

- first visible degraded CrUX point: the period ending date (`2026-06-20`);
- likely change window: the whole 28-day period (`2026-05-24 → 2026-06-20`);
- no exact deploy date unless deploy/server logs prove it.

## Cause interpretation rules

When TTFB, FCP, and LCP worsen together, explain the likely cause as broader loading critical path:

- server/cache/backend/HTML generation;
- critical CSS/JS;
- LCP image/text path;
- third-party scripts and render delay.

Do not reduce it to “large images only”.

If INP stays below 200 ms but trends upward, classify it as a warning, not the main problem.

If field CLS distribution is good but PSI lab CLS is bad, explain the distinction: real users may be mostly stable, while throttled lab homepage still has layout shifts. Still recommend dimensions/aspect-ratio/reserved layout fixes.

## User-facing summary

For business users, start with a human explanation:

> The site became slower at first load. The browser waits longer for the server/cache response, then must process heavy CSS/JS and hero/banner resources before showing the first screen. The main issue is Loading Performance, especially TTFB + render critical path; INP and field CLS are not the primary blockers.

Then include exact CrUX periods and values only if extracted from PDF/API data.

## Evidence to preserve

Save raw outputs as project data, not memory:

- extracted PDF text;
- rendered chart images if used;
- raw CrUX History JSON;
- compact summary JSON/table;
- final Markdown report.

When using Obsidian project brain, link the report, raw PDFs, extracted text, and JSON from the project `Съдържание.md`.
