# variable "states_bucket_name" {
#   description = "The name of the S3 bucket for storing states"
# }

# variable "states_bucket_region" {
#   description = "The AWS region where the S3 bucket will be created"
# }

variable "access_key" {
  description = "Access Key to connect environment"
}

variable "secret_key" {
  description = "Secret Key to connect environment"
}

variable "provider_region" {
  description = "Main region"
}

variable "project_prefix" {
  description = "For naming resources"
}

variable "common_tags" {
  type = map(string)
  default = {
    "Project"   = "Lab1"
    "Terraform" = "TRUE"
  }
}

# VPC
variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

#Instances
variable "origin_name" {
  description = "Name of original web server"
}

variable "ami_name" {
  description = "Name of AMI for the template"
}

variable "ami_type" {
  description = "Web Server AMI type"
}

variable "instance_type" {
  description = "Web Server Instance type"
}

variable "user_data" {
  description = "Web Server user data initially"
}