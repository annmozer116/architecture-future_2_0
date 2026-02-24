# Окружения Terraform

Три окружения используют общий модуль `modules/vm` с разными параметрами из `.tfvars`.

## Перед применением

1. Создайте сеть и подсеть в Yandex Cloud (или укажите существующий `subnet_id`).
2. В каждом `*.tfvars` замените:
   - `subnet_id` — на реальный ID подсети;
   - `ssh_key` — на содержимое вашего публичного SSH-ключа.

## Запуск по окружениям

```bash
# Development
cd envs/dev
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars

# Stage
cd envs/stage
terraform init
terraform plan -var-file=stage.tfvars
terraform apply -var-file=stage.tfvars

# Production
cd envs/prod
terraform init
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
```

## Параметры по окружениям

| Параметр   | dev  | stage | prod |
|-----------|------|-------|------|
| Ядра      | 2    | 4     | 8    |
| RAM (ГБ)  | 2    | 4     | 16   |
| Диск (ГБ) | 20   | 40    | 100  |
