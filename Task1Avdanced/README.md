# Окружения Terraform

Три окружения используют общий модуль `modules/vm` с разными параметрами из `.tfvars`.

## Перед применением

### 1. Получите OAuth-токен Yandex Cloud
   1. По ссылке: https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb
   2. Подтвердите доступ
   3. Скопируйте полученный токен (будет выглядеть как AgAAAAA...)

### 2. Получите ID облака и каталога
```
# В консоли Yandex Cloud:
# - ID облака виден в карточке облака
# - ID каталога виден в карточке каталога
# Или через CLI:
yc config list
```


### 3. Создайте сеть и подсеть в Yandex Cloud (или укажите существующий `subnet_id`).

```
# Создайте сеть и подсеть (если еще нет)
yc vpc network create --name future2_network
yc vpc subnet create \
  --name future2_subnet \
  --network-name future2_network \
  --zone ru-central1-a \
  --range 192.168.1.0/24
```
Сохранить полученный subnet_id (что то типа e2lxxxxxxxxxxxxxxxxxx)

### 4. Подготовьте SSH-ключ
```
# Если нет SSH-ключа, создайте:
ssh-keygen -t ed25519 -C "email@example.com"

# Копируем публичную часть:
cat ~/.ssh/id_ed25519.pub
# Выглядит как: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... email@example.com
```

2. В каждом `*.tfvars` замените:
   - `subnet_id` — на реальный ID подсети;
   - `ssh_key` — на содержимое вашего публичного SSH-ключа.
   - `cloud_id` и `folder_id` - одинаковые для всех окружений
      - `cloud_id`  = "b1gxxxxxxxxxxxxxxxxxx"  # Ваш ID облака
      - `folder_id` = "b1gxxxxxxxxxxxxxxxxxx"  # Ваш ID каталога
   - OAuth-токен нужно передать через переменную окружения

## Запуск по окружениям

```bash
# Development
cd envs/dev
export YC_TOKEN="AgAAAAA..."
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars

# Stage
cd envs/stage
export YC_TOKEN="AgAAAAA..."
terraform init
terraform plan -var-file=stage.tfvars
terraform apply -var-file=stage.tfvars

# Production
cd envs/prod
export YC_TOKEN="AgAAAAA..."
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
