---
project: Google SEO & GEO Criterions
category: GEO
group: GEO Myths / Unconfirmed Claims
created: 2026-07-31
status: professional-inspection-ready-v1
criterion_type: myth_or_unconfirmed
priority: low
---

# AI Chunking Requirement Myth

## 1. Какво е
„AI Chunking Requirement Myth“ е непотвърдено или подвеждащо SEO/GEO твърдение. Файлът съществува, за да пази бъдещия skill от грешни препоръки и излишна работа.

## 2. Достоверност
- Тип: `myth_or_unconfirmed`.
- Надеждност: не се използва като реален критерий; пази от погрешни препоръки.
- Важно: няма гаранция за 100% индексиране или AI цитиране; целта е максимално покриване на условията.

## 3. Изисквания
- Не го третирай като реален Google ranking/indexing критерий.
- Провери дали има официална Google документация; ако няма, маркирай като unconfirmed.
- Не препоръчвай промени само заради този мит.
- Ако има косвена полезна практика, вържи я към реален критерий, а не към мита.

## 4. Как да го приложим
- Не го оптимизирай като критерий.
- Използвай го само като предупреждение в audit report.
- Ако клиент/сайт настоява за него, обясни защо няма доказана стойност.

## 5. Как да го проверим
- Провери дали твърдението има официален Google source.
- Провери дали не противоречи на Google Search Central.
- Маркирай резултата като `do_not_optimize`.

## 6. Какво отчита бъдещият skill при инспекция
- do_not_optimize: твърдението е мит или непотвърдено.
- Ако сайтът го „няма“, това не е SEO/GEO проблем.
- Ако report го споменава, да бъде само в секция „не приоритизирай“.

## 6A. Audit evidence
- Провери дали твърдението има директна официална Google документация.
- Провери дали твърдението не е само индустриална статия, корелационно проучване или SEO слух.
- Провери дали Google не е заявил обратното в Search Central / AI optimization docs.

## 6B. Pass condition
- Критерият е маркиран като `myth_or_unconfirmed`.
- Не е включен като задължително действие в SEO/GEO roadmap.
- Report-ът го използва само като предупреждение, не като task.

## 6C. Fail condition
- Skill-ът препоръчва работа по този сигнал като реален ranking/indexing критерий.
- Сайтът инвестира време в промяна без официална или силна practical основа.

## 6D. Fix recommendation
- Не оптимизирай директно за този критерий.
- Ако има полезна част, премести действието към реален критерий: crawl, content quality, structured data, entity trust или page experience.
- В report-а го маркирай като `do_not_optimize`.

## 7. Добър пример
Audit report казва: „Това е мит/непотвърдено; не влагаме усилия тук.“

## 8. Лош пример
Да се правят промени по сайта само защото някой твърди, че този фактор гарантира класиране или AI цитиране.

## 9. Приоритет и риск
- Приоритет: `low`.
- Рискът е загуба на време и грешни препоръки, не липса на реален Google критерий.

## 10. Връзки
- [[llms.txt Helps Google Ranking Myth]]
- [[Schema Guarantees AI Citation Myth]]
- [[Prompt Injection in Page Content Myth]]

## 11. Източници
- Google AI optimization guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- AI features and your website: https://developers.google.com/search/docs/appearance/ai-features
- Helpful content: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
