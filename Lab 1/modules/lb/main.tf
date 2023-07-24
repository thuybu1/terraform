# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.project_prefix}-alb"
  load_balancer_type = "application"
  vpc_id = var.vpc_id
  subnets = var.public_subnet_ids
  security_groups = var.alb_security_groups
  
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]  
  # Target Groups
  target_groups = [
    # Project Target Group
    {
      name     = "${var.project_prefix}-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "HTTP"
      }      
      protocol_version = "HTTP1"
      # Project Target Group - Targets
      # targets = [
      #   {
      #     target_id = var.target_instance_id
      #     port      = 80
      #   }      
      # ]
      tags = var.common_tags # Target Group Tags
    }     
  ]
  tags = var.common_tags # ALB Tags
}