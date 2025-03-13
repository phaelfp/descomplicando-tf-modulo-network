output "vpc_ids" {
  description = "IDs das VPCs criadas"
  value       = module.networks.vpc_ids
}

output "subnet_ids" {
  description = "IDs das sub-redes criadas, organizadas por VPC"
  value       = module.networks.subnet_ids
}
