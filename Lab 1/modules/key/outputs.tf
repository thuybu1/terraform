output "key_name" {
  value = module.key_pair.key_pair_name
}

output "key_pair_pem" {
  value = module.key_pair.private_key_pem
  sensitive = true
}