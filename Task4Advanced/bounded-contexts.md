# Bounded Contexts — «Будущее 2.0» (DDD)


## Диаграмма

См. `bounded-contexts.puml` — контекстная карта в формате PlantUML. 

## Домены и Bounded Contexts

### 1. Fintech Domain

| Bounded Context | Ответственность | Ключевые сущности |
|-----------------|-----------------|-------------------|
| **Account Management** | Открытие и ведение счетов, остатки, блокировки | Account, Transaction |
| **Credit Management** | Кредитные договоры, выдача, погашение, скоринг | CreditContract, CreditApplication |
| **Payment Processing** | Платежи, переводы, списания, зачисления | Payment, Transfer |

### 2. Medical Domain

| Bounded Context | Ответственность | Ключевые сущности |
|-----------------|-----------------|-------------------|
| **Patient Registry** | Регистрация пациентов, демография, привязка к клиникам | Patient, PatientCard |
| **Clinical Operations** | Приёмы, процедуры, назначения, расписание | Appointment, Procedure, Prescription |
| **Inventory Management** | Медицинский инвентарь, расходники, учёт | InventoryItem, StockMovement |
| **Personnel Management** | Персонал клиник, роли, расписание | Employee, Role, Schedule |

### 3. AI / Clinical Decision Domain

| Bounded Context | Ответственность | Ключевые сущности |
|-----------------|-----------------|-------------------|
| **Clinical AI** | Анализ данных, рекомендации, поддержка диагнозов | AIRequest, AIResult |
| **Research & Diagnostics** | Исследования, результаты диагностики, метрики моделей | ResearchRun, DiagnosticResult |

### 4. Analytics Domain

| Bounded Context | Ответственность | Ключевые сущности |
|-----------------|-----------------|-------------------|
| **Reporting & BI** | Отчётность, дашборды, витрины данных | Report, Dashboard, DataProduct |

*Analytics — подписчик событий; не публикует доменные события.*

### 5. Partner Integration Domain

| Bounded Context | Ответственность | Ключевые сущности |
|-----------------|-----------------|-------------------|
| **External Data Ingestion** | Приём данных от лабораторий, приборов, фармы | IngestBatch, ExternalSource |

## Связи между контекстами

- **Fintech → Analytics**: события по счетам, кредитам, платежам (агрегаты для отчётности).
- **Medical → Analytics**: агрегированные события (пациентский поток, инвентарь, персонал) — без PHI.
- **Medical → AI**: запросы на анализ; AI возвращает результаты в Clinical Operations.
- **AI → Analytics**: метрики использования ИИ, монетизация.
- **External → Medical**: сырые данные от приборов/лабораторий в Patient Registry и Clinical Operations.

## Термины

- **Patient** — пациент (не «клиент» в медицинском контексте).
- **CreditContract** — кредитный договор.
- **Appointment** — приём/визит.
- **Procedure** — процедура/исследование.
- **AIResult** — результат работы ИИ-модели.
