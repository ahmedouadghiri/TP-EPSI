resource "scaleway_instance_ip" "public_ip" {
}
resource "scaleway_instance_server" "web" {
  name = "router"
  image = "ubuntu_focal"
  type = "DEV1-S"
  tags = ["front", "web"]
  ip_id = scaleway_instance_ip.public_ip.id
  root_volume {}
  }

