variable "key_name" {
  description = "Key for accessibility"
}

variable "security_group_ids" {
  description = "Security group ids for the instance"
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
}

variable "instance_name" {
  description = "Name of the instance"
}

variable "common_tags" {
  type = map(string)
}

variable "ami_type" {
  description = "Instance AMI type"
}

variable "instance_type" {
  description = "Instance type"
}

variable "user_data" {
  description = "Instance user data initially"
  default = null
}

variable "project_prefix" {
  description = "Project Prefix"
}