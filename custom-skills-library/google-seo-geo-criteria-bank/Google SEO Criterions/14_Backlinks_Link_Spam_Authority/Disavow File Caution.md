---
project: Google SEO & GEO Criterions
category: SEO
group: Backlinks / Link Spam / Authority
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# Disavow File Caution

## 1. Какво е
Disavow File Caution е SEO критерий/сигнал в областта practical SEO/GEO eligibility. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

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
Страницата покрива „Disavow File Caution“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Disavow File Caution“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Log File Crawl Diagnostics]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Spam policies: https://developers.google.com/search/docs/essentials/spam-policies
