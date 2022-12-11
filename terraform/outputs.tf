output "external_ip_addresses" {
  value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
}
#output "external_ip_address_app2" {
#	value = yandex_compute_instance.app2.network_interface.0.nat_ip_address
#}
#output "alb_ip_address" {
#  value = yandex_alb_load_balancer.reddit-app-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0
#}
