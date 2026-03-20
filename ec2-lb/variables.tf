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

