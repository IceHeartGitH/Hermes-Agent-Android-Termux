---
project: Google SEO & GEO Criterions
category: GEO
group: Platform-Specific AI Surfaces
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# AI Link Preview Clarity

## 1. Какво е
AI Link Preview Clarity е GEO критерий/сигнал в областта links / architecture / authority flow. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

## 2. Достоверност
- Тип: `strong_practical_signal`.
- Надеждност: използва се в audit като практически SEO/GEO сигнал.
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
- Crawl graph: internal links, depth, orphan pages.
- Anchor text и surrounding context.
- Breadcrumbs/navigation/hub pages.
- Broken links и redirect chains.
- Backlink/outbound link review при authority/spam критерии.

## 6B. Pass condition
- Важните страници са reachable чрез crawlable HTML links.
- Anchor text е описателен и естествен.
- Architecture показва ясни topic hubs и приоритет на страниците.

## 6C. Fail condition
- Има orphan pages, JS-only links, broken links или прекалена click depth.
- Anchor text е generic, spammy или подвеждащ.
- Paid/UGC/spam links не са правилно маркирани.

## 6D. Fix recommendation
- Добави вътрешни връзки от релевантни hub/category/content pages.
- Пренапиши anchors да описват реалната целева страница.
- Поправи broken links и redirect chains.
- Използвай rel=sponsored/ugc/nofollow при нужда.

## 7. Добър пример
Страницата покрива „AI Link Preview Clarity“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „AI Link Preview Clarity“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Self-Contained Passage Clarity]]
- [[Robots.txt Does Not Remove Indexed Preview]]
- [[Preview Control Trade-Offs]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
