# Criando VPCs conforme especificado na variável "vpcs"
resource "aws_vpc" "this" {
  count = length(var.vpcs)

  cidr_block = var.vpcs[count.index].cidr_block

  tags = {
    Name = var.vpcs[count.index].name
  }
}

# Obtendo VPCs existentes pelo nome (caso não sejam criadas pelo Terraform)
data "aws_vpc" "existing" {
  for_each = {
    for subnet in var.subnets :
    subnet.vpc_name => subnet if !contains([for v in var.vpcs : v.name], subnet.vpc_name)
  }

  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

# Criando Sub-redes e associando à VPC correta (nova ou existente)
resource "aws_subnet" "this" {
  count = length(var.subnets)

  vpc_id = coalesce(
    lookup({ for v in aws_vpc.this : v.tags.Name => v.id }, var.subnets[count.index].vpc_name, null),
    lookup({ for k, v in data.aws_vpc.existing : k => v.id }, var.subnets[count.index].vpc_name, null)
  )

  cidr_block        = var.subnets[count.index].cidr_block
  availability_zone = var.subnets[count.index].az

  tags = {
    Name = "Subnet-${var.subnets[count.index].vpc_name}-${count.index}"
  }
}
