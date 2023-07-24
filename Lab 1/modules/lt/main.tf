# Launch Template
resource "aws_launch_template" "ws_template" {
  name = "web-server-template"
  description = "launch template"
  image_id = var.image_id
  vpc_security_group_ids = [var.autoscaling_sg]
  key_name = var.instance_keypair
  instance_type = var.instance_type
  user_data = var.user_data
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.common_tags,
      {Name = var.instance_name}
    )
  }
}