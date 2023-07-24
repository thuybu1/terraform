module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "${var.project_prefix}-key"
  create_private_key = true
  tags = var.common_tags
}