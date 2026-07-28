---
name: termux-pdf-document-analysis
description: "Analyze PDFs on Android Termux with lightweight CLI/Python tools, including text extraction, table parsing, rendering pages for vision, OCR, and verification in both Hermes venv and global Python."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [termux, android, pdf, ocr, documents, pdfplumber, tesseract, poppler]
    related_skills: [pdf, ocr-and-documents, android-termux-hermes-setup]
---

# Termux PDF Document Analysis

Use this skill when the user wants to read, analyze, verify, OCR, or summarize PDF documents on Android Termux, especially inside Hermes where packages may need to work in both the active Hermes venv and the global/system Python.

## Core Principle

On Android Termux, prefer the lightweight native stack first:

```bash
pkg install -y poppler qpdf tesseract imagemagick
python -m pip install --user pypdf pypdfium2 pdfplumber pytesseract
```

Avoid starting with heavyweight document parsers unless the lightweight stack fails or the user explicitly needs advanced layout/model parsing.

## Install Targets

The user expects practical installs to be verified in both:

1. active Hermes venv used by `hermes` / `hermes-venv`:

```text
~/.hermes-venv/hermes-agent/venv/bin/python
```

2. global/system Python used by `hermes-global` / Termux shell:

```text
$(command -v python)
```

If there is also a separate `~/.hermes/hermes-agent/venv/bin/python`, check it too, but do not assume it is the runtime for `hermes-global`; inspect the launcher if needed.

## Recommended Install Workflow

### 1. Install CLI tools

```bash
pkg install -y poppler qpdf tesseract imagemagick
```

This provides:

- `pdfinfo` — metadata, page count, encryption info
- `pdftotext` — fast text extraction, especially `-layout`
- `pdftoppm` — render pages to PNG/JPG for vision analysis or OCR
- `pdfimages` — extract embedded images
- `qpdf` — check, split, merge, repair, decrypt
- `tesseract` — OCR
- `magick` — image conversion/processing

### 2. Install Python packages in global Python

```bash
python -m pip install --user --upgrade pypdf pypdfium2 pdfplumber pytesseract
```

### 3. Install Python packages in Hermes venv

```bash
VENV="$HOME/.hermes-venv/hermes-agent/venv/bin/python"
"$VENV" -m pip install --upgrade pypdf pypdfium2 pdfplumber pytesseract
```

### 4. Ensure user-local scripts are on PATH

```bash
touch "$HOME/.profile"
if ! grep -q 'HOME/.local/bin' "$HOME/.profile"; then
  printf '\n# User-local Python scripts\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.profile"
fi
export PATH="$HOME/.local/bin:$PATH"
```

### 5. Bulgarian OCR language data

If Bulgarian OCR is needed and `tesseract --list-langs` does not show `bul`, install:

```bash
TESSDIR="${PREFIX:?PREFIX is not set}/share/tessdata"
mkdir -p "$TESSDIR"
curl -L --fail -o "$TESSDIR/bul.traineddata" \
  https://github.com/tesseract-ocr/tessdata_fast/raw/main/bul.traineddata
```

Then OCR with:

```bash
tesseract page.png output -l eng+bul
```

## Verification Checklist

Run this after installing:

```bash
export PATH="$HOME/.local/bin:$PATH"

for c in pdfinfo pdftotext pdftoppm pdfimages qpdf tesseract magick python; do
  printf '%-12s ' "$c"
  command -v "$c" || echo MISSING
done

python - <<'PY'
import importlib.util
for m in ['pypdf','pypdfium2','pdfplumber','pytesseract','PIL','pdfminer']:
    print(f'{m:12s}', 'OK' if importlib.util.find_spec(m) else 'MISSING')
PY

VENV="$HOME/.hermes-venv/hermes-agent/venv/bin/python"
if [ -x "$VENV" ]; then
  "$VENV" - <<'PY'
import importlib.util
for m in ['pypdf','pypdfium2','pdfplumber','pytesseract','PIL','pdfminer']:
    print(f'{m:12s}', 'OK' if importlib.util.find_spec(m) else 'MISSING')
PY
fi

tesseract --list-langs
```

