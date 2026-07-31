---
project: Google SEO & GEO Criterions
category: SEO
group: Mobile / Performance / Page Experience
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# Consent Banner SEO Safety

## 1. Какво е
Consent Banner SEO Safety е SEO критерий/сигнал в областта practical SEO/GEO eligibility. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

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
Страницата покрива „Consent Banner SEO Safety“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Consent Banner SEO Safety“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Google SEO Criterions]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Page experience: https://developers.google.com/search/docs/appearance/page-experience
