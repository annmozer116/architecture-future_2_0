# Task2Advanced — Terraform с S3-совместимым backend

Конфигурация повторяет Task1Advanced (модуль `vm`, окружения dev/stage/prod), но **state хранится в S3-совместимом бэкенде** c Yandex Object Storage
Пример реализован для dev окружения

## Структура

```
Task2Advanced/envs/dev/backend.tf   # Конфигурация S3 backend
Task2Advanced/envs/dev/main.tf      # Описание инфраструктуры (вызов модуля VM)
Task2Advanced/envs/dev/outputs.tf   # Выводы
Task2Advanced/envs/dev/variables.tf # Переменные
Task2Advanced/envs/dev/dev.tfvars   # Значения переменных (не секретных)
Task2Advanced/modules/vm # Модуль VM (копия из Task1Advanced)
```

## 1. Подготовка инфраструктуры

1. Cоздать бакет в Yandex Object Storage
```
# Через консоль Yandex Cloud:
# 1. Перейдите в Object Storage
# 2. Создайте бакет с именем (например, "infra-terraform-state")
# 3. Выберите тип доступа "Приватный"
```
Название бакета должно быть указано в файле backend.tf, например infra-terraform-state

2. Создайте сервисный аккаунт с правами на запись и статические ключи

```
# Создайте сервисный аккаунт
yc iam service-account create --name terraform-sa

# Назначьте права на бакет
yc storage bucket update infra-terraform-state \
  --acl grant-uri=serviceAccount:terraform-sa,permission=READ_WRITE

# Создайте статические ключи доступа (Access Key и Secret Key)
yc iam access-key create --service-account-name terraform-sa
```

Сохраните вывод команды: key_id (это Access Key) и secret (это Secret Key).

## Переменные окружения для локального запуска

```
# Для backend (Yandex Object Storage)
export AWS_ACCESS_KEY_ID="ваш_access_key"
export AWS_SECRET_ACCESS_KEY="ваш_secret_key"

# Для провайдера Yandex Cloud
export YC_TOKEN="ваш_oauth_токен"
export YC_CLOUD_ID="ваш_cloud_id"
export YC_FOLDER_ID="ваш_folder_id"
```

### Локальный запуск (dev окружение)

```bash
cd Task2Advanced/envs/dev
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
terraform state list
```

*Результат*: state-файл сохранится в бакете infra-terraform-state/dev/terraform.tfstate


# CI/CD pipeline

Логика пайплайна:
- Инициализация Terraform
    ```
    terraform init
        -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
    ```
- Скачивает Terraform state из S3
- Выполняет terraform plan и terraform apply
    - Команда: `terraform plan -out=tfplan`
    - Артефакт: файл `tfplan`, который передается на следующий этап.
    - Команда: `terraform apply "tfplan"`
    - Запуск: Ручной (manual trigger) по кнопке в интерфейсе GitLab.


### Переменные окружения (CI/CD Variables)
В настройках репозитория GitLab (Settings -> CI/CD -> Variables) необходимо добавить следующие переменные:

- ACCESS_KEY (masked var)
    - Access Key ID для доступа к S3 бакету (хранение state)
- SECRET_KEY (masked var)
    - Secret Access Key для доступа к S3 бакету
- YC_TOKEN (masked var)
	- OAuth токен или IAM токен для аутентификации провайдера Yandex
- YC_CLOUD_ID
    - ID облака Yandex Cloud
- YC_FOLDER_ID
    - ID каталога Yandex Cloud

⚠️ **Важно**: Terraform автоматически подхватывает переменные окружения YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID — их не нужно передавать через -var или указывать в provider явно.


### Безопасность

- Файл состояния `terraform.tfstate` хранится в защищенном S3 бакете, а не в репозитории.
- Секреты (ключи доступа) не хранятся в коде, а передаются через переменные окружения CI/CD.
- Применение изменений требует ручного подтверждения (when: manual), что предотвращает случайные изменения инфраструктуры.


