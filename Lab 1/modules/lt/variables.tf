variable "common_tags" {
  description = "Common Tags"
}

variable "autoscaling_sg" {
  description = "Auto scaling security group"
}

variable "instance_name" {
  description = "Name of instances created"
}

variable "instance_keypair" {
  description = "Keyname of the keypair for the instances"
}

variable "instance_type" {
  description = "Instance type"
}

variable "instance_id" {
  description = "instance ID to export AMI"
}

variable "image_id" {
  description = "AMI type id"
}

variable "user_data" {
  description = "User Data"
}

variable "project_prefix" {
  description = "Project Prefix"
}