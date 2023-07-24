module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.instance_name

  ami                    = var.ami_type
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id
  tags = var.common_tags
  user_data = var.user_data
  associate_public_ip_address = true
}

