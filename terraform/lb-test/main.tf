provider "yandex" {
	zone = var.zone
	cloud_id = var.cloud_id
	folder_id = var.folder_id
	service_account_key_file = var.service_account_key_file
}


resource "yandex_alb_http_router" "reddit-app-test-router" {
  name      = "reddit-app-test-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name      = "my-virtual-host"
  http_router_id = yandex_alb_http_router.reddit-app-test-router.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        #timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_target_group" "foo" {
  name      = "my-target-group"

  target {
    subnet_id = var.subnet_id
    ip_address   = "10.128.0.12"
  }

  target {
    subnet_id = var.subnet_id
    ip_address   = "10.128.0.34"
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name      = "my-backend-group"

  http_backend {
    name = "test-http-backend"
    weight = 1
    port = 9292
    target_group_ids = [yandex_alb_target_group.foo.id]
    #tls {
    #  sni = "backend-domain.internal"
    #}
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout = "1s"
      interval = "1s"
      healthcheck_port = 9292
      http_healthcheck {
        path  = "/"
      }
    }
    http2 = "true"
  }
}


resource "yandex_alb_load_balancer" "reddit-app-test-balancer" {
  name        = "reddit-app-test-balancer"

  #network_id  = yandex_vpc_network.test-network.id
  network_id  = var.network_id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = var.subnet_id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.reddit-app-test-router.id
      }
    }
  }
}
