source "qemu" "example" {
  iso_url           = "/root/Rocky-8.4-x86_64-minimal.iso"
  iso_checksum      = "sha256:0de5f12eba93e00fefc06cdb0aa4389a0972a4212977362ea18bde46a1a1aa4f"
  output_directory  = "build-rocky-8"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "5000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "./ks"
  ssh_username      = "root"
  ssh_password      = "%Serveur44"
  ssh_timeout       = "20m"
  vm_name           = "tp-1"
  memory            = "2048"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  //Time waited by packer before do any action
  qemu_binary       = "/usr/libexec/qemu-kvm"
  display           = "none"
  headless          = "true"
  boot_wait         = "10s"
  boot_command      = ["<tab> text inst.ks=http://192.168.122.1:{{ .HTTPPort }}/rocky-8.cfg<enter><wait>"]
}

build {
  sources = ["source.qemu.example"]

  provisioner "ansible" {      
    playbook_file = "./playbook.yaml"
    user = "root"
    }
}






