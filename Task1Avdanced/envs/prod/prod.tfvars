# Окружение: production (максимальные ресурсы)

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
