module "networks" {
  source  = "../"
  vpcs    = var.vpcs
  subnets = var.subnets
}

output "subnet_ids" {
  value = module.networks.subnet_ids
}
