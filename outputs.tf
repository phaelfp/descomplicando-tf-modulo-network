output "vpc_ids" {
  description = "IDs das VPCs criadas"
  value       = { for vpc in aws_vpc.this : vpc.tags.Name => vpc.id }
}

output "subnet_ids" {
  description = "IDs das sub-redes criadas"
  value       = { for subnet in aws_subnet.this : subnet.tags.Name => subnet.id }
}
