output "public_bastion_sg_id" {
  value = module.public_bastion_sg.security_group_id
}

output "web_instance_sg_id" {
  value = module.web_instance_sg.security_group_id
}

output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}

output "web_tier_sg_id" {
  value = module.web_tier_sg.security_group_id
}

output "db_tier_sg_id" {
  value = module.db_tier_sg.security_group_id
}