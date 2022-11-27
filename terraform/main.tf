provider "yandex" {
	zone = "ru-central1-a"
	cloud_id = "b1gmbd68ti7hv9stviie"
	folder_id = "b1gpuerdiskoiae481fe"
}

resource "yandex_compute_instance" "app" {
	name = "reddit-app"

	resources {
		cores = 2
		memory = 2
	}

	boot_disk {
		initialize_params {
			image_id = "fd8rc8est5392grgl0qd"
		}
	}

	network_interface {
		subnet_id 	= "e9b76nlnhe2pbg8n6ufn"
		nat 		= true
	}

	scheduling_policy {
	        preemptible = true
	}

	metadata = {
	ssh-keys = "ubuntu:${file("~/.ssh/yac.pub")}"
	}

	connection {
		type = "ssh"
		host = yandex_compute_instance.app.network_interface.0.nat_ip_address
		user = "ubuntu"
		agent = true
		timeout = 15
		#private_key = file("~/.ssh/yac")
	}

	provisioner "file" {
		source = "files/puma.service"
		destination = "/tmp/puma.service"
	}

	provisioner "remote-exec" {
		script = "files/deploy.sh"
	}
}
