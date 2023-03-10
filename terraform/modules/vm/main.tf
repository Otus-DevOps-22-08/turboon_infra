resource "yandex_compute_instance" "vm" {
  #count = var.instance_count
  name = var.vm_name
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type = "ssh"
    host = yandex_compute_instance.vm.network_interface.0.nat_ip_address
    #host    = self.network_interface.0.nat_ip_address
    user    = "ubuntu"
    agent   = true
    timeout = 15
  }
}
