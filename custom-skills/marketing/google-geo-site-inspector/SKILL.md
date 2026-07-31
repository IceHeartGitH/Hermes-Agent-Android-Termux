---
name: google-geo-site-inspector
description: "Use when full Google GEO/AI criteria inspection."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [marketing, geo, ai-search, audit, google]
    related_skills: [seo-geo-site-audits, seo-geo, ai-seo, google-seo-site-inspector]
---

# Google GEO Site Inspector

## Overview

Use this skill to inspect a site or single URL against the user's professional GEO / AI Search criteria bank.

Criteria bank:
`${HERMES_HOME:-$HOME/.hermes-venv}/skill-libraries/google-seo-geo-criteria-bank/Google GEO Criterions`

The bank contains 186 GEO criteria, grouped and normalized with professional inspection fields: requirements, audit evidence, pass/fail conditions, fix recommendation, priority, risk, and sources.

This skill does not promise 100% AI citation, Google AI Overview visibility, AI Mode inclusion, ranking, or indexing. It evaluates whether the page/site has maximal conditions for crawl, indexability, ranking eligibility, machine readability, entity clarity, and GEO citability.

## When to Use

Use when the user asks for GEO, AI SEO, AEO, LLM visibility, Google AI Overviews readiness, AI Mode readiness, AI citation analysis, answer block optimization, AI crawler policy, entity/brand authority for AI, or GEO-only analysis.

Do not use for SEO-only checks; use `google-seo-site-inspector`. Use `google-seo-geo-site-inspector` when the user wants both SEO and GEO together.

## Operating Modes

### Dry run / no save

If the user says dry run, test, do not save, or asks only for a summary:

1. Collect live evidence.
2. Evaluate GEO criteria groups.
3. Summarize in chat only.
4. Do not write report files.
5. Do not update Obsidian.

### Full report

If the user asks to save a report:

1. Collect live evidence.
2. Evaluate GEO criteria groups.
3. Write a report into the requested project folder.
4. Optionally save raw JSON evidence.
5. Verify the report file exists and is readable.

## Evidence Collection

Gather at minimum:

- Crawl/index status and technical accessibility.
- robots.txt and AI crawler policy.
- AI/Search preview controls: noindex, nosnippet, max-snippet, data-nosnippet.
- canonical and sitemap inclusion.
- direct answer blocks, question headings, definitions, tables, and citable passages.
- entity clarity: Organization, Person, author, sameAs, About, Contact, brand consistency.
- structured data: Organization, Product, Article, LocalBusiness, Person, FAQ/QAPage, Breadcrumb, VideoObject, ImageObject where applicable.
- freshness: visible date, last updated, current claims.
- sources/evidence: cited facts, primary sources, statistics with dates.
- media accessibility: image alt, video transcripts, table text equivalents.
- PageSpeed/mobile accessibility if available.
- Optional llms.txt only as non-Google auxiliary; never as Google ranking factor.

Use dependency-light Python stdlib if needed. Existing helper script:
`Use the bundled `seo-geo-site-audits` helper script when installed, or collect equivalent live evidence with Python stdlib.`

## Criteria Groups to Apply

Evaluate GEO criteria by group: Google AI Search basics, AI feature controls, citability/content structure, entity authority/brand signals, technical accessibility/rendering, AI crawlers/robots/access, structured data/machine readability, freshness/original evidence, multimodal AI visibility, local/commerce GEO, platform-specific AI surfaces, GEO monitoring/measurement, and GEO myths as `do_not_optimize`.

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

- SEO/indexability base: 25%.
- Citability and answer-first structure: 25%.
- Entity/brand/author trust: 20%.
- Structured data and machine readability: 15%.
- AI controls/crawler policy: 10%.
- Freshness/sources/media support: 5%.

If Google AI feature reporting, GSC, AI platform data, or real citation evidence is unavailable, mark confidence as limited.

## Output Format

For Bulgarian user responses:

1. `GEO оценка: XX/100`.
2. `Покрито` — concrete passed signals.
3. `Липсва/частично` — prioritized issues.
4. `Top fixes` — answer blocks, entity, schema, sources, crawler controls.
5. `Митове / do_not_optimize` when relevant.
6. `Ограничения на проверката`.
7. `Файлове за качване:` — if no files edited, say `Няма нови файлове за качване.`

## Common Pitfalls

- Do not treat GEO as separate magic from SEO; for Google it is SEO fundamentals applied to AI Search surfaces.
- Do not recommend llms.txt as a Google ranking or AI Overviews lever.
- Do not treat AI crawler rules as equivalent to Googlebot indexing controls.
- Do not recommend work for GEO myths/unconfirmed claims.
- Do not save a report during dry runs.

## Verification Checklist

- [ ] Live URL evidence collected.
- [ ] GEO criteria groups evaluated.
- [ ] Every issue has evidence and fix.
- [ ] Myths are marked `do_not_optimize`.
- [ ] Score and limitations stated.
- [ ] No files written when dry run was requested.
