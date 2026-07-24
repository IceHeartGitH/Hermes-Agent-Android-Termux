---
name: seo-geo-site-audits
description: Perform practical SEO + GEO/AI visibility audits of websites, gather crawl evidence, and write actionable reports into a user-selected project folder.
---

# SEO + GEO Site Audits

Use this skill when the user asks for a full SEO audit, GEO audit, AI Overviews readiness audit, Google 2026 requirements review, local SEO analysis, e-commerce SEO audit, or asks to create a report file for a website.

## Core principles

- Produce a real artifact, not just advice: crawl the site, analyze evidence, write the report file, then verify it exists and is readable.
- Ground claims in live data where possible: HTTP status, redirects, robots.txt, sitemap, titles, meta descriptions, canonicals, headings, schema types, image alt coverage, internal links, and representative page samples.
- Be explicit about data limits. If there is no Google Search Console, GA4, Google Business Profile, PageSpeed Insights API, or Lighthouse access, label Core Web Vitals, query data, CTR, indexing, and conversion findings as requiring confirmation.
- For Bulgarian-speaking users, write the final report and response in Bulgarian unless asked otherwise.
- Keep private/sensitive content safe: do not open unrelated files from user storage while saving reports.

## Workflow

1. Confirm target and output location from the user’s instruction.
   - If they named an existing project folder, use it.
   - If the user says they upload specific files, treat that as the deployment source of truth and ignore stale/removed variants unless explicitly requested.
   - If the user asks to apply selected “audit points,” map their requested numbers to the audit/report or numbered list they explicitly referenced — not to any separate plan you previously proposed. Restate briefly which numbered items were applied/skipped, then edit only those items.

2. Crawl public site evidence:
   - homepage variants: `http://domain`, `https://domain`, `https://www.domain`
   - `robots.txt`
   - `sitemap.xml`
   - sitemap index children such as categories, products, blogs, pages, locations, landings
   - representative pages from sitemap and internal links
   - optionally contact/about/service/location/landing pages if relevant

3. Extract and summarize:
   - HTTP status, final URL, redirect behavior, response time, content type, byte size
   - title, meta description, meta robots, canonical, lang, viewport
   - H1/H2/H3 structure and multiple/missing H1 issues
   - image count and missing alt count
   - internal/external link counts and broken link sample
   - JSON-LD types: Organization, WebSite, Product, Offer, BreadcrumbList, BlogPosting, FAQPage, LocalBusiness, Service, CollectionPage
   - sitemap counts and URL classes
   - security/trust headers when visible

4. Analyze by sections:
   - Executive summary and score
   - Technical SEO: crawling, indexing, redirects, canonical, sitemap, robots
   - Mobile-first and Core Web Vitals readiness
   - On-page SEO: title/meta/H1/content/images/internal linking
   - Structured data / Schema.org
   - Helpful Content and E-E-A-T
   - GEO / AI Overviews / generative engine optimization
   - Local SEO and location pages
   - E-commerce SEO, if applicable
   - Content gaps
   - Prioritized action list: P0/P1/P2/P3
   - 30-day plan and KPIs

5. Write deliverables:
   - Main report: `SEO-GEO-Audit-<domain>-<year>.md`
   - Supporting crawl data: `<domain>-audit-crawl-data.json` when useful
   - Verify line count, file size, and first lines with readback.

## Report standards

- Make the report actionable, not generic. Include concrete URLs and counts from the crawl.
- Separate facts from recommendations.
- Use priority labels:
  - P0: critical or trust/indexing issues
  - P1: high-impact SEO/GEO fixes
  - P2: medium improvements
  - P3: nice-to-have enhancements
- Include caveats for tools/data not available.
- For GEO, focus on machine-readable entity clarity, direct answers, FAQ blocks, citations, tables, expert authorship, local/service schema, and concise answer-first content.

## Practical crawl approach

If third-party Python packages like BeautifulSoup are unavailable, do not block. Use Python stdlib:

- `urllib.request` for HTTP
- `html.parser.HTMLParser` for title/meta/headings/links/images
- `xml.etree.ElementTree` or regex for sitemap loc extraction
- `json` and regex for JSON-LD extraction
- `collections.Counter` for duplicates and schema counts

See `scripts/stdlib_seo_crawler.py` for a reusable starting point.

## Deep second-pass workflow

When the user asks to repeat the check, make it more detailed, ensure nothing was missed, or produce a maximally detailed audit, do a real second crawl instead of only expanding prose.

Second-pass additions:

1. Recursively parse every nested sitemap and count URL classes: category/home, product/subcategory, blog, info, service, location, brand, landing.
2. Increase the HTML sample and force coverage of info, service, blog, landing, location, product/category templates.
3. Check sitemap URL status with HEAD first and GET fallback; count 4xx/5xx and redirected sitemap URLs.
4. Re-check canonical accurately by template type. Do not assume category findings apply to info/service pages.
5. Detect JSON-LD parse errors, not only schema type presence.
6. Search rendered HTML for global placeholder/test data such as `example@email.com`, demo phone numbers, `Lorem ipsum`, and placeholder strings.
7. Flag title/meta length issues, especially templated location pages with very short descriptions.
8. Identify heavy category/location pages: HTML bytes, image count, lazy-loaded image count, script count, CSS count.
9. Check optional discovery/trust/GEO endpoints: `/llms.txt`, `/.well-known/security.txt`, `/manifest.json`, `/ads.txt` when relevant.
10. Append a new section to the report with second-pass counts, newly discovered issues, corrected priorities, and revised 1–10 ratings. It is acceptable and preferred to lower earlier scores when broader data reveals template-level problems.

