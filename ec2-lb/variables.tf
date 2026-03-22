variable "instance_count" {
  description = "The total number of ec2 instances are used to create this load balancer"
  default     = 0
}

variable "group_name" {
  description = "The given name for this group of instances"
  type        = string
}

variable "default_ami_value" {
  description = "Pass any AMI ID if want to customized at AMI level"
  type        = string
}

variable "default_region" {
  description = "The region for this resources"
  type        = string
  default     = "us-east-1"
}

# network section
variable "vpc_id" {
  description = "ID of the VPC for this resource, otherwise it will fall to default vpc"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The default type for instances if there is no argument was passed"
  type        = string
  default     = "t3.micro"
}

# logical variables
variable "open_publicy_ssh" {
  description = "The option to open SSH public or not"
  type        = number
  default     = 0
}

variable "bastion_host" {
  description = "Indicate that this machine have bastion host or not?"
  type        = number
  default     = 0
}

variable "bastion_net" {
  description = "Network for bastion host - subnet id"
  type        = string
  default     = ""
}

variable "machine_net" {
  description = "Network for main EC2 machine - subnet id"
  type        = string
  default     = ""
}

variable "generated_new_ssh_key" {
  description = "Optional, choose to generate a new SSH key or not"
  type        = number
  default     = 1
}

variable "pre_created_ssh_key" {
  description = "Specify whether a pre-created SSH key or not"
  type        = number
  default     = 0
}

variable "default_public_ip_to_machine" {
  description = "Quick test, turn it on, otherwise, it is best to leave it as false"
  type        = number
  default     = 0
}

# SSH key module
variable "key_alogrithm" {
  description = "Algorithm used to generate SSH key pair"
  type        = string
  default     = "RSA"

  validation {
    condition     = contains(["RSA", "ECDSA", "ED25519"], var.key_alogrithm)
    error_message = "The key algorithm must be RSA, ECDSA or ED25519."
  }
}

variable "key_bits" {
  description = "Number of bit used in the key generation process"
  type        = number
  default     = 4096
}