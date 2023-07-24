output "private_key" {
  value     = module.ws_key.key_pair_pem
  sensitive = true
}