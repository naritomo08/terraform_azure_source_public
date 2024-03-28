variable "vm02-vmname" {
  type        = string
  default     = "vm02"
  description = ""
}

variable "vm02-network_interface_name" {
  type        = string
  default     = "vm02-public"
  description = ""
}

variable "vm02-publicip" {
  type        = string
  default     = "vm02-publicip"
  description = ""
}

variable "vm02-hostname" {
  type        = string
  default     = "vm02"
  description = ""
}

variable "vm02-storagename" {
  type        = string
  default     = "vm02-sdisk"
  description = ""
}

variable "vm02-username" {
  type        = string
  default     = "testadmin"
  description = ""
}

variable "vm02-password" {
  type        = string
  default     = "Password1234!"
  description = ""
}