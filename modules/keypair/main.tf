resource "tls_private_key" "my_keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-kp"
  public_key = tls_private_key.my_keypair.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.my_keypair.private_key_pem}' > my-kp.pem
      chmod 400 my-kp.pem
    EOT
  }
}

# Define parameter store resource
resource "aws_ssm_parameter" "public_key" {
  name        = "pub_key"
  type        = "String"
  value       = tls_private_key.my_keypair.public_key_openssh
  description = "Public Key of the Ec2 Instances"
}

resource "aws_ssm_parameter" "private_key" {
  name        = "priv_key"
  type        = "String"
  value       = tls_private_key.my_keypair.private_key_pem
  description = "Private Key of the Ec2 Instances"
}