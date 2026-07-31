---
project: Google SEO & GEO Criterions
category: GEO
group: Multimodal AI Visibility
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# Audio Transcript Availability

## 1. Какво е
Audio Transcript Availability е GEO критерий/сигнал в областта mobile/page experience/performance. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

## 2. Достоверност
- Тип: `strong_practical_signal`.
- Надеждност: използва се в audit като практически SEO/GEO сигнал.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Страницата трябва да е usable на mobile и да показва същото основно съдържание.
- Core Web Vitals трябва да са в good или поне да няма очевиден blocker.
- Layout не трябва да се измества и interaction не трябва да е тежък.
- Ads/popups/consent не трябва да блокират основното съдържание.

## 4. Как да го приложим
- Оптимизирай LCP element, изображения, fonts и critical resources.
- Намали heavy JS и third-party scripts.
- Резервирай размери за images/ads/embeds.
- Провери mobile UX и tap targets.

## 5. Как да го проверим
- PageSpeed Insights / CrUX.
- GSC Core Web Vitals.
- Lighthouse diagnostics.
- Ръчен mobile test.

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
Страницата покрива „Audio Transcript Availability“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Audio Transcript Availability“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Speakable and Audio Considerations]]
- [[Snippet Text Availability]]
- [[Product Availability for AI Commerce]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
