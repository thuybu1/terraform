variable "common_tags" {
  type = map(string)
  description = "Common Tags"
}

variable "subnet_ids" {
  description = "Zones for instances created"
}

variable "target_group_arns" {
  description = "ARNs of the target groups"
}

variable "launch_template" {
  description = "Launch Template to be attached"
}

variable "project_prefix" {
  description = "Project prefix for naming resources"
}