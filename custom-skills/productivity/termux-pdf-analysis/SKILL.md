---
name: termux-pdf-analysis
description: "Analyze local PDF documents on Android Termux: extract text, render chart pages, OCR scans, and produce grounded reports."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [android, linux]
metadata:
  hermes:
    tags: [PDF, Termux, Android, OCR, document-analysis, extraction, CrUX, PageSpeed]
    category: productivity
    related_skills: [pdf, ocr-and-documents, termux-android-storage, obsidian-project-brain-sync]
---

# Termux PDF Analysis

Use this skill when the user asks to inspect, read, analyze, summarize, or extract data from local PDF files on Android/Termux, especially PDFs under `/storage/emulated/0/Download` or `$HOME/storage/downloads`.

This is a Termux-focused workflow layered on top of the general `pdf` and `ocr-and-documents` skills. It is for practical analysis: read the PDF, extract grounded values, render pages when charts are visual, and save focused notes/raw artifacts when the work belongs to an Obsidian project.

## Trigger Examples

- “анализирай PDF файла в Downloads”
- “прочети PageSpeed Insights PDF”
- “виж CrUX/Core Web Vitals PDF и кажи кога е започнало да пада”
- “извади таблиците/графиките от PDF”
- “трябва ни инструмент за PDF анализ в Termux”

## Recommended Termux Tool Stack

Install the light stack first:

```bash
pkg install poppler qpdf
python -m pip install --user pypdf pypdfium2 pdfplumber
```

What this provides:

- `pdfinfo` — metadata/page count.
- `pdftotext -layout` — fast text extraction while preserving layout.
- `pdftoppm` — render pages to PNG/JPEG for visual chart analysis.
- `pdfimages` — extract embedded images.
- `qpdf` — repair/split/merge/decrypt PDFs when needed.
- `pypdf` — lightweight Python extraction/splitting/metadata.
- `pypdfium2` — reliable PDF page rendering from Python.
- `pdfplumber` — table/layout extraction.

OCR stack only when needed for scanned/image-only PDFs:

```bash
pkg install tesseract imagemagick
python -m pip install --user pytesseract
```

Avoid making heavy tools the first choice on Android/Termux. `marker`, `docling`, `unstructured`, and full OCR pipelines can be excellent on desktop/server, but they may be large. Use them only after confirming the document requires advanced layout/OCR and the device has enough storage/time.

## Workflow

1. Locate the file in both Android and Termux mirror paths:

```text
/storage/emulated/0/Download/<file>.pdf
$HOME/storage/downloads/<file>.pdf
$HOME/storage/shared/Download/<file>.pdf
```

2. Inspect metadata:

```bash
pdfinfo "$PDF"
```

If `pdfinfo` is not available, use `pypdf` for page count/metadata.

3. Try text extraction first:

```bash
pdftotext -layout "$PDF" output.txt
```

Fallback with `pypdf`:

```python
from pypdf import PdfReader
reader = PdfReader(pdf_path)
text = "\n\n".join((page.extract_text() or "") for page in reader.pages)
```

4. If the text is incomplete because the important data is in charts/screenshots, render pages:

```bash
pdftoppm -png -r 180 "$PDF" page
```

Fallback with `pypdfium2`:

```python
import pypdfium2 as pdfium
pdf = pdfium.PdfDocument(str(pdf_path))
for i, page in enumerate(pdf):
    bitmap = page.render(scale=2.5).to_pil()
    bitmap.save(f"page_{i+1}.png")
```

Then use vision analysis on the rendered page(s). For chart-heavy PDFs, combine visual reading with any machine-readable text/API source.

5. For tables, try `pdfplumber`:

```python
import pdfplumber
with pdfplumber.open(pdf_path) as pdf:
    for page in pdf.pages:
        print(page.extract_text() or "")
        print(page.extract_tables())
```

6. For scanned PDFs, render pages to images and OCR them. If the document is Bulgarian, verify available Tesseract language data before claiming Bulgarian OCR quality.

7. Report with grounding:

- source file path;
- extraction method used;
- exact extracted values/dates;
- limitations if charts were visual or data was missing;
- clear conclusion and next checks.

## PageSpeed / CrUX PDF Pattern

For PageSpeed Insights PDFs:

- extract Performance/Accessibility/Best Practices/SEO scores;
- extract lab metrics: FCP, LCP, TBT, CLS, Speed Index, TTFB where present;
- list diagnostics/opportunities with savings;
- map each issue to likely cause and concrete fix;
- do not treat a lightweight local audit as an official PSI score.

For CrUX Vis PDFs:

- text extraction may only contain summary labels, not graph values;
- render chart pages to PNG and inspect visually;
- when exact history is required, prefer CrUX History API or exported data if available;
- remember CrUX is a 28-day rolling dataset, so a visible date is the end of a collection period, not necessarily the exact deploy date;
- distinguish field data from Lighthouse lab data.

Detailed session pattern: `references/crux-pagespeed-pdf-analysis.md`.

## Obsidian Project Handling

When the PDF analysis belongs to an Obsidian project:

1. Load/follow the relevant Obsidian project workflow.
2. Read the project `Съдържание.md` first.
3. Save a focused report under `01_Audit_Report_Split/` or the project’s appropriate analysis folder.
4. Save raw text/JSON/PDF copies under `04_Data/`.
5. Update the main `Съдържание.md` and any related problem/fix note.
6. Use wikilinks for `.md` files and Markdown links for raw `.pdf`, `.txt`, `.json`, `.png` files.

## Pitfalls

- Do not infer exact dates from a chart if the PDF text does not contain the values. Render the chart or query a structured source.
- Do not claim a PSI score, LCP/INP/CLS, or CrUX trend unless extracted from the PDF/API/tool output.
- Do not preserve or print API keys from frontend bundles or documents. If a public frontend key is observed while inspecting an app, redact it and only report the endpoint/method.
- Do not install heavyweight OCR/model stacks before a light extraction/rendering path has failed.
- Do not store one-off task narratives in the skill. Store the reusable workflow and keep task-specific data in `references/` or the user’s project notes.

## Verification Checklist

- [ ] PDF path found and stated.
- [ ] Page count/metadata checked or fallback noted.
- [ ] Text extraction attempted.
- [ ] Visual rendering attempted for chart/image-based pages.
- [ ] Values/dates are grounded in extraction/API/vision output.
- [ ] Raw artifacts saved if the analysis is project-relevant.
- [ ] Project index/problem notes updated when using Obsidian.
