output "external_ip_address_server" {
  value = module.nomad_cluster[*].external_ip_address_server
}

output "external_ip_address_client" {
  value = module.nomad_cluster[*].external_ip_address_client
}
