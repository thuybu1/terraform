# # Create S3 Bucket for Storing States
# module "terraform_s3_backend" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket_name          = var.states_bucket_name
#   region               = var.states_bucket_region
#   versioning_enabled   = true
#   lifecycle_rule_prefix = "terraform-state/"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# terraform {
#   backend "s3" {
#     bucket = var.states_bucket_name
#     key    = "terraform.tfstate"
#     region = "us-west-1"
#   }
# }

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}
