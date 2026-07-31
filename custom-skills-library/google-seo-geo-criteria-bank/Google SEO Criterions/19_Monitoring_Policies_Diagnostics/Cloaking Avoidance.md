---
project: Google SEO & GEO Criterions
category: SEO
group: Monitoring / Policies / Diagnostics
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# Cloaking Avoidance

## 1. Какво е
Cloaking Avoidance е SEO критерий/сигнал в областта practical SEO/GEO eligibility. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

## 2. Достоверност
- Тип: `strong_practical_signal`.
- Надеждност: използва се в audit като практически SEO/GEO сигнал.
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
- Ръчен review за spam policies: scaled content, cloaking, doorway, keyword stuffing, parasite/reputation abuse.
- Сравнение visible content vs crawler content.
- Outbound/inbound link quality и anchor patterns.
- GSC Manual actions / Security issues, ако има достъп.

## 6B. Pass condition
- Няма нарушения на Google spam policies.
- Съдържанието е полезно, оригинално и не е създадено само за манипулиране на rankings.
- Links, redirects и structured data не подвеждат.

## 6C. Fail condition
- Има doorway/thin/scaled/keyword-stuffed или copied content.
- Има cloaking, sneaky redirects, link spam или reputation abuse.
- Manual action/security issue е наличен или вероятен.

## 6D. Fix recommendation
- Премахни или пренапиши low-value/spam content.
- Почисти link spam и подвеждащи redirects/schema.
- Документирай редакторски процес и реална стойност за потребителя.
- След remediation подай reconsideration само ако има manual action.

## 7. Добър пример
Страницата покрива „Cloaking Avoidance“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Cloaking Avoidance“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Soft 404 Avoidance]]
- [[Manufacturer Duplicate Content Avoidance]]
- [[Link Schemes Avoidance]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
