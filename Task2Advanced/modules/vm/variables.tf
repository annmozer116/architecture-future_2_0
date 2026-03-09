variable "name" {
  description = "Имя виртуальной машины"
  type        = string
}

variable "cores" {
  description = "Количество ядер процессора"
  type        = number
}

variable "ram" {
  description = "Объём оперативной памяти (ГБ)"
  type        = number
}

variable "disk_size" {
  description = "Размер подключаемого диска (ГБ)"
  type        = number
}

variable "subnet_id" {
  description = "Идентификатор подсети"
  type        = string
}

variable "ssh_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "Идентификатор образа ОС (например, Ubuntu)"
  type        = string
  default     = "fd87va5cc00gaq2f5qfb" # Ubuntu 22.04 LTS по умолчанию в Yandex Cloud
}

variable "platform_id" {
  description = "Платформа (тип виртуальной машины)"
  type        = string
  default     = "standard-v3"
}

variable "labels" {
  description = "Метки ресурса"
  type        = map(string)
  default     = {}
}
