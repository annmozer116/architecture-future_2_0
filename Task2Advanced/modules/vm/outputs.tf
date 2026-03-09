output "instance_id" {
  description = "Идентификатор созданной ВМ"
  value       = yandex_compute_instance.vm.id
}

output "internal_ip" {
  description = "Внутренний IP-адрес ВМ"
  value       = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip" {
  description = "Внешний IP-адрес ВМ (если включён NAT)"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "name" {
  description = "Имя ВМ"
  value       = yandex_compute_instance.vm.name
}
