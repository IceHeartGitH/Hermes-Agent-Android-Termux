---
project: Google SEO & GEO Criterions
category: SEO
group: Ecommerce / Product SEO
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: official_confirmed
priority: high
---

# Price and Availability Accuracy

## 1. Какво е
Price and Availability Accuracy е SEO критерий/сигнал в областта content quality / intent / trust. Той показва какво трябва да е налично или правилно настроено, за да се увеличат максимално условията за crawl, indexability, ranking eligibility и/или GEO цитируемост.

## 2. Достоверност
- Тип: `official_confirmed`.
- Надеждност: използва се в audit като официално потвърден критерий/control.
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
Страницата покрива „Price and Availability Accuracy“ с ясно видим, технически достъпен и проверим сигнал, който съответства на intent и Google насоки.

## 8. Лош пример
Страницата разчита на „Price and Availability Accuracy“ само формално или го нарушава: сигналът липсва, противоречи на други SEO/GEO сигнали или не може да бъде проверен.

## 9. Приоритет и риск
- Приоритет: `high`.
- Риск при неспазване: по-слаби условия за crawl, indexability, ranking eligibility, search appearance или GEO цитируемост според критерия.

## 10. Връзки
- [[Sale Price and Discount Clarity]]
- [[Product Identifier Accuracy]]
- [[Primary GBP Category Accuracy]]

## 11. Източници
- Google Search Essentials: https://developers.google.com/search/docs/essentials
- SEO Starter Guide: https://developers.google.com/search/docs/fundamentals/seo-starter-guide
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Google Search ecommerce: https://developers.google.com/search/docs/specialty/ecommerce
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
