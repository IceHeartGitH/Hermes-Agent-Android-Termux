# CrUX and PageSpeed PDF Analysis Pattern

This reference captures the reusable pattern from analyzing local PageSpeed Insights and CrUX Vis PDFs on Android/Termux. Keep project-specific reports in the user’s Obsidian/project folders; this file is only the general method.

## Problem Shape

Browser-generated PDFs from Google tools can contain a mix of:

- selectable text for headings/summaries;
- visual charts whose exact values are not in the text layer;
- metric names and descriptions split across pages;
- important values that require chart rendering or an API/source-data query.

## Practical Termux Stack

Light stack:

```bash
pkg install poppler qpdf
python -m pip install --user pypdf pypdfium2 pdfplumber
```

OCR stack when needed:

```bash
pkg install tesseract imagemagick
python -m pip install --user pytesseract
```

Use heavier tools only when the light stack cannot answer the question:

- `markitdown` for broad office/document to Markdown conversion;
- `docling` for richer document understanding;
- `marker` for high-quality PDF to Markdown/JSON, but expect heavier dependencies;
- `OCRmyPDF` for adding OCR text layers to scanned PDFs.

## Extraction Order

1. Locate the file:

```text
/storage/emulated/0/Download/<file>.pdf
$HOME/storage/downloads/<file>.pdf
$HOME/storage/shared/Download/<file>.pdf
```

2. Try metadata and text:

```bash
pdfinfo "$PDF"
pdftotext -layout "$PDF" extracted.txt
```

3. If `pdftotext` is unavailable, use `pypdf`:

```python
from pathlib import Path
from pypdf import PdfReader
pdf = Path('/storage/emulated/0/Download/file.pdf')
reader = PdfReader(str(pdf))
text = '\n\n'.join((page.extract_text() or '') for page in reader.pages)
Path('extracted.txt').write_text(text, encoding='utf-8')
```

4. If the needed values are chart-only, render pages:

```bash
pdftoppm -png -r 180 "$PDF" page
```

Fallback:

```python
from pathlib import Path
import pypdfium2 as pdfium
pdf_path = Path('/storage/emulated/0/Download/file.pdf')
out = Path('rendered_pages'); out.mkdir(exist_ok=True)
doc = pdfium.PdfDocument(str(pdf_path))
for i, page in enumerate(doc):
    img = page.render(scale=2.5).to_pil()
    img.save(out / f'page_{i+1}.png')
```

5. Use visual analysis for rendered charts, but avoid pretending visual estimates are exact. If exact values are needed, query an official/exported structured data source.

## PageSpeed Insights PDF Checklist

Extract/report:

- URL and report timestamp;
- scores: Performance, Accessibility, Best Practices, SEO;
- field data versus lab data;
- FCP, LCP, TBT, CLS, Speed Index, TTFB where present;
- opportunities/diagnostics and estimated savings;
- LCP element and resource breakdown;
- render-blocking resources;
- unused JS/CSS;
- image delivery savings;
- third-party/main-thread work;
- DOM size and layout shift causes.

Report format:

```text
Problem
Evidence from PDF/tool
What causes it
What to fix
Priority
```

Important distinction:

- PSI/Lighthouse lab score is not the same as real CrUX field performance.
- Do not claim an official score unless it came from PSI PDF/API/Lighthouse output.

## CrUX Vis PDF Checklist

Extract/report:

- whether CrUX Vis summary says loading/interactivity/visual stability is improving/stable/regressing;
- available date range;
- LCP, INP, CLS, FCP, TTFB p75 time series where available;
- first visible deterioration period;
- peak/worst period;
- latest trend compared with baseline;
- whether values are URL-level or origin-level;
- whether data is phone/desktop/all devices.

If the PDF text does not contain chart values, render the chart page and then try a structured source such as CrUX History API/exported CrUX data.

CrUX interpretation rule:

CrUX periods are rolling windows. If the first bad point ends on `YYYY-MM-DD`, the cause may have started earlier inside that collection window. Report the collection period and avoid naming a single deploy date unless deployment logs confirm it.

Example wording:

```text
The first visible deterioration appears in the CrUX period YYYY-MM-DD → YYYY-MM-DD. Because CrUX is a 28-day rolling dataset, the underlying change likely began sometime inside that window. Confirm with deployment/build/media/server/cache logs.
```

## Correlation Checks

For a performance drop, compare:

- deploy/git history around the CrUX window;
- static asset `Last-Modified` headers;
- CSS/JS bundle sizes;
- banner/media upload timestamps;
- server/backend TTFB logs;
- CDN/cache hit ratio and purges;
- tracking/third-party additions;
- homepage/template/product-card changes.

Useful live checks:

```bash
curl -I https://example.com/build/assets/main.css
curl -I https://example.com/build/assets/app.js
```

Wayback CDX can be tried, but lack of snapshots is not proof that nothing changed.

## Privacy / API Key Handling

When inspecting public frontend bundles to understand an endpoint:

- never print or save API keys/tokens in reports;
- redact key-like strings as `[REDACTED_API_KEY]`;
- report only the method, endpoint class, and whether the request succeeded;
- prefer official API credentials/exported data if the user provides them.

## Obsidian Artifact Pattern

For project work, save:

```text
01_Audit_Report_Split/<number> - <PDF analysis title>.md
04_Data/<original PDF copy>.pdf
04_Data/<extracted text>.txt
04_Data/<raw API or extracted JSON>.json
```

Then update:

- project `Съдържание.md`;
- related `02_Problems/*` note;
- related `03_Fixes_Schemas/*` note when the analysis changes the fix plan.
