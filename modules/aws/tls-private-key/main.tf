resource "tls_private_key" "tls-private-key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}