## Smoke Test on Real PDFs

Do not just install. Verify with an actual PDF:

```bash
OUT="$HOME/.cache/hermes_pdf_smoke"
rm -rf "$OUT" && mkdir -p "$OUT"
PDF="/path/to/file.pdf"

pdfinfo "$PDF"
pdftotext -layout -f 1 -l 1 "$PDF" "$OUT/page1.txt"
pdftoppm -png -r 120 -f 1 -l 1 "$PDF" "$OUT/page"
qpdf --check "$PDF"
```

Python verification:

```bash
python - <<'PY'
from pathlib import Path
import pdfplumber
p = Path('/path/to/file.pdf')
with pdfplumber.open(str(p)) as pdf:
    print('pages', len(pdf.pages))
    print('page1 chars', len(pdf.pages[0].extract_text() or ''))
    print('page1 tables', len(pdf.pages[0].extract_tables()))
PY
```

OCR smoke test:

```bash
tesseract "$OUT/page-1.png" "$OUT/ocr" -l eng+bul --psm 6
wc -c "$OUT/ocr.txt"
```

## Analysis Workflow

### Text-based PDF

1. `pdfinfo file.pdf`
2. `pdftotext -layout file.pdf extracted.txt`
3. Use `pdfplumber` if tables/layout matter.
4. Use `qpdf --check file.pdf` if extraction behaves strangely.

### PDF with charts or visual dashboards

1. Render pages:

```bash
pdftoppm -png -r 180 file.pdf rendered/page
```

2. Analyze rendered PNG pages with vision tools.
3. Combine visual findings with text extraction.
4. Do not invent chart values if visual resolution is insufficient; use APIs/source data when possible.

### Scanned/image-only PDF

1. Render at higher resolution:

```bash
pdftoppm -png -r 250 file.pdf rendered/page
```

2. OCR:

```bash
tesseract rendered/page-1.png ocr/page-1 -l eng+bul
```

3. If OCR quality is weak, try different `--psm` modes and higher DPI.

## Tool Selection

Use this order on Termux:

1. `pdftotext -layout` for text extraction.
2. `pdfplumber` for tables and layout-aware extraction.
3. `pdftoppm` + vision for charts/screenshots.
4. `pdftoppm` + `tesseract` for scanned/image PDFs.
5. `qpdf` for checking/repairing/splitting/merging.
6. `pypdf`/`pypdfium2` for scripted extraction/rendering.

## Heavy Tool Cautions

These can be useful on desktop/server but should not be first choice on Android Termux:

- `pymupdf` / `pymupdf4llm`: excellent normally, but may source-build or time out on Termux depending on wheel availability.
- `markitdown`: useful universal converter, but can pull heavy dependencies such as `numpy` builds on Termux.
- `docling`: powerful document intelligence, likely heavy for phone storage/CPU.
- `marker`: high-quality PDF to Markdown/JSON, but model/PyTorch-heavy.
- `OCRmyPDF`: strong for OCR text layers, but usually not necessary for quick analysis when `pdftoppm + tesseract` is enough.

Do not encode transient failures as permanent refusals. If a heavy tool becomes needed later, re-evaluate disk space, wheel availability, and user approval.

## Reporting Pattern for the User

For Bulgarian Termux/Hermes setup tasks, keep the final answer short and practical:

- какво е инсталирано;
- какво е проверено реално;
- дали работи във venv и global;
- какво остава извън обхват и защо;
- кратък работен workflow.

## References

- `references/example-project-termux-pdf-setup-2026-07-26.md` — session-specific verified setup details from the Example project PageSpeed/CrUX PDF work: installed packages, runtime paths, Bulgarian OCR, smoke tests, and heavy-tool cautions.

## Overlap Note

This skill overlaps with `pdf` and `ocr-and-documents`, but is Termux/Hermes-runtime specific: it captures Android install commands, venv/global verification, Bulgarian OCR setup, and smoke-test workflow.
