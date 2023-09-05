resource "aws_instance" "jump_server" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                      = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.js_security_group_id]
  associate_public_ip_address = true
  tags = {
    Name = "${var.name_prefix}-jump-server"
  }
}

#Parameter Store
resource "aws_ssm_parameter" "jump_server_ips" {
  name        = "jump_server-ip"
  type        = "String"
  value       = aws_instance.jump_server.public_ip
  description = "Jump Server IP addresses"
}

resource "aws_instance" "database_server" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                      = var.key_name
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.db_security_group_id]
  user_data                   = var.db_user_data

  tags = {
    Name = "${var.name_prefix}-database-server"
  }
}

# Define parameter store resource
resource "aws_ssm_parameter" "database_ip" {
  name        = "database-ip"
  type        = "String"
  value       = aws_instance.database_server.private_ip
  description = "IP address of the database server"
}

# Define secrets manager resource
resource "aws_secretsmanager_secret" "database_credentials" {
  name = "db-cred"
}

resource "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id     = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = "root",
    password = var.db_password
  })
}
