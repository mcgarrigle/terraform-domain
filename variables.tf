variable "libvirt_uri" {
  type = string
}

variable "guest_name" {
  type    = string
  default = "terraform_guest"
}

variable "vcpu" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 2048
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "user" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "storage_pool" {
  type    = string
  default = "filesystems"
}

variable "base_volume_name" {
  type = string
}

variable "base_volume_size" {
  type = number
}
