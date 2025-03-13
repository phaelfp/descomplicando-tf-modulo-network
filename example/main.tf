module "networks" {
  source   = "../"
  aws_region = var.aws_region
  vpcs       = var.vpcs
  subnets    = var.subnets
}

output "subnet_ids" {
  value = module.networks.subnet_ids
}
