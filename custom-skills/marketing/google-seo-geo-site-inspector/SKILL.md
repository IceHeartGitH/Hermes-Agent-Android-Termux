---
name: google-seo-geo-site-inspector
description: "Use when full combined Google SEO and GEO inspection."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [marketing, seo, geo, ai-search, audit, google]
    related_skills: [google-seo-site-inspector, google-geo-site-inspector, seo-geo-site-audits, seo-google]
---

# Google SEO + GEO Site Inspector

## Overview

Use this skill for the full combined inspection across the user's professional Google SEO and GEO criteria banks.

Criteria banks:

- SEO: `${HERMES_HOME:-$HOME/.hermes-venv}/skill-libraries/google-seo-geo-criteria-bank/Google SEO Criterions`
- GEO: `${HERMES_HOME:-$HOME/.hermes-venv}/skill-libraries/google-seo-geo-criteria-bank/Google GEO Criterions`

Together they contain 387 professional inspection-ready criteria:

- 201 SEO criteria.
- 186 GEO criteria.

Each criterion has requirements, audit evidence, pass/fail conditions, fix recommendation, priority, risk, and sources.

This skill does not promise 100% indexing, ranking, or AI citation. It evaluates maximal conditions for crawl, indexability, ranking eligibility, search appearance, and GEO citability.

## When to Use

Use when the user asks for a complete SEO + GEO audit, Google 2026 readiness, AI Search + SEO inspection, full site/page inspection, or wants to know what a concrete page/site has, lacks, and how to fix it across both SEO and GEO.

Use `google-seo-site-inspector` for SEO-only checks.
Use `google-geo-site-inspector` for GEO/AI-only checks.

## Operating Modes

### Dry run / no save

If the user says dry run, test, do not save, or asks only for a summary:

1. Collect live evidence.
2. Run SEO evaluation.
3. Run GEO evaluation.
4. Merge overlaps and deduplicate fixes.
5. Summarize in chat only.
6. Do not write report files.
7. Do not update Obsidian.

### Full report

If the user asks to save a report:

1. Collect live evidence.
2. Evaluate SEO and GEO criteria groups.
3. Produce a combined report with separate SEO/GEO scoring and one merged action plan.
4. Optionally save raw JSON evidence.
5. Verify report existence and readability.

## Evidence Collection

Gather at minimum:

- HTTP status, final URL, redirects, response bytes.
- robots.txt, sitemap index, child sitemaps, target URL inclusion.
- title, meta description, canonical, robots meta, viewport.
- H1/H2/H3 structure.
- visible word count and content intent fit.
- internal/external links.
- image count and missing alt.
- JSON-LD schema types and parse errors.
- security/trust headers.
- AI/Search preview controls and AI crawler policy.
- direct answer blocks, question headings, tables, cited facts.
- entity/brand/author trust signals.
- freshness/source evidence.
- PageSpeed Insights / CrUX when available.
- GSC/GA4/GBP only when credentials/access are available.

Use dependency-light Python stdlib if needed. Existing helper script:
`Use the bundled `seo-geo-site-audits` helper script when installed, or collect equivalent live evidence with Python stdlib.`

## Full Criteria Pass

The ideal full pass checks all 387 criteria by reading/using the criteria-bank notes and mapping each criterion to evidence.

For practical output, group findings by:

1. Technical indexability.
2. Sitemap/canonical/robots.
3. On-page metadata/headings.
4. Content quality and E-E-A-T.
5. Schema and machine readability.
6. Media/images/video.
7. Links and architecture.
8. Performance and mobile UX.
9. Ecommerce/product/local when applicable.
10. GEO citability and answer blocks.
11. Entity/brand/author trust.
12. AI crawler/preview controls.
13. Monitoring/data limitations.
14. Spam/policy risk.
15. Myths/unconfirmed claims as `do_not_optimize`.

## Result States

Each criterion should map to one state:

- `passed` — criterion is covered.
- `partial` — partly covered; risk remains.
- `missing` — missing or broken.
- `not_applicable` — not relevant to this URL/site type.
- `do_not_optimize` — myth/unconfirmed; do not make it a task.

For every `partial` or `missing` result include evidence, risk, exact fix, and priority.

## Scoring

Return separate scores:

- SEO readiness: 0–100.
- GEO readiness: 0–100.
- Combined readiness: weighted average, default 60% SEO / 40% GEO unless user asks otherwise.

Also report confidence:

- High: crawl + sitemap + PageSpeed/GSC evidence available.
- Medium: crawl + PageSpeed available, no GSC.
- Limited: HTML-only or partial fetch.

## Prioritization

Use:

- P0: blocks indexing, crawl, trust, spam/policy, security, or conversion-critical access.
- P1: high-impact SEO/GEO improvements such as LCP, schema, canonical, missing answer blocks.
- P2: medium optimizations such as better internal links, sources, alt improvements, metadata refinements.
- P3: optional items such as llms.txt for non-Google AI or extra crawler policy details.

## Output Format

For Bulgarian user responses:

1. `SEO оценка: XX/100`.
2. `GEO оценка: XX/100`.
3. `Combined readiness: XX/100`.
4. `Покрито` — concrete passed signals.
5. `Липсва/частично` — prioritized issues.
6. `Top fixes` — merged, deduplicated action list.
7. `Митове / do_not_optimize` when relevant.
8. `Ограничения на проверката`.
9. `Файлове за качване:` — if no files edited, say `Няма нови файлове за качване.`

## Common Pitfalls

- Do not claim confirmed indexing without GSC or strict public Google evidence.
- Do not treat sitemap inclusion as indexing proof.
- Do not double-count the same issue in SEO and GEO; merge fixes.
- Do not recommend work for myths/unconfirmed criteria.
- Do not save anything during dry runs.
- Do not promise 100% indexing, ranking, or citation.

## Verification Checklist

- [ ] Live URL evidence collected.
- [ ] SEO criteria groups evaluated.
- [ ] GEO criteria groups evaluated.
- [ ] Overlapping fixes deduplicated.
- [ ] Every issue has evidence, risk, and fix.
- [ ] Myths are marked `do_not_optimize`.
- [ ] Separate SEO/GEO scores and limitations stated.
- [ ] No files written when dry run was requested.
