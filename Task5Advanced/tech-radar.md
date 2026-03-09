# Задание 5. Проектирование технологического стека и расчёт стоимости

Сформируйте целевой технологический стек, составив расширенный технический радар, который должен включать не только технологии, но и архитектурные паттерны (например, Data Mesh, Event-Driven Architecture, Self-service BI). Для каждой технологии или паттерна укажите её текущий статус: Adopt, Trial, Assess или Hold.
---
## 1. Архитектурные паттерны и подходы

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Event-Driven Architecture (EDA)|	Adopt|	Основа целевой архитектуры: слабосвязанные домены, near-real-time обработка, масштабируемость.|
|Data Mesh|	Trial|	Децентрализация данных по доменам (Fintech, Medical, AI) с федеративным управлением. Пилот в 2–3 доменах.|
|Data Lakehouse|	Adopt|	Сочетание гибкости Data Lake и надёжности Data Warehouse (Iceberg, Parquet, S3). Два контура: Analytical и Medical.|
|Domain-Driven Design (DDD)|	Adopt|	Чёткие границы bounded context, агрегаты, доменные события. Используется при проектировании всех новых сервисов.|
|Self-service Data Portal |	Trial|	Портал для бизнес-пользователей (Dremio / аналоги) с доступом только к Analytical Lakehouse. Пилот.|
|CQRS (Command Query Responsibility Segregation)|	Assess|	Возможное разделение операционных и аналитических моделей в Fintech и Medical. Пока не критично.|
|Data Product|	Trial|	Каждый домен предоставляет данные как продукт: документированный, с гарантированным качеством и SLA.|
|Batch-oriented Data Warehouse (Legacy)|	Hold|	Текущий DWH на SQL Server 2008 — только как источник ETL. Не использовать для новых сценариев.|

2. Хранение данных (Lakehouse)

| Технология / Паттерн|	Статус |	Обоснование |
|--|---|---|
| MinIO (S3-совместимое хранилище) |	Adopt |	Лёгкое, масштабируемое, on-premise / облачное. Основа для обоих Lakehouse. |
|Apache Iceberg|	Adopt |	Табличный формат для Lakehouse: ACID, time travel, schema evolution.|
|Parquet|	Adopt|	Колоночный формат для эффективного хранения и аналитики.|
|Nessie|	Trial|	Git-like версионирование данных для Analytical Lakehouse. Упрощает управление изменениями.|
|SQL Server 2008 (Legacy DWH)|	Hold|	Историческая легаси-система. Выводится с критического пути.|

3. Интеграция и события

| Технология / Паттерн |	Статус |	Обоснование |
|--|---|---|
| Apache Kafka |	Adopt |	Центральная событийная шина. Партиционирование, масштабирование, exactly-once.|
| Schema Registry |	Adopt	| Управление версиями контрактов событий (Avro / JSON Schema). Обязательно для всех топиков.|
|Kafka Connect / Debezium	| Trial |	CDC из операционных БД (PostgreSQL, etc.) в Kafka. Использовать с осторожностью, предпочтительнее application-level события. |
|Apache Camel (Legacy)|	Hold	| Используется только как мост для передачи событий в Kafka на этапе миграции. Новые интеграции не строить. |


4. Обработка и оркестрация данных

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Apache Airflow|	Adopt|	Оркестрация ETL/ELT пайплайнов, загрузка из Kafka, построение витрин.|
|Apache Spark|	Adopt|	Тяжёлые преобразования, ML-джобы, работа с Iceberg. Отдельные инстансы для Analytical и Medical.|
|Apache Flink|	Assess|	Потоковая обработка для near-real-time витрин. Возможна замена Spark Structured Streaming в будущем. Возможна замена Airflow microbacch dags|

5. Self-service и потребление данных

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Dremio|	Trial|	Self-service SQL-движок для Analytical Lakehouse. Интеграция с Ranger и IAM.|
|Power BI (modern)|	Hold|	BI-инструмент компании. Подключается только к Analytical Lakehouse (не к Medical). Легаси решение.|
|Insight BI (russian analog)|	Trial|	BI-инструмент отечественного производства. Пилот. |
|DataHub|	Trial|	Каталог данных, витрина метаданных. Видит оба Lakehouse, но доступ к Medical — по правам.|
|Apache Superset|	Assess|		Лёгкая альтернатива для ad-hoc аналитики. Возможно в дополнение к Power BI.|	

6. Безопасность и управление доступом

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Apache Ranger|	Adopt|	Централизованное управление политиками доступа (row/column-level) для обоих Lakehouse.|
|Keycloak / IAM	| Adopt	|Аутентификация и SSO (портал, BI, DataHub). Интеграция с Ranger.|
|Vault (HashiCorp)|	Trial|	Хранение секретов для ETL, подключений к БД.|

7. Инфраструктура и развёртывание

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Kubernetes|	Adopt|	Оркестрация контейнеров для всех новых сервисов |
|Terraform|	Adopt|	Инфраструктура как код (IaC) для облака и on-prem.|
|GitLab CI / GitHub Actions|	Adopt|	CI/CD для пайплайнов данных и конфигураций.|
|Docker|	Adopt|	Контейнеризация приложений.|

8. Мониторинг и наблюдаемость

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Prometheus + Grafana|	Adopt|	Метрики Kafka, Airflow, Spark, инфраструктуры.|
|ELK / OpenSearch|	Trial|	Сбор и анализ логов, особенно для аудита событий.|
|OpenTelemetry	|Assess|	Трассировка запросов через события и пайплайны.|

9. Языки и фреймворки приложений

|Технология / Паттерн|	Статус|	Обоснование|
|--|---|---|
|Golang|	Adopt|	Финтех-сервисы (высоконагруженные, конкурентные).|
|Java	|Adopt|	Существующие финтех-сервисы, Kafka Streams, Flink.|
|Python	|Adopt|	ИИ-сервисы, Spark-джобы, прототипирование.
|PowerBuilder|	Hold|	Легаси-интерфейсы. Полный отказ в течение 2 лет.|

### Резюме по радару

| Тип|	Основные технологии (Adopt) |	В процессе (Trial / Assess)|
|--|---|---|
|Паттерны|	EDA, Lakehouse, DDD|	Data Mesh, Data Product|
|Хранение|	MinIO, Iceberg, Parquet|	Nessie|
|Интеграция|	Kafka, Schema Registry	|Debezium|
|Обработка|	Airflow, Spark	| Flink|
|Self-service|	Power BI|	Dremio, DataHub|
|Безопасность|	Ranger, Keycloak|	Vault|
|Инфраструктура|	Kubernetes, Terraform	|—|
|Наблюдаемость|	Prometheus/Grafana|	OpenSearch, OpenTelemetry|