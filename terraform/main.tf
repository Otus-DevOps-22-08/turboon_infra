provider "yandex" {
	zone = var.zone
	cloud_id = var.cloud_id
	folder_id = var.folder_id
	service_account_key_file = var.service_account_key_file
}


resource "yandex_compute_instance" "app" {
	 count = 3

	name = "reddit-app-${count.index + 1}"

	resources {
		cores = 2
		memory = 2
	}

	boot_disk {
		initialize_params {
			image_id = var.image_id
		}
	}

	network_interface {
		subnet_id 	= var.subnet_id
		nat 		= true
	}

	scheduling_policy {
	        preemptible = true
	}

	metadata = {
		ssh-keys = "ubuntu:${file(var.public_key_path)}"
	}

	connection {
		type = "ssh"
		#host = yandex_compute_instance.app.0.network_interface.0.nat_ip_address
		host = self.network_interface.0.nat_ip_address
		user = "ubuntu"
		agent = true
		timeout = 15
	}

	provisioner "file" {
		source = "files/puma.service"
		destination = "/tmp/puma.service"
	}

	provisioner "remote-exec" {
		script = "files/deploy.sh"
	}
}

#resource "yandex_compute_instance" "app2" {
#       name = "reddit-app-2"
#
#       resources {
#              cores = 2
#                memory = 2
#        }
#
#        boot_disk {
#                initialize_params {
#                     image_id = var.image_id
#               }
#       }
#
#        network_interface {
#                subnet_id       = var.subnet_id
#                nat             = true
#        }
#
#        scheduling_policy {
#                preemptible = true
#        }
#
#        metadata = {
#                ssh-keys = "ubuntu:${file(var.public_key_path)}"
#        }
#
#        connection {
#                type = "ssh"
#                host = yandex_compute_instance.app2.network_interface.0.nat_ip_address
#                user = "ubuntu"
#                agent = true
#                timeout = 15
#        }
#
#       provisioner "file" {
#                source = "files/puma.service"
#                destination = "/tmp/puma.service"
#       }
#
#        provisioner "remote-exec" {
#                script = "files/deploy.sh"
#       }
#}
