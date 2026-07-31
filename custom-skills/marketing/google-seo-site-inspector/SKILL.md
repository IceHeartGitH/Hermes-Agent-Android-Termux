---
name: google-seo-site-inspector
description: "Use when full Google SEO criteria site inspection."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [marketing, seo, audit, google, inspection]
    related_skills: [seo-geo-site-audits, seo-google, seo-technical, seo-page, seo-schema]
---

# Google SEO Site Inspector

## Overview

Use this skill to inspect a site or single URL against the user's professional SEO criteria bank.

Criteria bank:
`${HERMES_HOME:-$HOME/.hermes-venv}/skill-libraries/google-seo-geo-criteria-bank/Google SEO Criterions`

The bank contains 201 SEO criteria, grouped and normalized with professional inspection fields: requirements, audit evidence, pass/fail conditions, fix recommendation, priority, risk, and sources.

This skill does not promise 100% indexing or ranking. It evaluates whether the page/site has maximal conditions for crawl, indexability, ranking eligibility, search appearance, and SEO visibility.

## When to Use

Use when the user asks for SEO inspection, Google SEO audit, indexing readiness check, technical/on-page SEO review, schema/content/performance SEO check, or SEO-only analysis without GEO/AI.

Do not use for GEO/AI-only checks; use `google-geo-site-inspector`. Use `google-seo-geo-site-inspector` when the user wants both SEO and GEO together.

## Operating Modes

### Dry run / no save

If the user says dry run, test, do not save, or asks only for a summary:

1. Collect live evidence.
2. Evaluate SEO criteria groups.
3. Summarize in chat only.
4. Do not write report files.
5. Do not update Obsidian.

### Full report

If the user asks to save a report:

1. Collect live evidence.
2. Evaluate SEO criteria groups.
3. Write a report into the requested project folder.
4. Optionally save raw JSON evidence.
5. Verify the report file exists and is readable.

## Evidence Collection

Gather at minimum:

- HTTP status, final URL, redirects, response bytes.
- robots.txt, sitemap index, child sitemaps, target URL inclusion.
- title, meta description, canonical, robots meta, viewport.
- H1/H2/H3 structure.
- visible word count and content intent fit.
- internal/external links.
- image count, missing alt, obvious image payload/performance risk.
- JSON-LD schema types and parse errors.
- security/trust headers.
- PageSpeed Insights / CrUX if API key is available.
- GSC URL Inspection only if credentials/access are available.

Use dependency-light Python stdlib if needed. Existing helper script:
`Use the bundled `seo-geo-site-audits` helper script when installed, or collect equivalent live evidence with Python stdlib.`

## Criteria Groups to Apply

Evaluate SEO criteria by group: crawling/indexing, content quality/E-E-A-T, technical SEO/page experience, snippets/structured data, links/site architecture, SERP appearance, media SEO, international/local, monitoring, spam policies, URL/HTTP/security, mobile/performance, YMYL/content quality, backlinks/link spam, ecommerce, local business, schema types, Discover/snippets, diagnostics, and SEO myths as `do_not_optimize`.

## Result States

Each criterion should map to one state:

- `passed` — criterion is covered.
- `partial` — partly covered; risk remains.
- `missing` — missing or broken.
- `not_applicable` — not relevant to this URL/site type.
- `do_not_optimize` — myth/unconfirmed; do not make it a task.

For every `partial` or `missing` result include evidence, risk, exact fix, and priority.

## Scoring

Score conservatively:

- Technical crawl/indexability: 30%.
- On-page/content quality: 25%.
- Schema/search appearance: 15%.
- Performance/mobile: 15%.
- Images/links: 10%.
- Trust/security/spam risk: 5%.

If GSC, GA4, or real field data is unavailable, mark confidence as limited.

## Output Format

For Bulgarian user responses:

1. `SEO оценка: XX/100`.
2. `Покрито` — concrete passed signals.
3. `Липсва/частично` — prioritized issues.
4. `Top fixes` — exact actions.
5. `Ограничения на проверката`.
6. `Файлове за качване:` — if no files edited, say `Няма нови файлове за качване.`

## Common Pitfalls

- Do not call a URL indexed unless GSC confirms it or public Google evidence is strict and real.
- Do not treat sitemap presence as indexing proof.
- Do not treat PageSpeed lab variation as exact truth; use it as performance evidence.
- Do not recommend work for myths/unconfirmed SEO claims.
- Do not save a report during dry runs.

## Verification Checklist

- [ ] Live URL evidence collected.
- [ ] SEO criteria groups evaluated.
- [ ] Every issue has evidence and fix.
- [ ] Myths are marked `do_not_optimize`.
- [ ] Score and limitations stated.
- [ ] No files written when dry run was requested.
