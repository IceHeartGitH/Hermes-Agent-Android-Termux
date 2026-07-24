#!/usr/bin/env python3
"""Dependency-light SEO crawler skeleton.

Usage:
  python stdlib_seo_crawler.py https://example.com/ /tmp/example-audit-data.json

This intentionally uses Python stdlib only, so it works in constrained Termux
or fresh environments where bs4/lxml are not installed.
"""
import gzip
import json
import re
import ssl
import sys
import time
import urllib.parse
import urllib.request
import zlib
import xml.etree.ElementTree as ET
from collections import Counter, deque
from html.parser import HTMLParser

UA = "Mozilla/5.0 (compatible; Hermes SEO Audit Bot)"
CTX = ssl.create_default_context()


def fetch(url, method="GET", timeout=20, limit=2_000_000):
    req = urllib.request.Request(
        url,
        method=method,
        headers={
            "User-Agent": UA,
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Encoding": "gzip, deflate",
        },
    )
    start = time.time()
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=CTX) as r:
            raw = r.read(limit)
            enc = r.headers.get("Content-Encoding", "")
            if enc == "gzip":
                raw = gzip.decompress(raw)
            elif enc == "deflate":
                raw = zlib.decompress(raw)
            text = raw.decode(r.headers.get_content_charset() or "utf-8", errors="replace")
            return {
                "url": url,
                "final_url": r.geturl(),
                "status": r.status,
                "headers": dict(r.headers),
                "text": text,
                "bytes": len(raw),
                "time": round(time.time() - start, 3),
                "error": None,
            }
    except Exception as e:
        return {
            "url": url,
            "final_url": None,
            "status": None,
            "headers": {},
            "text": "",
            "bytes": 0,
            "time": round(time.time() - start, 3),
            "error": repr(e),
        }


class Parser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.title = ""
        self.in_title = False
        self.metas = []
        self.links = []
        self.anchors = []
        self.headings = []
        self.in_heading = None
        self.heading_buf = ""
        self.imgs = []
        self.lang = None
        self.text = []
        self.canonical = None

    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        if tag == "html":
            self.lang = d.get("lang")
        elif tag == "title":
            self.in_title = True
        elif tag == "meta":
            self.metas.append(d)
        elif tag == "link":
            self.links.append(d)
            rel = d.get("rel", "")
            if isinstance(rel, str) and "canonical" in rel.lower():
                self.canonical = d.get("href")
        elif tag in {"h1", "h2", "h3", "h4", "h5", "h6"}:
            self.in_heading = tag
            self.heading_buf = ""
        elif tag == "img":
            self.imgs.append(d)
        elif tag == "a":
            self.anchors.append(d)

    def handle_data(self, data):
        if self.in_title:
            self.title += data
        if self.in_heading:
            self.heading_buf += data
        s = " ".join(data.split())
        if s:
            self.text.append(s)

    def handle_endtag(self, tag):
        if tag == "title":
            self.in_title = False
        if self.in_heading and tag == self.in_heading:
            self.headings.append((self.in_heading, " ".join(self.heading_buf.split())))
            self.in_heading = None


def parse_html(html):
    p = Parser()
    try:
        p.feed(html)
    except Exception:
        pass
    metas = {}
    for m in p.metas:
        name = (m.get("name") or m.get("property") or "").lower()
        if name:
            metas[name] = m.get("content", "")
    jsonld_types = []
    for match in re.finditer(
        r"<script[^>]+type=[\"']application/ld\+json[\"'][^>]*>(.*?)</script>",
        html,
        flags=re.I | re.S,
    ):
        try:
            obj = json.loads(match.group(1).strip())
        except Exception:
            continue
        nodes = []
        if isinstance(obj, dict):
            nodes.append(obj)
            if isinstance(obj.get("@graph"), list):
                nodes.extend([x for x in obj["@graph"] if isinstance(x, dict)])
        elif isinstance(obj, list):
            nodes.extend([x for x in obj if isinstance(x, dict)])
        for node in nodes:
            t = node.get("@type")
            if isinstance(t, list):
                jsonld_types.extend(t)
            elif t:
                jsonld_types.append(t)
    return p, metas, jsonld_types


