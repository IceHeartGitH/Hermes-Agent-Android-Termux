---
project: Google SEO & GEO Criterions
category: GEO
group: GEO Monitoring & Measurement
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# GSC Performance Still Primary Source

## 1. Какво е
GSC Performance Still Primary Source е GEO критерий/сигнал в областта content quality / intent / trust. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

## 2. Достоверност
- Тип: `strong_practical_signal`.
- Надеждност: използва се в audit като практически SEO/GEO сигнал.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Страницата трябва ясно да отговаря на реалното намерение на търсенето.
- Съдържанието трябва да има оригинална стойност, точност и полезност.
- Трябва да има достатъчен trust: автор, източници, дата, опит или доказателства според темата.
- Да няма thin, duplicate, misleading, keyword stuffing или AI-slop съдържание.

## 4. Как да го приложим
- Пренапиши страницата около задачата на потребителя, не само около keyword.
- Добави конкретни факти, примери, сравнения, източници и авторска яснота.
- Премахни повторения, празни параграфи и подвеждащи заглавия.
- Актуализирай остарели claims и добави дата на последна проверка.

## 5. Как да го проверим
- Manual content review по intent и helpful content.
- Сравнение срещу top SERP competitor pages.
- Проверка за duplicated/thin/AI-generic sections.
- Проверка на author/about/source/date signals.

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
Страницата покрива „GSC Performance Still Primary Source“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „GSC Performance Still Primary Source“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Primary Source References]]
- [[Primary Source Citations]]
- [[Source-Backed Claims]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Page experience: https://developers.google.com/search/docs/appearance/page-experience
