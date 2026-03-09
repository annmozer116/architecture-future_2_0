variable "vm_name" {
  description = "Имя ВМ"
  type        = string
}

variable "cores" {
  description = "Количество ядер"
  type        = number
}

variable "ram" {
  description = "Объём RAM (ГБ)"
  type        = number
}

variable "disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "ID образа ОС"
  type        = string
  default     = "fd87va5cc00gaq2f5qfb"
}

variable "labels" {
  description = "Метки"
  type        = map(string)
  default     = {}
}
