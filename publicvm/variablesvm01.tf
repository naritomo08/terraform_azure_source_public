variable "vm01-vmname" {
  type        = string
  default     = "vm01"
  description = ""
}

variable "vm01-network_interface_name" {
  type        = string
  default     = "vm01-public"
  description = ""
}

variable "vm01-publicip" {
  type        = string
  default     = "vm01-publicip"
  description = ""
}

variable "vm01-hostname" {
  type        = string
  default     = "vm01"
  description = ""
}

variable "vm01-storagename" {
  type        = string
  default     = "vm01-sdisk"
  description = ""
}

variable "vm01-username" {
  type        = string
  default     = "testadmin"
  description = ""
}

variable "vm01-password" {
  type        = string
  default     = "Password1234!"
  description = ""
}
