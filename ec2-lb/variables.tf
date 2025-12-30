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
