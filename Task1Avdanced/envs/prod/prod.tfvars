# Окружение: production (максимальные ресурсы)
# Обязательные для провайдера Yandex Cloud
cloud_id  = "b1gxxxxxxxxxxxxxxxxxx"  # ID облака
folder_id = "b1gxxxxxxxxxxxxxxxxxx"  # ID каталога
# token     = "ваш_OAuth_или_IAM_токен"  # НЕ ХРАНИТЬ В ФАЙЛЕ! Использовать CI/CD переменные


vm_name   = "prod-vm"
cores     = 8
ram       = 16
disk_size = 100

subnet_id = "e2lxxxxxxxxxxxxxxxxxx"

ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your_email@example.com"

zone     = "ru-central1-a"
image_id = "fd87va5cc00gaq2f5qfb"

labels = {
  env  = "prod"
  role = "production"
}
