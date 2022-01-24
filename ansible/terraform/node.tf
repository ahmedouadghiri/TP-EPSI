resource "scaleway_server" "node" {
  count = "${var.scaleway_node_count}"
  name = "node${count.index}"
  image = "ubuntu_focal"
  type = "DEV1-S"
  tags = ["front", "web"]
  ip_id = scaleway_instance_ip.public_ip.id
  root_volume {}
}

resource "null_resource" "configure-node" {
  count = "${var.scaleway_node_count}"

  connection {
    type = "ssh"
    user = "root"
    private_key = "${file(var.scaleway_private_key_path)}"
    host = "${scaleway_server.node.*.private_ip[count.index]}"
    bastion_host = "${scaleway_server.router.public_ip}"
    bastion_user = "root"
    bastion_private_key = "${file(var.scaleway_private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"root:root\" | chpasswd",
      "echo \"${scaleway_server.node.*.id[count.index]}\" > /etc/host_id",
      "echo \"${scaleway_server.router.id}\" > /etc/router_id",
      "echo \"${scaleway_server.router.private_ip} router\" >> /etc/hosts",
      "echo \"${count.index}\" > /etc/host_number",
      "netstat -rn | grep 0.0.0.0 | awk '{print $2}' | grep -v \"0.0.0.0\" > /etc/host_gateway"
    ]
  }
}
