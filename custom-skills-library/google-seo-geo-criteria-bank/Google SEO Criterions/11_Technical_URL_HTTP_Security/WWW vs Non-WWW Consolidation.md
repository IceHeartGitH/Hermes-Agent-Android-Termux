---
project: Google SEO & GEO Criterions
category: SEO
group: Technical URL / HTTP / Security
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# WWW vs Non-WWW Consolidation

## 1. Какво е
WWW vs Non-WWW Consolidation е SEO критерий/сигнал в областта practical SEO/GEO eligibility. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

## 2. Достоверност
- Тип: `official_confirmed`.
- Надеждност: използва се в audit като официално потвърден критерий/control.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Критерият трябва да има реална връзка с crawl, indexability, quality, UX, entity clarity или search appearance.
- Да не противоречи на официални Google документи.
- Да може да бъде проверен при сайт инспекция.
- Да има ясно действие за корекция, ако липсва.

## 4. Как да го приложим
- Определи дали критерият е приложим за конкретния site/page type.
- Провери текущото състояние с crawl, GSC, HTML или manual review.
- Направи минималната корекция, която решава реалния проблем.
- Не оптимизирай, ако е myth или not applicable.

## 5. Как да го проверим
- Manual audit.
- GSC/HTML/crawl проверка според критерия.
- Сравнение с Google документация.
- Проверка след промяна.

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
Страницата покрива „WWW vs Non-WWW Consolidation“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „WWW vs Non-WWW Consolidation“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Content Pruning and Consolidation]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
