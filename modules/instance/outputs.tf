output "external_ip_address_server" {
  value = yandex_compute_instance.vm_server[*].network_interface.0.nat_ip_address
}

output "external_ip_address_client" {
  value = yandex_compute_instance.vm_client[*].network_interface.0.nat_ip_address
}
