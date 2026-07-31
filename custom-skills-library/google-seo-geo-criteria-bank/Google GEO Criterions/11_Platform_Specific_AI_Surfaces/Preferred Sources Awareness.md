---
project: Google SEO & GEO Criterions
category: GEO
group: Platform-Specific AI Surfaces
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: strong_practical_signal
priority: medium
---

# Preferred Sources Awareness

## 1. Какво е
Preferred Sources Awareness е GEO критерий/сигнал в областта content quality / intent / trust. Той помага бъдещият skill да оцени дали сайтът е разбираем, достъпен, надежден и цитируем за Google AI Search и други AI answer surfaces.

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
- Crawl/index status на URL-а в Google.
- Наличие на direct answer blocks, question headings, definitions, tables и cited facts.
- Entity/brand/author clarity: About, sameAs, profiles, citations.
- AI feature controls: nosnippet, max-snippet, data-nosnippet, noindex.
- robots.txt политика за Googlebot и релевантни AI crawlers.
- Prompt/query set test за AI citation visibility, когато е възможно.

## 6B. Pass condition
- Съдържанието е crawlable/indexable и ясно извличаемо.
- Има самостоятелни отговори с факти, източници и entity clarity.
- Preview/index controls не ограничават нежелано AI appearance.

## 6C. Fail condition
- Основните отговори са скрити, неясни, без източници или само marketing copy.
- Entity/author/brand trust е слаб или несъгласуван.
- AI/Search controls случайно блокират snippets, indexing или crawling.

## 6D. Fix recommendation
- Добави кратки answer blocks, definitions, Q&A headings, tables и cited claims.
- Укрепи author/organization/entity signals и sameAs връзки.
- Провери nosnippet/max-snippet/data-nosnippet/noindex ефектите.
- Настрой crawler policy съзнателно според AI visibility стратегията.

## 7. Добър пример
Страницата покрива „Preferred Sources Awareness“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Preferred Sources Awareness“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `medium`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Search Console AI Feature Reporting Awareness]]
- [[Highly Cited Badge Awareness]]
- [[Google-Extended Training Opt-Out Awareness]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
