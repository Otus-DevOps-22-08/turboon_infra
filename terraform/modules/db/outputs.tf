output "external_db_ip_address" {
  value = yandex_compute_instance.db.network_interface.0.nat_ip_address
}
