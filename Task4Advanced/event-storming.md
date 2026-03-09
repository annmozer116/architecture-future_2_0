# Event Storming — «Будущее 2.0»

Событийная диаграмма: основные доменные события, их источники и подписчики.

## Диаграмма

См. `event-storming.puml` — Event Storming в формате PlantUML.

## Сводная таблица: события, источники, подписчики

| Событие | Контекст-источник | Подписчики | Описание |
|---------|-------------------|------------|----------|
| **Создан кредитный договор** (CreditContractCreated) | Fintech / Credit Management | Analytics, Analytical Lakehouse | Кредит одобрен и оформлен |
| **Открыт счёт** (AccountOpened) | Fintech / Account Management | Analytics, Analytical Lakehouse | Новый счёт открыт |
| **Выполнен платёж** (PaymentCompleted) | Fintech / Payment Processing | Analytics, Analytical Lakehouse | Платёж проведён |
| **Кредит погашен** (CreditRepaid) | Fintech / Credit Management | Analytics, Analytical Lakehouse | Кредит полностью или частично погашен |
| **Зарегистрирован новый пациент** (PatientRegistered) | Medical / Patient Registry | Analytics, Analytical Lakehouse (агрегаты) | Пациент зарегистрирован в системе |
| **Создан приём** (AppointmentCreated) | Medical / Clinical Operations | Analytics, AI (Clinical AI) | Запланирован приём |
| **Проведена процедура** (ProcedureCompleted) | Medical / Clinical Operations | Analytics, AI (Clinical AI), Analytical Lakehouse | Процедура/исследование выполнено |
| **Выписано назначение** (PrescriptionIssued) | Medical / Clinical Operations | Analytics | Назначено лечение/препараты |
| **Изменён остаток инвентаря** (InventoryUpdated) | Medical / Inventory Management | Analytics, Analytical Lakehouse | Движение по складу |
| **Пройдено исследование ИИ** (AIResearchCompleted) | AI / Research & Diagnostics | Analytics, Analytical Lakehouse | ИИ-модель завершила исследование |
| **Получен результат диагностики ИИ** (AIDiagnosticResultReceived) | AI / Clinical AI | Analytics, Medical (Clinical Operations) | Результат ИИ передан в клинику |
| **Запущена модель ИИ** (AIModelInvoked) | AI / Clinical AI | Analytics (метрики монетизации) | Вызов ИИ-сервиса |

## Потоки событий (упрощённо)

```
Fintech (Account, Credit, Payment)
    → Kafka topics: fintech.accounts, fintech.credits, fintech.payments
    → Подписчики: Analytical Lakehouse

Medical (Patient, Appointment, Procedure, Inventory)
    → Kafka topics: medical.patients, medical.appointments, medical.procedures, medical.inventory
    → Подписчики: Analytical Lakehouse (агрегаты без PHI), AI (запросы на анализ)

AI (Research, Diagnostic)
    → Kafka topics: ai.research, ai.diagnostics, ai.metrics
    → Подписчики: Analytical Lakehouse, Medical (результаты), BI (метрики)
```

## Ограничение: PHI не в аналитику

События из Medical, содержащие PHI (мед. карты, результаты исследований), **не публикуются** в топики, потребляемые Analytical Lakehouse и BI. В аналитику попадают только агрегированные/обезличенные события (пациентский поток, объёмы процедур, метрики ИИ).
