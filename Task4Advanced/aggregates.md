# Агрегаты — «Будущее 2.0» (DDD)

Описание ключевых агрегатов: границы, инварианты, идентификаторы.

---

## Fintech Domain

### Account (Счёт)

| Атрибут | Описание |
|--------|----------|
| **Граница** | Account + список Transaction (последние N транзакций или по периоду) |
| **Корень** | Account |
| **Ключ** | `accountId` (UUID) |
| **Инварианты** | Остаток ≥ 0 (для дебетовых); счёт не закрыт при наличии активных обязательств; валюта неизменна |
| **События** | AccountOpened, PaymentCompleted, AccountClosed |

### CreditContract (Кредитный договор)

| Атрибут | Описание |
|--------|----------|
| **Граница** | CreditContract + ScheduleItem (график платежей) |
| **Корень** | CreditContract |
| **Ключ** | `creditContractId` (UUID) |
| **Инварианты** | Сумма погашения ≤ суммы договора; статус: draft → active → closed; даты платежей упорядочены |
| **События** | CreditContractCreated, CreditRepaid, CreditContractClosed |

### Payment (Платёж)

| Атрибут | Описание |
|--------|----------|
| **Граница** | Payment (агрегат-операция) |
| **Корень** | Payment |
| **Ключ** | `paymentId` (UUID) |
| **Инварианты** | Сумма > 0; статус: pending → completed | failed; идемпотентность по idempotencyKey |
| **События** | PaymentInitiated, PaymentCompleted, PaymentFailed |

---

## Medical Domain

### Patient (Пациент)

| Атрибут | Описание |
|--------|----------|
| **Граница** | Patient + PatientCard (демография, контакты; без мед. карты и результатов исследований в аналитическом контексте) |
| **Корень** | Patient |
| **Ключ** | `patientId` (UUID) |
| **Инварианты** | Уникальность по внешнему идентификатору (СНИЛС/др.); дата рождения в прошлом; обязательные поля заполнены |
| **События** | PatientRegistered, PatientUpdated |

### Appointment (Приём)

| Атрибут | Описание |
|--------|----------|
| **Граница** | Appointment |
| **Корень** | Appointment |
| **Ключ** | `appointmentId` (UUID) |
| **Инварианты** | Время приёма в будущем при создании; пациент и врач существуют; нет пересечений по врачу в один слот |
| **События** | AppointmentCreated, AppointmentCompleted, AppointmentCancelled |

### Procedure (Процедура / исследование)

| Атрибут | Описание |
|--------|----------|
| **Граница** | Procedure (без сырых результатов — они в отдельном контексте Clinical AI) |
| **Корень** | Procedure |
| **Ключ** | `procedureId` (UUID) |
| **Инварианты** | Связана с приёмом и пациентом; статус: scheduled → in_progress → completed | cancelled |
| **События** | ProcedureScheduled, ProcedureCompleted, ProcedureCancelled |

### InventoryItem (Позиция инвентаря)

| Атрибут | Описание |
|--------|----------|
| **Граница** | InventoryItem + StockMovement (последние движения) |
| **Корень** | InventoryItem |
| **Ключ** | `inventoryItemId` + `warehouseId` (составной) |
| **Инварианты** | Остаток ≥ 0; единица измерения неизменна |
| **События** | InventoryUpdated, StockMovementRecorded |

---

## AI / Clinical Decision Domain

### AIRequest (Запрос к ИИ)

| Атрибут | Описание |
|--------|----------|
| **Граница** | AIRequest + AIResult |
| **Корень** | AIRequest |
| **Ключ** | `requestId` (UUID) |
| **Инварианты** | Один результат на запрос; модель и версия зафиксированы |
| **События** | AIRequestSubmitted, AIResearchCompleted, AIDiagnosticResultReceived |

### ResearchRun (Запуск исследования)

| Атрибут | Описание |
|--------|----------|
| **Граница** | ResearchRun |
| **Корень** | ResearchRun |
| **Ключ** | `runId` (UUID) |
| **Инварианты** | Модель и входные данные зафиксированы; статус: running → completed | failed |
| **События** | AIModelInvoked, AIResearchCompleted |

---

## Взаимодействие агрегатов через события

- **CreditContract** публикует `CreditContractCreated` → подписчики (Analytics, Lakehouse) строят read-модели.
- **Procedure** публикует `ProcedureCompleted` → **AIRequest** (подписчик) инициирует анализ; **AIRequest** публикует `AIResearchCompleted` → Medical и Analytics.
- **Patient** публикует `PatientRegistered` → Analytics получает агрегаты для отчётности (без PHI).
