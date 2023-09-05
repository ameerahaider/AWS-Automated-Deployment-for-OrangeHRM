output "private_key_pem" {
  value = tls_private_key.my_keypair.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.my_keypair.public_key_openssh
  sensitive = true
}