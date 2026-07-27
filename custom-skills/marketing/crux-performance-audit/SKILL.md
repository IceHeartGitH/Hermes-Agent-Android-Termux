---
name: crux-performance-audit
description: "Analyze CrUX Vis PDFs, CrUX History data, and PageSpeed/Core Web Vitals evidence to identify when performance changed and what likely caused it."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [seo, core-web-vitals, crux, pagespeed, performance, pdf]
    related_skills: [seo-technical, pdf, ocr-and-documents, obsidian-project-brain-sync]
---

# CrUX Performance Audit

Use this skill when the user provides CrUX Vis, PageSpeed Insights, Core Web Vitals, or Lighthouse PDFs/screenshots and asks:

- when performance started falling;
- what metric caused the problem;
- whether the issue is Loading Performance, Interactivity, or Visual Stability;
- what the human/root cause explanation is;
- how CrUX field data relates to PageSpeed/Lighthouse lab data.

## Core rule

Do not guess PSI scores, LCP/INP/CLS/FCP/TBT/TTFB values, or decline dates. Use extracted PDF text, rendered charts, CrUX History API/JSON, Lighthouse/PSI API, or other real data. If a value is not visible/extracted, say so.

## Workflow

1. Locate and verify each PDF with `pdfinfo` or equivalent.
2. Extract text with `pdftotext -layout` and/or `pdfplumber`.
3. If charts are visually important, render pages with `pdftoppm`/`pypdfium2` and inspect the image.
4. For exact history, query CrUX History when available rather than relying only on PDF graph pixels.
5. Build a compact time-series table for phone/origin first, unless the user asks for desktop/tablet/URL-level data.
6. Compare the latest period, first visible degraded period, best prior period, and peak/worst period.
7. Explain CrUX as a rolling 28-day dataset: the first bad period is a window, not an exact deploy date.
8. Tie the field-data trend to live technical evidence: CSS/JS bundle size, lazy loading, image dimensions, hero/LCP assets, DOM size, third-party scripts, TTFB/cache/backend signals.
9. Give the user a short human-language root cause first, then the technical evidence.
10. If working in an Obsidian project, save the report and raw data there; do not put one-off report details in memory.

## Interpretation shortcuts

- Loading Performance is the main issue when LCP, FCP, and TTFB worsen together.
- If TTFB worsens together with FCP/LCP, do not blame only images. Include server/cache/backend/HTML generation + critical rendering path.
- If INP is under 200 ms but trending upward, call it a warning, not the main blocker.
- If field CLS is good but lab CLS is bad, explain the field/lab distinction and still recommend `width`/`height`, `aspect-ratio`, and reserved layout space.
- If field data is good but PSI lab score is poor, explain that throttled lab mobile can expose heavy first-load problems before they fully damage CrUX field pass/fail status.

## Termux PDF stack

For Android Termux, the practical stack is:

```bash
pkg install -y poppler qpdf tesseract imagemagick
python -m pip install --user pypdf pypdfium2 pdfplumber pytesseract
```

Use:

```bash
pdfinfo file.pdf
pdftotext -layout file.pdf output.txt
pdftoppm -png -r 140 file.pdf page
qpdf --check file.pdf
```

Avoid heavy tools like `marker`, `docling`, `pymupdf`, or `markitdown` as first choice on Termux unless the task specifically needs them and disk/build risk is acceptable.

## Output style for this user

When the user asks for the “main reason” or “на човешки език”, answer briefly and directly in Bulgarian:

- one-sentence root cause;
- 3–7 bullets of technical causes;
- exact period/date only if backed by data;
- avoid long tables unless the user asks for details.

Example concise conclusion:

> Основната причина е, че сайтът е станал по-бавен при първоначално зареждане: сървърът/кешът отговаря по-бавно, после браузърът обработва тежък CSS/JS и hero/banner ресурси преди първия екран. Това е Loading Performance проблем, не основно INP или field CLS.

## Reference

Detailed workflow and metric mapping: `references/crux-vis-pdf-history-workflow.md`.
