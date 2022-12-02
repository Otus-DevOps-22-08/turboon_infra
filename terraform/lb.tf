resource "yandex_alb_http_router" "reddit-app-router" {
  name      = "reddit-app-router"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "reddit-app-virtual-host" {
  name      = "reddit-app-virtual-host"
  http_router_id = yandex_alb_http_router.reddit-app-router.id
  route {
    name = "default_route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.reddit-app-backend-group.id
        #timeout = "3s"
      }
    }
  }
}

resource "yandex_alb_target_group" "reddit-app-target-group" {
  name      = "reddit-app-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app
    content {
      subnet_id = var.subnet_id
      ip_address   =  target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_alb_backend_group" "reddit-app-backend-group" {
  name      = "reddit-app-backend-group"

  http_backend {
    name = "reddit-app-http-backend"
    weight = 1
    port = 9292
    target_group_ids = [yandex_alb_target_group.reddit-app-target-group.id]
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
      healthy_threshold = 1
      unhealthy_threshold = 1
    }
    http2 = "false"
  }
}


resource "yandex_alb_load_balancer" "reddit-app-balancer" {
  name        = "reddit-app-balancer"

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
        http_router_id = yandex_alb_http_router.reddit-app-router.id
      }
    }
  }
}
