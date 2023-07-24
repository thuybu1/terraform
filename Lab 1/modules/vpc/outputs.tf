output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}

output "private_subnet" {
  value = aws_subnet.private_subnet
}
