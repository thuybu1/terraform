# Autoscaling Group Resource
resource "aws_autoscaling_group" "my_asg" {
  name = "${var.project_prefix}-asg"
  desired_capacity   = 2
  max_size           = 6
  min_size           = 2
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns = var.target_group_arns
  health_check_type = "EC2"
  #health_check_grace_period = 300 # default is 300 seconds  

  # Launch Template
  launch_template {
    id      = var.launch_template.id
    version = var.launch_template.latest_version
  }
  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"
    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 50
    }
    triggers = [ /*"launch_template",*/ "desired_capacity" ] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }  
}

# Define CloudWatch Alarms for Autoscaling Groups
# Autoscaling - Scaling Policy for High CPU
resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high-cpu"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name 
}

# Cloud Watch Alarm to trigger the above scaling policy when CPU Utilization is above 80%
# Also send the notificaiton email to users present in SNS Topic Subscription
resource "aws_cloudwatch_metric_alarm" "asg_cwa_cpu" {
  alarm_name          = "${var.project_prefix}-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name 
  }

  alarm_description = "This metric monitors ec2 cpu utilization and triggers the ASG Scaling policy to scale-out if CPU is above 80%"
  
  # SNS 
  # ok_actions          = [aws_sns_topic.myasg_sns_topic.arn]  
  # alarm_actions     = [
  #   aws_autoscaling_policy.high_cpu.arn, 
  #   aws_sns_topic.myasg_sns_topic.arn
  #   ]
}

