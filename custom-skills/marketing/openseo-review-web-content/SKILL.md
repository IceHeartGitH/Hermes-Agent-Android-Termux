---
name: openseo-review-web-content
description: Use when reviewing SEO website content for usefulness, clarity, claims, reader value, and non-generic quality; no API required.
version: 0.1.0
author: every-app/OpenSEO; adapted for Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [marketing, seo, openseo, no-api]
    related_skills: [seo-content, seo-audit, humanizer]
    source: https://github.com/every-app/open-seo/tree/f56972639f14/.agents/skills/openseo-review-web-content
---
# OpenSEO Web Content

Everything we publish must be traceable to what the product actually does and costs, and must read like a practitioner wrote it. The reader's interest comes first: teach something they can act on, and answer straight — including when the honest answer is "no" or "it costs money."

## Principles

1. **Traceable truth.** Every capability claim, price, and screenshot is verifiable against the code, the fact sheet (`src/server/features/onboarding/openseo-fact-sheet.md`), or the live product. If you can't point to where it's true, it doesn't ship.
2. **Lead with the real answer.** "No," "not unlimited," and "it costs money" are complete answers. Hedging that lets a reader infer something more flattering than the truth is a way of misleading them.
3. **Honest pricing, with its reasoning.** Quality SEO data is expensive everywhere — that's why the big suites run $100/month and up. OpenSEO is the affordable option: $10/month, free to start. Never simply "free."
4. **Sound like a person.** Fix AI tells by restating the underlying claim plainly, not by polishing the flourish. The [deslop skill](../deslop/SKILL.md) is the reference for what to hunt and how to fix it.
5. **Reader-first altitude.** Guides teach actionable SEO that stands on its own — not product documentation, not generic filler. Credit free resources to their real owners (Google's autocomplete, the reader's own Search Console).
6. **One bar, whole surface.** When a standard improves, sweep everything to it — all the FAQs, all the pages — not just the instance that got noticed.

## Questions to ask while reviewing

- If a reader trusted every claim and screenshot, then opened OpenSEO right now, where would reality not match?
- Does each answer open with the real answer, or quietly steer toward a more flattering inference?
- Read the sharpest line aloud: would a person say it that way?
- Is anything called free that actually costs credits?
- Is this teaching the reader something useful on its own, or drifting into product docs or padding?
- Does every link, image, and example on the page earn its place for the reader?

## Facts to verify, not remember

Check these against code before repeating any of them — they change: pricing and credits (`src/shared/billing.ts`, the pricing page), free-plan limits (`src/shared/audit-limits.ts`), MCP capabilities (`src/server/mcp/tools/` — one file per tool), and any UI affordance copy tells the reader to use (the column, sort, or filter must exist in the client code).

## Process

Spawn subagents to run the review passes (voice/deslop, claims accuracy, directness) and have them return exact old → new proposals rather than editing directly. Do not accept their proposals blindly: verify each one against the actual file, and each factual claim against the code, before applying — subagent rewrites can introduce their own awkwardness or errors, and a proposal that mismatches the file means it reviewed stale text. After applying, sweep the changed surface yourself (patterns cluster — one em dash or hedge usually has neighbors), then run `npm --prefix web run types:check` and prettier on touched TS/TSX.

## Hermes adaptation note

This converted skill is adapted from OpenSEO commit `f56972639f14`. It must not assume DataForSEO, Google OAuth, or OpenSEO MCP is configured. Use API/MCP data only when the relevant tool is actually available; otherwise use local files, Search Console exports, crawl outputs, manual research, or user-provided context and mark missing metrics as `unknown`.
