---
project: Google SEO & GEO Criterions
category: GEO
group: Technical Accessibility & Rendering
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# Anchor Fragment and Deep Link Support

## 1. Какво е
Anchor Fragment and Deep Link Support е GEO критерий/сигнал в областта links / architecture / authority flow. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

## 2. Достоверност
- Тип: `official_confirmed`.
- Надеждност: използва се в audit като официално потвърден критерий/control.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Links трябва да са crawlable HTML anchors и да водят към релевантни страници.
- Anchor text трябва да е описателен, естествен и полезен.
- Internal architecture трябва да помага на Google да открие и разбере важните страници.
- Backlinks/outbound links не трябва да нарушават link spam policies.

## 4. Как да го приложим
- Добави логични вътрешни връзки от hubs към важни pages.
- Използвай описателни anchor texts без stuffing.
- Поправи broken links и orphan pages.
- Маркирай paid/UGC links с правилните rel атрибути.

## 5. Как да го проверим
- Crawl за internal links, orphan pages и broken links.
- Ръчен преглед на anchor text и link context.
- Backlink/link spam преглед при нужда.
- Проверка на breadcrumbs/navigation.

## 6. Какво отчита бъдещият skill при инспекция
- passed: изискванията са налични и няма противоречиви сигнали.
- partial: част от сигнала е налична, но има технически/съдържателен риск.
- missing: липсва ключово изискване или има блокиращ проблем.
- not_applicable: критерият не е приложим за този тип страница/сайт.

## 6A. Audit evidence
- HTTP status за URL-а и canonical URL-а.
- robots.txt, meta robots и X-Robots-Tag.
- rel=canonical, redirects, sitemap inclusion и internal links.
- Google Search Console URL Inspection / Pages report, ако има достъп.
- Rendered HTML за важен content и links при JavaScript страници.

## 6B. Pass condition
- URL-ът е crawlable, indexable и връща правилен статус.
- Canonical, sitemap и internal links сочат към една и съща предпочитана версия.
- Няма noindex/robots/server/rendering blocker за страници, които трябва да се индексират.

## 6C. Fail condition
- Има случайно noindex, robots block, 4xx/5xx, redirect loop или canonical conflict.
- Sitemap подава URL-и, които не са indexable/canonical/200.
- Основният content не се вижда от Googlebot/rendered HTML.

## 6D. Fix recommendation
- Премахни случайните блокиращи directives.
- Уеднакви canonical, redirects, sitemap и вътрешни връзки.
- Поправи status codes, server errors и rendering проблеми.
- След корекция провери URL Inspection и crawl резултатите.

## 7. Добър пример
Страницата покрива „Anchor Fragment and Deep Link Support“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Anchor Fragment and Deep Link Support“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[AI Link Preview Clarity]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
