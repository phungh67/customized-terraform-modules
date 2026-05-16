variable "bucket-prefix" {
  description = "For better naming convention"
  default     = ""
  type        = string
}

variable "optional_region" {
  description = "Region to provision this bucket, but optional"
  default     = null
  type        = string
}

variable "service_type" {
  description = "Indicate the purpose of this bucket, storage, static host,..."
  default     = "storage"
  type        = string
}

# logical variable
variable "cors_specified" {
  description = "Specify if user want to provide pre-configured cors rules"
  default     = 0
  type        = number
}

variable "policy_specified" {
  description = "Specify if user want to provide pre-configured bucket policy"
  default     = 0
  type        = number
}

variable "lifecycle_specified" {
  description = "Specify if user want to provide pre-configued lifecycle policy."
  default     = 0
  type        = number
}

# variable for cors controller
variable "origin_string" {
  description = "Domain that is allowed to call S3"
  default     = ""
  type        = string
}
