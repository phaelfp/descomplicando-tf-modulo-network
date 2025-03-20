<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.91.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Região da AWS | `string` | `"us-east-1"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Lista de sub-redes a serem criadas, associadas a uma VPC pelo nome | <pre>list(object({<br/>    vpc_name   = string # Nome da VPC onde a sub-rede será criada<br/>    cidr_block = string<br/>    az         = string<br/>    is_public  = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | Lista de VPCs a serem criadas | <pre>list(object({<br/>    name       = string<br/>    cidr_block = string<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs das sub-redes criadas |
| <a name="output_vpc_ids"></a> [vpc\_ids](#output\_vpc\_ids) | IDs das VPCs criadas |
<!-- END_TF_DOCS -->