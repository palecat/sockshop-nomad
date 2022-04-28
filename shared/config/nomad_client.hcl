data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

client {
  enabled = true
  options {
    "docker.volumes.enabled" = "true"
  }
}

consul {
  address = "127.0.0.1:8500"
}
