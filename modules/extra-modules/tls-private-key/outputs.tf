output "private_key" {
  value     = tls_private_key.tls-private-key.private_key_pem
  sensitive = true
}

output "public_key" {
  value     = tls_private_key.tls-private-key.public_key_openssh
  sensitive = true
} 