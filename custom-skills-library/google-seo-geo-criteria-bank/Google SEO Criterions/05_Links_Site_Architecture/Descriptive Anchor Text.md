---
project: Google SEO & GEO Criterions
category: SEO
group: Links & Site Architecture
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_or_strong_practical_signal
priority: medium
---

# Descriptive Anchor Text

## 1. Какво е
Descriptive Anchor Text е SEO критерий/сигнал в областта links / architecture / authority flow. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

## 2. Достоверност
- Тип: `official_or_strong_practical_signal`.
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
- PageSpeed Insights и CrUX field data.
- GSC Core Web Vitals report.
- Lighthouse diagnostics за mobile.
- Real-device mobile проверка за layout, popups и usability.

## 6B. Pass condition
- LCP, INP и CLS са Good или няма сериозен blocker за ключови шаблони.
- Mobile страницата е четима, стабилна и interactive.
- Няма intrusive interstitials или layout shifts, които пречат на content.

## 6C. Fail condition
- Poor LCP/INP/CLS за важни URL templates.
- Popup/ad/script блокира основното съдържание или interaction.
- Mobile версията скрива/променя основен content.

## 6D. Fix recommendation
- Оптимизирай LCP element, images, fonts и server response.
- Намали heavy JavaScript и third-party scripts.
- Резервирай размери за images/ads/embeds.
- Премахни или омекоти intrusive interstitials.

## 7. Добър пример
Страницата покрива „Descriptive Anchor Text“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Descriptive Anchor Text“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Anchor Text Naturalness]]
- [[Snippet Source Text Quality]]
- [[Image SEO and Alt Text]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
