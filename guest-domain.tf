
resource "libvirt_domain" "guest_domain" {
  name = var.guest_name

  cpu { mode = "host-passthrough" }
  vcpu   = var.vcpu
  memory = var.memory

  disk {
    volume_id = libvirt_volume.primary_disk.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_disk.id

  network_interface {
    network_name   = var.network_name
    wait_for_lease = false
  }

  graphics { type = "vnc" }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

}
