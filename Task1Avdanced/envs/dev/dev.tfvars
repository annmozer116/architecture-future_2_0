# Окружение: development (минимальные ресурсы)

vm_name   = "dev-vm"
cores     = 2
ram       = 2
disk_size = 20

# Укажите свой subnet_id после создания сети в Yandex Cloud
subnet_id = "e2lxxxxxxxxxxxxxxxxxx"

# Публичная часть SSH-ключа (содержимое ~/.ssh/id_rsa.pub или id_ed25519.pub)
ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your_email@example.com"

zone    = "ru-central1-a"
image_id = "fd87va5cc00gaq2f5qfb" # Ubuntu 22.04 LTS

labels = {
  env  = "dev"
  role = "development"
}
