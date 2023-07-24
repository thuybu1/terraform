# CREATE VPC & SUBNETTING
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  vpc_name        = "${var.project_prefix}-VPC"
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  common_tags     = var.common_tags
}

# GENERATE SECURITY GROUPS
module "security_groups" {
  source      = "./modules/sg"
  vpc_id      = module.vpc.vpc_id
  common_tags = var.common_tags
}

# GENERATE KEY FOR THE WEB SERVER
module "ws_key" {
  source         = "./modules/key"
  project_prefix = var.project_prefix
  common_tags    = var.common_tags
}

# DATABASE INSTANCE
module "rds_mysql_db" {
  source             = "./modules/rds"
  common_tags        = var.common_tags
  subnet_ids         = module.vpc.private_subnet.*.id
  db_name            = "lab1db"
  username           = "admin"
  password           = "abc123456"
  identifier         = "lab1-db"
  security_group_ids = [module.security_groups.db_tier_sg_id]
}

# MAIN WEB SERVER FOR DEPLOYING CODES
module "origin_ws_instance" {
  source             = "./modules/ec2"
  project_prefix     = var.project_prefix
  key_name           = module.ws_key.key_name
  instance_name      = var.origin_name
  security_group_ids = [module.security_groups.alb_sg_id]
  subnet_id          = module.vpc.public_subnet[0].id
  common_tags        = var.common_tags
  ami_type           = var.ami_type
  instance_type      = var.instance_type
  user_data          = var.user_data
}

# # BASTION HOST
# module "nat_instance" {
#   source             = "./modules/ec2"
#   project_prefix     = var.project_prefix
#   key_name           = module.ws_key.key_name
#   instance_name      = "${var.project_prefix} Bastion Host"
#   security_group_ids = [module.security_groups.public_bastion_sg_id]
#   subnet_id          = module.vpc.public_subnet[0].id
#   common_tags        = var.common_tags
#   ami_type           = "ami-0356fe6f21ab7c13e"
#   instance_type      = var.instance_type
# }
# resource "aws_eip" "nat_eip" {
#   vpc = true
# }
# resource "aws_eip_association" "nat_eip_assoc" {
#   instance_id   = module.nat_instance.instance_id
#   allocation_id = aws_eip.nat_eip.id
# }


# APPLICATION LOAD BALANCERS
module "alb" {
  source              = "./modules/lb"
  common_tags         = var.common_tags
  alb_security_groups = [module.security_groups.alb_sg_id]
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet.*.id
  project_prefix      = var.project_prefix
  target_instance_id  = module.origin_ws_instance.instance_id
}

# AUTOSCALING WITH LAUNCH TEMPLATE CREATED FROM ORIGINAL WEB SERVER AMI
# Launch Template
module "web_server_lt" {
  source           = "./modules/lt"
  common_tags      = var.common_tags
  autoscaling_sg   = module.security_groups.web_tier_sg_id
  instance_name    = "Web Server"
  instance_keypair = module.ws_key.key_name
  instance_type    = var.instance_type
  instance_id      = module.origin_ws_instance.instance_id
  image_id         = var.ami_type
  project_prefix   = var.project_prefix
  user_data        = filebase64("${path.module}/userdata.sh")
}

# Auto scaling group with CloudWatch Alarms
module "auto_scaling" {
  source            = "./modules/as"
  project_prefix    = var.project_prefix
  common_tags       = var.common_tags
  subnet_ids        = module.vpc.private_subnet.*.id
  target_group_arns = module.alb.target_group_arns
  launch_template   = module.web_server_lt.lt
}



