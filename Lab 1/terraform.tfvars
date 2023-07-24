# states_bucket_name   = "lab1-states"
# states_bucket_region = "us-east-1"
# PROJECT
project_prefix = "Lab1"

# PROVIDER
access_key      = "AKIASZTATQXGGFP56GUN"
secret_key      = "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"
provider_region = "us-east-1"

# VPC
vpc_cidr        = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
private_subnets = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
common_tags = {
  "Terraform" = "TRUE"
  "Project"   = "Lab 1"
}

# INSTANCES
ami_name      = "web_server_ami"
origin_name   = "Original Web Server"
ami_type      = "ami-03c7d01cf4dedc891"
instance_type = "t2.micro"
user_data     = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
              cat /etc/system-release
              sudo yum install -y httpd mariadb-server
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo systemctl is-enabled httpd
              sudo usermod -a -G apache ec2-user
              sudo chown -R ec2-user:apache /var/www
              sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
              find /var/www -type f -exec sudo chmod 0664 {} \;
              echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php         
              EOF

# 

