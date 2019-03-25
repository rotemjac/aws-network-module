data "aws_availability_zones" "available" {}


locals {
  azs_for_private_subnet = "${slice(var.azs, 0 , var.number_of_private_subnets )}"
  azs_for_public_subnet  = "${slice(var.azs, 0 , var.number_of_public_subnets )}"
}


variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}


variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
  type        = "list"
}

variable "number_of_private_subnets" {
  default     = ""
}

variable "number_of_public_subnets" {
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}


variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
  type = "map"
}
