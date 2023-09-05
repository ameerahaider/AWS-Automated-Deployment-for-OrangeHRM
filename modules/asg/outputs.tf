data "aws_instances" "example" {
  instance_tags = {
    Name = "${var.name_prefix}-asg-instance"
  }
}

output "private_ips" {
  value = data.aws_instances.example.private_ips
}

output "test_output" {
  value = [for ip in data.aws_instances.example.private_ips : "${ip}"]
}

locals {
  private_ips_json = jsonencode(data.aws_instances.example.private_ips)
}

#Parameter Store
resource "aws_ssm_parameter" "private_ips" {
  name        = "private-ips"
  type        = "String"
  value       = local.private_ips_json
  description = "Private IP addresses of instances"
}