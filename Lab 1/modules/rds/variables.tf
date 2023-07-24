variable "identifier" {
  description = "DB Identifier"
}

variable "subnet_ids" {
  description = "Subnet IDs"
}

variable "db_name" {
  description = "RDS Database Name"
}

variable "username" {
  description = "Username to access DB"
}

variable "password" {
  description = "Password to access DB"
}

variable "common_tags" {
  description = "Common Tags"
}

variable "security_group_ids" {
  description = "Security Group IDs"
}