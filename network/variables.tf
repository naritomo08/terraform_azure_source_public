variable "location" {
  type        = string
  default     = "japaneast"
  description = ""
}

variable "virtual_network_name" {
  type        = string
  default     = "VirtualNetwork"
  description = ""
}

variable "network_address" {
  default     = ["10.0.0.0/23"]
  description = ""
}

variable "public_address" {
  default     = ["10.0.0.0/25"]
  description = ""
}

variable "private_address" {
  default     = ["10.0.0.128/26"]
  description = ""
}

variable "bastion_address" {
  default     = ["10.0.0.192/26"]
  description = ""
}

variable "public-securitygroup" {
  type        = string
  default     = "public-securitygroup"
  description = ""
}

variable "private-securitygroup" {
  type        = string
  default     = "private-securitygroup"
  description = ""
}

variable "bastion-securitygroup" {
  type        = string
  default     = "bastion-securitygroup"
  description = ""
}

variable "public_address_nsg" {
  type        = string
  default     = "10.0.0.0/25"
  description = ""
}

variable "private_address_nsg" {
  type        = string
  default     = "10.0.0.128/26"
  description = ""
}

variable "bastion_address_nsg" {
  type        = string
  default     = "10.0.0.192/26"
  description = ""
}
