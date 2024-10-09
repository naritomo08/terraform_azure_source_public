variable "location" {
  type        = string
  default     = "japaneast"
  description = ""
}

variable "bastion_address" {
  default     = ["10.0.0.192/26"]
  description = ""
}

variable "bastion-securitygroup" {
  type        = string
  default     = "bastion-securitygroup"
  description = ""
}
