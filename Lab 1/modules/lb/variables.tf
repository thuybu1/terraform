variable "public_subnet_ids" {
  description = "list of public subnet ids"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_groups" {
  description = "list of security groups for alb"
}

variable "project_prefix" {
  description = "for naming resources"
}

variable "target_instance_id" {
  description = "ID of the target instance"
}

variable "common_tags" {
  description = "Tags"
}