def sitemap_urls(sitemap_url, domain, max_sitemaps=20):
    found = []
    queue = deque([sitemap_url])
    seen = set()
    while queue and len(seen) < max_sitemaps:
        sm = queue.popleft()
        if sm in seen:
            continue
        seen.add(sm)
        r = fetch(sm)
        if r["status"] != 200:
            continue
        locs = re.findall(r"<loc>(.*?)</loc>", r["text"])
        for loc in locs:
            if loc.endswith(".xml"):
                queue.append(loc)
            elif domain in urllib.parse.urlparse(loc).netloc:
                found.append(loc)
    return list(dict.fromkeys(found))


def crawl(base, out_path, max_pages=80):
    parsed = urllib.parse.urlparse(base)
    domain = parsed.netloc.replace("www.", "")
    root = f"{parsed.scheme}://{parsed.netloc}/"
    endpoints = [
        f"http://{domain}/",
        f"https://{domain}/",
        f"https://www.{domain}/",
        f"https://{domain}/robots.txt",
        f"https://{domain}/sitemap.xml",
    ]
    endpoint_results = {u: fetch(u) for u in endpoints}
    sm_urls = sitemap_urls(f"https://{domain}/sitemap.xml", domain)
    q = deque([root] + sm_urls[:max_pages])
    seen = set()
    pages = []
    while q and len(pages) < max_pages:
        url = q.popleft()
        if url in seen:
            continue
        seen.add(url)
        r = fetch(url)
        ctype = r["headers"].get("Content-Type", "")
        if not (r["status"] and 200 <= r["status"] < 400 and "text/html" in ctype):
            continue
        p, metas, jsonld_types = parse_html(r["text"])
        links = []
        for a in p.anchors:
            href = a.get("href")
            if not href:
                continue
            u = urllib.parse.urljoin(r["final_url"] or url, href.split("#")[0])
            pr = urllib.parse.urlparse(u)
            if pr.scheme in ("http", "https"):
                links.append(u)
                if domain in pr.netloc and u not in seen and len(seen) + len(q) < max_pages * 2:
                    q.append(u)
        pages.append({
            "url": url,
            "final_url": r["final_url"],
            "status": r["status"],
            "time": r["time"],
            "bytes": r["bytes"],
            "title": p.title.strip(),
            "meta_description": metas.get("description", ""),
            "canonical": p.canonical,
            "lang": p.lang,
            "viewport": metas.get("viewport", ""),
            "h1": [x[1] for x in p.headings if x[0] == "h1"],
            "headings": p.headings[:20],
            "word_count": sum(len(x.split()) for x in p.text),
            "images": len(p.imgs),
            "images_missing_alt": sum(1 for im in p.imgs if not im.get("alt")),
            "links_internal": sum(1 for l in links if domain in urllib.parse.urlparse(l).netloc),
            "links_external": sum(1 for l in links if domain not in urllib.parse.urlparse(l).netloc),
            "jsonld_types": jsonld_types,
            "og_present": any(k.startswith("og:") for k in metas),
        })
    data = {
        "generated_at": time.strftime("%Y-%m-%d %H:%M:%S %Z"),
        "base": base,
        "domain": domain,
        "endpoints": endpoint_results,
        "sitemap_count": len(sm_urls),
        "sitemap_sample": sm_urls[:100],
        "pages": pages,
        "schema_type_counts": Counter(t for pg in pages for t in pg["jsonld_types"]),
    }
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"WROTE {out_path}")
    print(f"pages={len(pages)} sitemap_urls={len(sm_urls)}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__)
        raise SystemExit(2)
    crawl(sys.argv[1], sys.argv[2])
