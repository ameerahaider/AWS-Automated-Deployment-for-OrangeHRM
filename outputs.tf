output "private_key_pem" {
  value = module.keypair.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = module.keypair.public_key_openssh
  sensitive = true
}

output "load_balancer_dns_name" {
  value = module.alb.alb_dns_name
}

output "jump_server_public_ip" {
  description = "Public IP of the jump server"
  value       = module.servers.jump_server_public_ip
}

output "private_ips" {
  description = "The public IP addresses of the instances in the autoscaling group"
  value       = module.asg.test_output
}
