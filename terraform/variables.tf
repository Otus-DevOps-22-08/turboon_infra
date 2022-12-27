variable cloud_id {
  description = "Cloud"
}

variable folder_id {
  description = "Folder"
}

#variable db_ip {
#  description = "IP address of database instance"
#}

variable db_image_id {
  description = "Disk image id for VM with mongo installed "
  default = "fd86d2fspsoo7ah1aaqr"
}

variable app_image_id {
  description = "Disk image id for VM with Ruby installed"
}

variable instance_count {
  description = "Number of instances"
  default = 1
}

variable zone {
  description = "Zone"
  default     = "ru-central1-a"
}

variable public_key_path {
  description = "Path to the public key user for ssh access"
}

variable image_id {
  description = "Disk image"
}

variable subnet_id {
  description = "Subnet"
}

variable network_id {
  description = "Subnet"
}

variable service_account_key_file {
  description = "key .json"
}
