variable "project_prefix" {
  description = "For naming resources"
  default = "lab1"
}

variable "common_tags" {
  type = map(string)
}