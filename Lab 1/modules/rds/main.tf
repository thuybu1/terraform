module "database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier = var.identifier

  engine            = "mysql"
  engine_version    = "8.0.32"
  major_engine_version = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  family            = "mysql8.0"

  db_name  = var.db_name
  username = var.username
  password = var.password

  create_db_subnet_group = true
  subnet_ids             = var.subnet_ids
  vpc_security_group_ids = var.security_group_ids

  tags = var.common_tags
}