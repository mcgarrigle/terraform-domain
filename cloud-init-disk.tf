
resource "libvirt_cloudinit_disk" "cloudinit_disk" {
  name           = "${var.guest_name}.iso"
  pool           = var.storage_pool
  user_data      = templatefile("${path.module}/cloud-init/user-data", {
    fqdn           = var.fqdn
    hostname       = var.hostname
    user           = var.user
    ssh_public_key = var.ssh_public_key
  })
  meta_data = templatefile("${path.module}/cloud-init/meta-data", {
    guest_name     = var.guest_name
    hostname       = var.hostname
  })
  network_config = templatefile("${path.module}/cloud-init/network-config-dhcp", {
    network_interface = var.network_interface
  })
}
