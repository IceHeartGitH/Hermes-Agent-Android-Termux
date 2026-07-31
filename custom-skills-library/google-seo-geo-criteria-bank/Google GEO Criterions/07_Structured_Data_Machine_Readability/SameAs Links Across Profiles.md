---
project: Google SEO & GEO Criterions
category: GEO
group: Structured Data & Machine Readability
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: medium
---

# SameAs Links Across Profiles

## 1. Какво е
SameAs Links Across Profiles е GEO критерий/сигнал в областта links / architecture / authority flow. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

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
- JSON-LD / microdata markup в HTML.
- Rich Results Test output.
- Schema.org validator като допълнителна проверка.
- GSC Enhancements report, ако е наличен.
- Сравнение между markup и видимото съдържание на страницата.

## 6B. Pass condition
- Schema типът е релевантен и Google-supported за page type.
- Required properties са валидни.
- Markup описва видимо, вярно и актуално съдържание.

## 6C. Fail condition
- Липсват required properties или JSON-LD е невалиден.
- Markup съдържа невидими, fake или несъвпадащи данни.
- Използва се неподходящ/deprecated schema тип като SEO shortcut.

## 6D. Fix recommendation
- Избери правилния Google-supported schema type.
- Попълни required/recommended properties с реални видими данни.
- Премахни fake ratings, невидими FAQ и подвеждащ markup.
- Тествай повторно с Rich Results Test.

## 7. Добър пример
Страницата покрива „SameAs Links Across Profiles“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „SameAs Links Across Profiles“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Topical Authority Across Site]]
- [[SameAs Profile Consistency]]
- [[Crawlable Internal Links for AI Discovery]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Structured data gallery: https://developers.google.com/search/docs/appearance/structured-data/search-gallery
