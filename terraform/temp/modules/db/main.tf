resource "yandex_compute_instance" "db" {
  #count = var.instance_count

  name = "reddit-db"

  labels = {
    tags = "reddit-db"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.db_image_id
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
    host = yandex_compute_instance.db.network_interface.0.nat_ip_address
    #host    = self.network_interface.0.nat_ip_address
    user    = "ubuntu"
    agent   = true
    timeout = 15
  }

#  provisioner "file" {
#    source      = "files/puma.service"
#    destination = "/tmp/puma.service"
#  }

#  provisioner "remote-exec" {
#    script = "files/deploy.sh"
#  }
}
