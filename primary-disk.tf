
resource "libvirt_volume" "primary_disk" {
  name             = "${var.guest_name}.qcow2"
  pool             = var.storage_pool
  base_volume_name = var.base_volume_name
  size             = var.base_volume_size
}
