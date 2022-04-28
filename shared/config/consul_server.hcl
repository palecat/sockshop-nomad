log_level = "INFO"
server    = true
data_dir  = "/opt/consul/data"
ui = true
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
bootstrap_expect = SERVER_COUNT
service {
  name = "consul"
}
retry_join = [RETRY_JOIN]
advertise_addr = "IP_ADDRESS"
