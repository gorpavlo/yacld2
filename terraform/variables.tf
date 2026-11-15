variable "service_account_key_file" {
  description = "Path to the service account key file (JSON format)"
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
}

variable "yc_zone" {
  description = "Yandex Cloud Zone"
  default     = "ru-central1-a"
}

variable "yc_region" {
  description = "Yandex Cloud Region"
  default     = "ru-central1"
}

variable "public_key" {
  description = "Public SSH key for VM access"
}