## Common findings to check

- Missing or duplicate meta descriptions
- Very short templated location meta descriptions
- Multiple H1 caused by templates
- Missing canonical on info/service pages even when category pages have canonicals
- Homepage missing Organization/WebSite/LocalBusiness schema
- Location pages missing LocalBusiness/Service/areaServed schema
- FAQ pages or FAQ-like visible sections with invalid JSON-LD or missing FAQPage schema
- Many location pages with thin or templated city text, risking doorway-page classification
- Bulgarian city grammar issues such as `в Варна`, `в Враца`, `в Велико Търново` instead of correct `във ...`
- Test/example contact details accidentally present in HTML, especially if global across templates
- Missing HSTS, CSP, X-Content-Type-Options, Referrer-Policy, Permissions-Policy, X-Frame-Options
- Heavy category/location pages and image payloads
- Large product grids with many images and no `loading="lazy"` below the first viewport
- Blog posts without author, reviewer, dateModified, or visible expert signals
- Missing optional GEO/trust files such as `llms.txt` and `security.txt` — note these are not Google ranking requirements, only auxiliary discovery/trust aids

## Landing page edit workflow additions


- For cookie/GDPR work, prefer strict-but-marketing-usable consent: Google Consent Mode v2 default denied before GTM; Meta Pixel loaded only after accept; Lead/Buy/Contact conversion events gated behind consent; footer cookie policy link present. Wrap `localStorage` access in safe helpers so incognito/mobile storage restrictions do not prevent the banner from displaying.
- For simple pre-consent page view totals, prefer a cookieless first-party aggregate counter, not Meta/Google tracking before consent.
- When auditing uploaded landing pages online, URL-encode resource paths before fetching them. Image names with spaces or `+` characters can produce false HTTP failures if fetched raw; verify encoded URLs before reporting broken resources.
- For Google indexing checks, distinguish technical indexability from confirmed Google indexing. Public `site:` checks can false-positive when the URL appears only in Google's query/help markup, so parse for real result links/snippets after stripping scripts/styles and removing query text. Always check root robots, page meta/X-Robots/canonical, and recursive sitemap inclusion; flag sitemap index children that return 404 (e.g. a broken `sitemap_landings.xml`) as P1 discovery issues. Say “public Google evidence does not confirm indexing yet” unless Google Search Console URL Inspection confirms the state. See `references/google-indexing-sitemap-checks.md`.
- Treat counter endpoint checks as side-effecting: calling `visit_counter.php` increments the production count. Warn the user and avoid repeated endpoint probes unless needed.
- For online GTM/Meta Pixel checks, separate page-side event contract from GTM-container proof: fetching public `gtm.js` can confirm the container and visible IDs, but custom `dataLayer` events still need GTM Preview/Tag Assistant or container access to prove trigger firing. Do not submit fake leads or intentionally fire live conversion events unless the user explicitly approves.
- If the user explicitly approves a fake/live conversion test, mark all fake data with an unmistakable run ID and `IGNORE`, record exact HTTP statuses, and explain which events may now appear in live Meta/Google reporting. On Termux/Android, check for DNS/adblock/private-DNS blocking of `www.google-analytics.com`, `region1.google-analytics.com`, or `googleads.g.doubleclick.net` before calling GA4/Ads broken.
- For landing pages with public technical files, keep the page itself indexable but disallow/noindex endpoints and state/dev/report files. Use root robots rules when possible; a folder-level `robots.txt` is only a page-specific copy/reference for most crawlers. Add direct `X-Robots-Tag: noindex, nofollow, noarchive` headers to JSON/PHP endpoints such as `send_lead.php` and `visit_counter.php`, and use `.htaccess`/server config for static `.txt`, `.json`, `.md`, and `.py` artifacts when supported.
- For cookieless aggregate counter state files (`visit_count.txt`, `visit_stats.txt`), noindex is not the same as privacy. When the user wants stricter protection, add `.htaccess` direct-access denial for those files while preserving `visit_counter.php` filesystem access; verify online that the `.txt` files return denied/404 while `visit_counter.php` still returns JSON.

## Verification

Before telling the user it is done:

1. Verify the target folder exists.
2. Verify the report file exists when a report is part of the deliverable.
3. Read back the first lines of the report when a report is part of the deliverable.
4. Report file path, size, and line count for generated reports/artifacts.
5. Mention any supporting data files created.
7. For PHP-backed counters/forms, run `php -l` when PHP is available; if possible, test the endpoint via the local PHP built-in server and reset local counter state before first upload.

## References

- `references/google-indexing-sitemap-checks.md` — Google indexing checks: strict public `site:` parsing, technical indexability vs confirmed indexing, recursive sitemap validation, and broken child-sitemap remediation.

## Scripts

- `scripts/stdlib_seo_crawler.py` — dependency-light crawler skeleton for extracting SEO evidence when bs4/lxml are unavailable.
