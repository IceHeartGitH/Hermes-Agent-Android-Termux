# Landing-page robots/noindex pattern for technical files

Use when a deployable landing page contains public PHP endpoints, counter storage files, reports, raw audit JSON, or dev scripts near `index.html`.

## Principle

Keep the landing page itself indexable. Do not block the whole landing folder. Block or mark only technical/support files.

Good root or folder-copy robots pattern:

```txt
User-agent: *
Allow: /lp/<slug>/
Allow: /lp/<slug>/images/
Allow: /lp/<slug>/style.css
Allow: /lp/<slug>/llms.txt

Disallow: /lp/<slug>/send_lead.php
Disallow: /lp/<slug>/visit_counter.php
Disallow: /lp/<slug>/visit_count.txt
Disallow: /lp/<slug>/visit_stats.txt
Disallow: /lp/<slug>/visit_count.lock
Disallow: /lp/<slug>/*.md
Disallow: /lp/<slug>/*.json
Disallow: /lp/<slug>/*.py
Disallow: /lp/<slug>/__pycache__/

Sitemap: https://example.com/sitemap.xml
Sitemap: https://example.com/lp/<slug>/sitemap.xml
```

Important: major crawlers normally read robots from the domain root (`https://domain/robots.txt`). A folder-level `robots.txt` can be uploaded as a reference/copy, but it does not replace root robots. Tell the user this plainly.

## X-Robots-Tag for endpoints

For PHP endpoints that return JSON, add the noindex header directly, immediately after `Content-Type`:

```php
header('Content-Type: application/json; charset=utf-8');
header('X-Robots-Tag: noindex, nofollow, noarchive');
```

Use for:

- `send_lead.php`
- `visit_counter.php`
- other JSON/webhook/utility endpoints

Verify locally with:

```sh
php -l visit_counter.php
php -l send_lead.php
php -S 127.0.0.1:8792 -t .
curl -sSI http://127.0.0.1:8792/visit_counter.php | grep -i 'X-Robots-Tag\|HTTP/'
curl -sSI http://127.0.0.1:8792/send_lead.php | grep -i 'X-Robots-Tag\|HTTP/'
```

A `405 Method Not Allowed` response is still acceptable for HEAD/GET endpoint header smoke tests as long as `X-Robots-Tag` is present.

## Apache `.htaccess` fallback for static artifacts

If the host is Apache/cPanel and `.htaccess` is allowed, add a landing-folder `.htaccess`:

```apache
<IfModule mod_headers.c>
    <FilesMatch "^(send_lead|visit_counter)\.php$">
        Header always set X-Robots-Tag "noindex, nofollow, noarchive"
    </FilesMatch>

    <FilesMatch "^(visit_count|visit_stats)\.txt$">
        Header always set X-Robots-Tag "noindex, nofollow, noarchive"
    </FilesMatch>

    <FilesMatch "\.(md|json|py)$">
        Header always set X-Robots-Tag "noindex, nofollow, noarchive"
    </FilesMatch>
</IfModule>
```

This is a complement to direct PHP headers, not a replacement. If the site is Nginx/Cloudflare-only, `.htaccess` may be ignored.

## Upload response convention

After adding these rules, list upload files explicitly:

- `robots.txt` if changed
- `.htaccess` if created/changed
- endpoint PHP files whose headers changed

Do not tell the user to upload report/dev files that are being disallowed/noindexed.
