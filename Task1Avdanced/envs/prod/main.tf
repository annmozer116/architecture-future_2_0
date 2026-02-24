terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  zone = var.zone
}

module "vm" {
  source = "../../modules/vm"

  name      = var.vm_name
  cores     = var.cores
  ram       = var.ram
  disk_size = var.disk_size
  subnet_id = var.subnet_id
  ssh_key   = var.ssh_key
  zone      = var.zone
  image_id  = var.image_id
  labels    = var.labels
}
