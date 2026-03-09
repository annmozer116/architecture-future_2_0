# Каталог доменных событий — «Будущее 2.0»

События, публикуемые доменами; контекст-источник, семантика, минимальный контракт.

---

## Fintech Domain

### CreditContractCreated (Создан кредитный договор)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Fintech / Credit Management |
| **Семантика** | Кредитный договор одобрен и оформлен; клиент и банк достигли соглашения |
| **Минимальный контракт** | `creditContractId`, `clientId`, `amount`, `currency`, `interestRate`, `termMonths`, `createdAt` |
| **Подписчики** | Analytics, Analytical Lakehouse |

### AccountOpened (Открыт счёт)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Fintech / Account Management |
| **Семантика** | Новый счёт открыт для клиента |
| **Минимальный контракт** | `accountId`, `clientId`, `accountType`, `currency`, `openedAt` |
| **Подписчики** | Analytics, Analytical Lakehouse |

### PaymentCompleted (Выполнен платёж)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Fintech / Payment Processing |
| **Семантика** | Платёж успешно проведён |
| **Минимальный контракт** | `paymentId`, `accountId`, `amount`, `currency`, `counterpartyId`, `completedAt` |
| **Подписчики** | Analytics, Analytical Lakehouse |

### CreditRepaid (Кредит погашен)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Fintech / Credit Management |
| **Семантика** | Частичное или полное погашение кредита |
| **Минимальный контракт** | `creditContractId`, `repaidAmount`, `remainingBalance`, `repaidAt` |
| **Подписчики** | Analytics, Analytical Lakehouse |

---

## Medical Domain

### PatientRegistered (Зарегистрирован новый пациент)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Medical / Patient Registry |
| **Семантика** | Пациент зарегистрирован в системе (без PHI в аналитику) |
| **Минимальный контракт** | `patientId`, `clinicId`, `registeredAt`; агрегаты для отчётности — без персональных и мед. данных |
| **Подписчики** | Analytics (агрегаты), Analytical Lakehouse |

### AppointmentCreated (Создан приём)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Medical / Clinical Operations |
| **Семантика** | Запланирован приём пациента |
| **Минимальный контракт** | `appointmentId`, `patientId`, `doctorId`, `clinicId`, `scheduledAt` |
| **Подписчики** | Analytics, AI (Clinical AI) |

### ProcedureCompleted (Проведена процедура)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Medical / Clinical Operations |
| **Семантика** | Процедура или исследование выполнено |
| **Минимальный контракт** | `procedureId`, `appointmentId`, `procedureType`, `completedAt`; без сырых результатов (PHI) в аналитику |
| **Подписчики** | Analytics, AI (запрос анализа), Analytical Lakehouse |

### PrescriptionIssued (Выписано назначение)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Medical / Clinical Operations |
| **Семантика** | Врач выписал назначение (препараты, процедуры) |
| **Минимальный контракт** | `prescriptionId`, `patientId`, `doctorId`, `issuedAt` |
| **Подписчики** | Analytics |

### InventoryUpdated (Изменён остаток инвентаря)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | Medical / Inventory Management |
| **Семантика** | Зафиксировано движение по складу (приход/расход) |
| **Минимальный контракт** | `inventoryItemId`, `warehouseId`, `quantityDelta`, `updatedAt` |
| **Подписчики** | Analytics, Analytical Lakehouse |

---

## AI / Clinical Decision Domain

### AIResearchCompleted (Пройдено исследование ИИ)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | AI / Research & Diagnostics |
| **Семантика** | ИИ-модель завершила исследование; результат доступен (в Medical — с доступом; в Analytics — только метрики) |
| **Минимальный контракт** | `requestId`, `modelId`, `modelVersion`, `status`, `completedAt`; метрики для аналитики (без PHI) |
| **Подписчики** | Analytics, Analytical Lakehouse, Medical (Clinical Operations) |

### AIDiagnosticResultReceived (Получен результат диагностики ИИ)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | AI / Clinical AI |
| **Семантика** | Результат ИИ передан в клиническую систему для использования врачом |
| **Минимальный контракт** | `requestId`, `procedureId`, `resultSummary`, `receivedAt` |
| **Подписчики** | Medical (Clinical Operations), Analytics (метрики) |

### AIModelInvoked (Запущена модель ИИ)

| Поле | Описание |
|------|----------|
| **Контекст-источник** | AI / Clinical AI |
| **Семантика** | Вызов ИИ-сервиса (для метрик монетизации и нагрузки) |
| **Минимальный контракт** | `requestId`, `modelId`, `invokedAt` |
| **Подписчики** | Analytics (метрики использования) |

---

## Соглашения по контрактам

- **Версионирование**: все события содержат `eventVersion` (например, `v1`).
- **Корреляция**: `correlationId` для трассировки цепочки запросов.
- **Идемпотентность**: `idempotencyKey` для платежей и критичных операций.
- **PHI**: события, содержащие персональные и медицинские данные, не публикуются в топики, потребляемые Analytical Lakehouse и BI.
