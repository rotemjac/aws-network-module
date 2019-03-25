variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

