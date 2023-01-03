provider "yandex" {
  zone                     = "ru-central1-a"
  cloud_id                 = "b1gmbd68ti7hv9stviie"
  folder_id                = "b1gpuerdiskoiae481fe"
  service_account_key_file = "/root/.ssh/yc_sac_key.json"
  version                  = "~> 0.35"
}

resource "yandex_vpc_network" "app-network" {
  name = "reddit-app-network"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name          = "reddit-app_subnet"
  zone          = "ru-central1-a"
  network_id    = "${yandex_vpc_network.app-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
