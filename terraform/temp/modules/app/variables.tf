variable app_image_id {
  description = "Disk image id for VM with Ruby installed"
  default = "fd81eag42gn156ht1u8s"
}
variable "public_key_path" {
  description = "Path to the public key user for ssh access"
  default = "//home//rkv//.ssh//yac.pub"
}

variable subnet_id {
  description = "Subnet"
  default = "e9b76nlnhe2pbg8n6ufn"
}
