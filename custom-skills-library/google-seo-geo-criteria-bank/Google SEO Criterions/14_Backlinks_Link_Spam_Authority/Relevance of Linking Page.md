---
project: Google SEO & GEO Criterions
category: SEO
group: Backlinks / Link Spam / Authority
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# Relevance of Linking Page

## 1. Какво е
Relevance of Linking Page е SEO критерий/сигнал в областта links / architecture / authority flow. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

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
Страницата покрива „Relevance of Linking Page“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Relevance of Linking Page“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[SameAs Entity Linking]]
- [[Product Page Unique Descriptions]]
- [[Page Experience and Core Web Vitals]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Spam policies: https://developers.google.com/search/docs/essentials/spam-policies
