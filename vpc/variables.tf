variable "default_region" {
  description = "The region of this VPC"
  type        = string
  default     = "us-east-1"
}

variable "number_of_subnets" {
  description = "The number of identical subnet that will be created for each layer"
  type        = number
  default     = 3
}

variable "number_of_layer" {
  description = "The layer of this VPC, public only, private and public or additional database layer"
  type        = number
  default     = 1
}

variable "original_cidr" {
  description = "The CIDR for VPC, passed down for subnets"
  type        = string
  default     = "10.0.0.0/16"
}

variable "group_name" {
  description = "The group name for better naming"
  type        = string
  default     = "terraform-customize-module"
}

variable "nat_attached" {
  description = "Determine if the AWS provided NAT is used"
  type        = number
  default     = 1
}

variable "dedicated_eip_for_nat" {
  description = "Determine if want to use a dedicated EIP for NAT"
  type        = number
  default     = 1
}
