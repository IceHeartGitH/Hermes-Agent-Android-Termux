---
project: Google SEO & GEO Criterions
category: SEO
group: Monitoring / Policies / Diagnostics
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# Index Bloat Control

## 1. Какво е
Index Bloat Control е SEO критерий/сигнал в областта technical crawl/indexability. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

## 2. Достоверност
- Тип: `strong_practical_signal`.
- Надеждност: използва се в audit като практически SEO/GEO сигнал.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Важният URL трябва да е crawlable, indexable и технически стабилен.
- HTTP статусът, canonical, robots directives и sitemap сигналите не трябва да си противоречат.
- Основното съдържание и важните links трябва да са достъпни за Googlebot/mobile rendering.
- Не трябва да има блокиращи 4xx/5xx, redirect loops, случайно noindex или robots блокиране.

## 4. Как да го приложим
- Уеднакви canonical URL, internal links и sitemap.
- Премахни случайни блокировки от robots.txt/meta robots/X-Robots-Tag.
- Коригирай status codes, redirects и server errors.
- Провери rendered HTML за JS-dependent съдържание.

## 5. Как да го проверим
- Google Search Console URL Inspection.
- Crawl/status code проверка с crawler или curl.
- Проверка на robots.txt, meta robots, canonical и sitemap.
- Сравнение initial HTML срещу rendered HTML при JS сайтове.

## 6. Какво отчита бъдещият skill при инспекция
- passed: изискванията са налични и няма противоречиви сигнали.
- partial: част от сигнала е налична, но има технически/съдържателен риск.
- missing: липсва ключово изискване или има блокиращ проблем.
- not_applicable: критерият не е приложим за този тип страница/сайт.

## 6A. Audit evidence
- SERP intent и page purpose.
- Основен content, headings, title, meta, author/date/source signals.
- Оригинална стойност: опит, данни, примери, снимки, сравнения.
- Content duplication/thinness и topical coverage.
- GSC queries/pages performance като подкрепяща информация.

## 6B. Pass condition
- Страницата отговаря директно и полезно на intent.
- Има достатъчно оригинална стойност, точност и trust signals.
- Съдържанието е ясно структурирано и не е generic/AI-slop.

## 6C. Fail condition
- Страницата е thin, generic, copy-paste или не отговаря на intent.
- Липсват author/source/date/trust signals за темата.
- Има keyword stuffing, празни секции или подвеждащи заглавия.

## 6D. Fix recommendation
- Пренапиши според реалния user intent.
- Добави конкретни факти, източници, примери, опит и ясни отговори.
- Премахни filler, duplications и keyword stuffing.
- Добави author/editorial/update signals според риска на темата.

## 7. Добър пример
Страницата покрива „Index Bloat Control“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Index Bloat Control“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Faceted Navigation Index Control]]
- [[UGC and Comment Links Control]]
- [[Third-Party Script Control]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
