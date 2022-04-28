resource "null_resource" "nomad_server" {
  count = var.servers
  depends_on = [yandex_compute_instance.vm_server]
  
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm_server[count.index].network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = "shared"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/shared/scripts/setup.sh",
      "sudo /tmp/shared/scripts/setup.sh",
      "chmod +x /tmp/shared/scripts/server.sh",
      "sudo /tmp/shared/scripts/server.sh ${yandex_compute_instance.vm_server[count.index].network_interface.0.ip_address} ${var.servers} '${join(", ", [for s in yandex_compute_instance.vm_server[*].network_interface.0.ip_address : format("%q", s)])}'"
    ]
  }
}

resource "null_resource" "nomad_client" {
  count = var.clients
  depends_on = [yandex_compute_instance.vm_client, null_resource.nomad_server]
  
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm_client[count.index].network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = "shared"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/shared/scripts/setup.sh",
      "sudo /tmp/shared/scripts/setup.sh",
      "chmod +x /tmp/shared/scripts/client.sh",
      "sudo /tmp/shared/scripts/client.sh ${yandex_compute_instance.vm_client[count.index].network_interface.0.ip_address} '${join(", ", [for s in yandex_compute_instance.vm_server[*].network_interface.0.ip_address : format("%q", s)])}'",
    ]
  }
}

resource "null_resource" "nomad_server_start" {
  depends_on = [null_resource.nomad_server, null_resource.nomad_client]
  
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm_server[0].network_interface.0.nat_ip_address
  }

  provisioner "file" {
    source      = "nomad"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo nomad job run /tmp/nomad/jobs/weavedemo.nomad.hcl"
    ]
  }
}
