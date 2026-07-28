---
name: pagespeed-crux-monitoring
description: Use when automating PSI and CrUX performance checks.
---

# PageSpeed + CrUX Monitoring

Use this when the user wants automated Google Insights-style checks, Core Web Vitals history, post-change performance verification, or a concise answer about whether a site improved.

This is a class-level workflow for combining:

- PageSpeed Insights API snapshots;
- Chrome UX Report / CrUX History trends;
- lightweight crawlers and saved raw JSON;
- concise Obsidian/project reports.

## Core principles

1. Use real Google/API outputs for scores and metric claims. Do not infer PSI scores or lab metrics from a crawler.
2. Keep API keys local and redacted. Never print keys, write them to Obsidian, commit them, or include them in raw reports.
3. Separate lab and field data:
   - PSI Lighthouse lab data: performance score, FCP, LCP, TBT, CLS, Speed Index, opportunities.
   - CrUX field data: real-user p75 LCP/FCP/TTFB/INP/CLS and historical trends.
4. For change verification, compare fresh results against the latest saved summary file, then summarize deltas.
5. If lab results are surprising, run a second mobile test before making a strong claim; PSI/Lighthouse lab TBT/CLS can vary.

## Local API key handling

Recommended Termux pattern:

```sh
mkdir -p ~/.config/example-project
touch ~/.config/example-project/.env
chmod 700 ~/.config/example-project
chmod 600 ~/.config/example-project/.env
printf '%s\n' 'PAGESPEED_API_KEY=<key>' > ~/.config/example-project/.env
```

When checking the file, print only:

- file exists;
- byte count;
- line count;
- whether the PageSpeed API key line exists;
- key length.

Never print the key value. If the user accidentally creates files whose names contain `PAGESPEED_API_KEY`, delete only files matching `*PAGESPEED_API_KEY*` and do not echo their full names because the filename may contain the secret.

## Google Cloud setup

For PageSpeed snapshots:

1. Enable `PageSpeed Insights API`.
2. Create an API key.
3. Prefer `Restrict key` to `PageSpeed Insights API`.
4. If calls return `403 SERVICE_DISABLED`, the API is disabled or still propagating.

For historical CrUX:

- Enable `Chrome UX Report API` separately.
- A key can work for PageSpeed and still return `403 SERVICE_DISABLED` from `chromeuxreport.googleapis.com` until Chrome UX Report API is enabled.
- PageSpeed responses include current field metrics; historical time series require CrUX History.

## PageSpeed Insights request

Endpoint:

`https://www.googleapis.com/pagespeedonline/v5/runPagespeed`

Run both strategies separately:

- `strategy=mobile`
- `strategy=desktop`

Include repeated categories:

- `category=performance`
- `category=accessibility`
- `category=best-practices`
- `category=seo`

Extract:

- category scores: performance, accessibility, best-practices, SEO;
- lab metrics: FCP, LCP, TBT, CLS, Speed Index, TTI/server-response-time;
- opportunities/diagnostics: unused JS/CSS, render-blocking resources, network dependency tree, LCP request discovery, CLS culprits, bootup/main-thread work;
- `loadingExperience.metrics` field metrics.

## Post-change comparison workflow

When the user says they changed the site and asks whether it improved:

1. Run fresh PSI mobile + desktop.
2. Save raw JSON with a timestamp.
3. Summarize both strategies.
4. Compare against the latest saved PSI summary, not against memory.
5. Report deltas for:
   - Performance score;
   - FCP;
   - LCP;
   - TBT;
   - CLS;
   - Speed Index.
6. If mobile changed sharply or contradicts the apparent fix, run a second mobile PSI test.
7. Interpret mixed results plainly, e.g. “LCP improved, but CLS worsened, so mobile score fell.”
8. Save a concise report in the project brain.

## CrUX History problem-start workflow

When identifying when a performance problem began:

1. Prefer direct `chromeuxreport.googleapis.com/v1/records:queryHistoryRecord` when Chrome UX Report API is enabled.
2. Use origin-level PHONE data for mobile performance issues.
3. Request:
   - `largest_contentful_paint`
   - `first_contentful_paint`
   - `experimental_time_to_first_byte`
   - `interaction_to_next_paint`
   - `cumulative_layout_shift`
4. Build period rows with p75 values.
5. Look for simultaneous sustained worsening in LCP + FCP + TTFB.
6. Report:
   - last clearly good period;
   - first visible worsening rolling period;
   - peak worsening period;
   - latest period;
   - exact deltas.
7. If LCP/FCP/TTFB worsen together while INP/CLS stay acceptable, call it a loading/critical-path problem, not an interactivity or visual-stability root cause.

## Obsidian/project report convention

For project-brain workflows:

- raw JSON: `04_Data/`
- concise analysis: `01_Audit_Report_Split/` or `05_Weekly_Updates/`
- action plans: `06_Action_Plans/`
- update the project `Съдържание.md` quick links for important reports.

Do not store API keys in Obsidian or project folders.

## Concise Bulgarian reporting pattern

Lead with the result:

```text
Кратко: има/няма подобрение.
Mobile: Performance X → Y, LCP A → B, CLS C → D.
Извод: ...
```

Then list only the few metrics that explain the verdict. Put file paths and raw JSON locations after the human verdict.

## References

- `references/example-project-psi-crux-session-2026-07.md` — concise session notes on Android/Termux PSI setup, secret-safe `.env` handling, PageSpeed vs Chrome UX Report API distinction, and post-change comparison pitfalls.

## Common pitfalls

- Do not call field CrUX “bad” when lab Lighthouse is bad; field and lab can diverge.
- Do not conclude a fix worked from one metric only. A lower LCP can still lose overall score if CLS/TBT worsens.
- Do not claim direct CrUX History is available just because PageSpeed API works; enable Chrome UX Report API separately.
- Do not print or preserve API keys while debugging `.env` files or accidental filenames.
