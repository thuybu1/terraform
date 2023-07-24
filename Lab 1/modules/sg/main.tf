# SECURITY GROUPS
# Bastion Host
module "public_bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "public_bastion_sg"
  vpc_id = var.vpc_id

  description = "Security group with SSH & HTTP ports open publicly (IPv4 CIDR), egress ports are publicly open"
  # Ingress Rules & CIDR Block  
  ingress_rules = ["ssh-tcp", "all-icmp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  
  tags = var.common_tags
}

# Original Web Server
module "web_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "web_instance_sg"
  vpc_id = var.vpc_id

  description = "Security group with SSH port open for Bastion Host, egress ports are publicly open"
  # Ingress Rules
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.public_bastion_sg.security_group_id
    },
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.public_bastion_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

# Elastic Load Balancer
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "alb_sg"
  vpc_id = var.vpc_id

  description = "Security group with HTTP ports open publicly, egress ports are publicly open"
  # Ingress Rules & CIDR Block  
  ingress_rules = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}

# Web Tier (Auto Load Balancer)
module "web_tier_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "web_tier_sg"
  vpc_id = var.vpc_id

  description = "Security group with HTTP port open for ALB, egress ports are publicly open"
  # Ingress Rules
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = module.public_bastion_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 3

  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  
  tags = var.common_tags
}

# Database Tier
module "db_tier_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name = "db_tier_sg"
  vpc_id = var.vpc_id

  description = "Security group with MySQL open for Web Tier, egress ports are publicly open"
  # Ingress Rules
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.web_tier_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  # Egress Rule - all-all open
  egress_rules = ["all-all"]

  tags = var.common_tags
}
