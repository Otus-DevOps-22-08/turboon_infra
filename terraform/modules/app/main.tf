resource "yandex_compute_instance" "app" {
  #count = var.instance_count

  name = "reddit-app"
  allow_stopping_for_update = true

  labels =  {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.app_image_id
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
    host = yandex_compute_instance.app.network_interface.0.nat_ip_address
    #host    = self.network_interface.0.nat_ip_address
    user    = "ubuntu"
    agent   = true
    timeout = 15
  }

  provisioner "file" {
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "file" {
    source      = "${path.module}/files/deploy.tmpl"
    destination = "/tmp/deploy.tmpl"
  }

  provisioner "remote-exec" {
   inline = [
    "echo \"export DATABASE_URL=${var.db_ip}\" > /home/ubuntu/.bashrc",
    "cat /tmp/deploy.tmpl | sed -e 's/{{db_ip}}/${var.db_ip}/' > /tmp/deploy.sh",
    "chmod +x /tmp/deploy.sh",
    "/tmp/deploy.sh"
   ]
  }

  #provisioner "remote-exec" {
  # script = "/tmp/deploy.sh"
  #}

#  provisioner "remote-exec" {
#    inline = [
#      "echo \"export DATABASE_URL=${var.db_ip}\" >> ~/.bashrc",
#      "echo \"export DATABASE_URL=${var.db_ip}\" >> ~/.profile",
#      "
#    ]
#  }
}
