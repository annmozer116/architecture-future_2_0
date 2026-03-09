terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "infra-terraform-state" 
    region     = "ru-central1"
    key        = "dev/terraform.tfstate"

    # Аутентификация через переменные окружения:
    # AWS_ACCESS_KEY_ID
    # AWS_SECRET_ACCESS_KEY
    # или через параметры:
    # access_key = "static-key"
    # secret_key = "secret-key"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}