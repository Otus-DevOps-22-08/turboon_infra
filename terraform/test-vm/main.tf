provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
  version                  = "~> 0.35"
}

resource "yandex_vpc_network" "test-vm-network" {
  name = "test-vm-network"
}

resource "yandex_vpc_subnet" "test-vm-subnet" {
  name          = "test-vm-subnet"
  zone          = "ru-central1-a"
  network_id    = "${yandex_vpc_network.test-vm-network.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "vm" {
  source 		= "../modules/vm"
  public_key_path 	= var.public_key_path
  subnet_id		= "${yandex_vpc_subnet.test-vm-subnet.id}"
  image_id		= var.ubuntu_image_id
  vm_name		= "test-vm"
}
