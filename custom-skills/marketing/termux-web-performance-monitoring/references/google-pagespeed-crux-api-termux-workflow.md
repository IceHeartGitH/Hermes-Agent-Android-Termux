# Google PageSpeed / CrUX API workflow on Termux

Reusable pattern from the Example project performance-monitoring session.

## Goal

Use Android/Termux as the command center for automatic Google performance monitoring:

- PageSpeed Insights API for Lighthouse/PSI snapshot data.
- Chrome UX Report API for CrUX History trend data.
- Local `.env` file for API keys.
- Obsidian/project reports for durable analysis.

## Safe key handling

Store the Google API key locally, not in chat, GitHub, Obsidian, screenshots, or raw reports:

```sh
mkdir -p ~/.config/example-project
chmod 700 ~/.config/example-project
touch ~/.config/example-project/.env
chmod 600 ~/.config/example-project/.env
printf '%s\n' 'PAGESPEED_API_KEY=YOUR_REAL_KEY' > ~/.config/example-project/.env
```

Verify without printing the key:

```sh
f="$HOME/.config/example-project/.env"
test -f "$f" && echo exists=yes
wc -c < "$f"
grep -q '^PAGESPEED_API_KEY=' "$f" && echo key_line=yes || echo key_line=no
```

Pitfall: if the user accidentally creates files whose filename contains `PAGESPEED_API_KEY`, delete only those mistaken files and keep the correct `.env`:

```sh
find "$HOME/.config/example-project" "$HOME" -maxdepth 1 -type f -name '*PAGESPEED_API_KEY*' -delete 2>/dev/null || true
```

Do not print full filenames if they may contain secret text.

## Google Cloud setup

For PageSpeed snapshots:

1. Google Cloud Console → APIs & Services → Library.
2. Enable `PageSpeed Insights API` (`pagespeedonline.googleapis.com`).
3. Create/reuse an API key.
4. Restrict the key to PageSpeed Insights API where possible.

For CrUX History endpoint:

1. Enable `Chrome UX Report API` (`chromeuxreport.googleapis.com`) separately.
2. If the PageSpeed key returns `403 SERVICE_DISABLED` on CrUX History, the fix is enabling this API, not changing the key format.

Common error interpretation:

- `400 INVALID_ARGUMENT: API key not valid` → `.env` missing/incorrect key line or invalid key.
- `403 PERMISSION_DENIED ... PageSpeed Insights API ... disabled` → enable PageSpeed Insights API.
- `403 PERMISSION_DENIED ... Chrome UX Report API ... disabled` → enable Chrome UX Report API.
- `429 Too Many Requests` → use a valid key, wait/back off, or reduce frequency.

## PSI API request pattern

Call `https://www.googleapis.com/pagespeedonline/v5/runPagespeed` with:

- `url=https://example.com/`
- `strategy=mobile` and `strategy=desktop`
- `category=performance`, `accessibility`, `best-practices`, `seo`
- `key=$PAGESPEED_API_KEY`

Extract:

- category scores: performance/accessibility/best-practices/seo
- lab metrics: FCP, LCP, TBT, CLS, Speed Index, server-response-time, interactive
- opportunities: unused JavaScript/CSS, render-blocking resources, LCP request discovery, total-byte-weight, main-thread work, bootup-time, unsized-images
- field metrics from `loadingExperience.metrics`

Store raw JSON under project data, e.g. `04_Data/*psi-api-mobile*.json`, and write a short human report linking the raw files.

## CrUX History request pattern

Call `https://chromeuxreport.googleapis.com/v1/records:queryHistoryRecord?key=...` with JSON body such as:

```json
{
  "origin": "https://example.com",
  "formFactor": "PHONE",
  "metrics": [
    "largest_contentful_paint",
    "first_contentful_paint",
    "experimental_time_to_first_byte",
    "interaction_to_next_paint",
    "cumulative_layout_shift"
  ]
}
```

Use p75 time series to find the start of a loading regression:

1. Build period rows from `collectionPeriods`.
2. Extract p75s from each metric's `percentilesTimeseries.p75s`.
3. Compare LCP + FCP + TTFB together, not in isolation.
4. The problem start is the first rolling period where LCP, FCP, and TTFB rise together and remain elevated.
5. INP/CLS can be reported as controls; do not blame them when loading metrics are the simultaneous movers.

## Lightweight crawler additions

For key CSS/JS assets, `HEAD` may not return `Content-Length`. If so, use a bounded GET or `Accept-Encoding: identity` for important assets and record measured bytes. This avoids false `0 KB` CSS/JS conclusions.

## Reporting pattern

Keep the user-facing answer short:

- exact start rolling period
- previous good baseline
- peak period
- latest period
- LCP/FCP/TTFB deltas
- one human conclusion

Example conclusion shape:

```text
Проблемът започва видимо в rolling периода YYYY-MM-DD → YYYY-MM-DD.
Предишната ясно добра база е YYYY-MM-DD → YYYY-MM-DD.
Едновременно се вдигат LCP, FCP и TTFB, значи това е loading problem: server/cache + critical CSS/JS + LCP resources, не основно INP/CLS.
```
