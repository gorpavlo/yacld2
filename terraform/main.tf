terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.83.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
}

# Создаем сеть
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

# Создаем подсеть
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Создаем 2 идентичные ВМ с использованием count
resource "yandex_compute_instance" "vm" {
  count = 2

  name        = "vm-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8j57s0d49lq8613r9h"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }
}

# Создаем целевую группу
resource "yandex_lb_target_group" "target-group-1" {
  name      = "target-group-1"
  region_id = var.yc_region

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

# Создаем сетевой балансировщик нагрузки
resource "yandex_lb_network_load_balancer" "balancer-1" {
  name = "network-balancer-1"
  listener {
    name        = "listener-1"
    port        = 80
    protocol    = "tcp"
    target_port = 80
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group-1.id

    healthcheck {
      name        = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}