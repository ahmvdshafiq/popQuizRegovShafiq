output "instance_id" {
  description = "ID of the EC2 instance for dev environment"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance for dev environment"
  value       = module.compute.instance_public_ip
}
