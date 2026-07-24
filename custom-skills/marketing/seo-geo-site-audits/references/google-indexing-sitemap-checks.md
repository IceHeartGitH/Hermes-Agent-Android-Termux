# Google indexing and sitemap checks for landing pages

Use this when the user asks whether a landing page is indexed in Google.

## Key lesson

Public Google `site:` checks are useful but not authoritative. They can also produce false positives if the checked URL appears only inside Google's own query/help markup rather than a real result link.

Google Search Console URL Inspection remains the authoritative check.

## Recommended workflow

1. Check technical indexability of the target URL:
   - HTTP status is `200`.
   - final URL matches expected canonical.
   - `Content-Type` is HTML.
   - page-level `X-Robots-Tag` does not include `noindex`.
   - `<meta name="robots">` does not include `noindex`.
   - canonical points to the same URL or a deliberate canonical target.

2. Check robots rules:
   - root `https://domain/robots.txt` is reachable.
   - the target path is not disallowed.
   - folder-level robots files can be useful as local references but do not replace root robots for most crawlers.

3. Check sitemap inclusion recursively:
   - fetch root `sitemap.xml`.
   - if it is a sitemap index, fetch all child sitemap URLs.
   - verify each child sitemap returns HTTP `200` and valid XML-like content.
   - search normalized URLs with and without trailing slash.
   - flag sitemap index entries that return `404`, because they can slow discovery and waste crawl attention.

4. Run public Google checks, but parse strictly:
   - `site:domain/path`
   - exact URL in quotes
   - title/entity terms with `site:domain`
   - Do not count the URL if it appears only in the query string, hidden diagnostics, Google help links, or retry links.
   - Prefer real result links such as decoded `/url?q=...` targets or visible result snippets after stripping scripts/styles and removing the query text.

5. Report carefully:
   - If no strict result link is found, say: “Public Google evidence does not confirm that the page is indexed yet.”
   - Do not say “definitely not indexed” unless Search Console confirms it.
   - If the page is technically indexable but not found publicly, recommend Search Console URL Inspection → Request Indexing.

## Common sitemap finding

A root sitemap can reference a landing sitemap such as:

```text
https://domain/sitemap_landings.xml
```

If that child sitemap returns `404`, this is a P1 indexing/discovery issue. Fix by either:

- making the child sitemap return HTTP `200` with valid XML; or
- removing the broken child sitemap reference from the root sitemap index.

Then add the landing URL:

```xml
<url>
  <loc>https://domain/lp/example/</loc>
  <lastmod>YYYY-MM-DD</lastmod>
  <changefreq>weekly</changefreq>
  <priority>0.80</priority>
</url>
```

Finally resubmit the sitemap in Google Search Console and request indexing for the URL.
