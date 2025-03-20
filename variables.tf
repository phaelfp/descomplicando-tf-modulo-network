variable "vpcs" {
  description = "Lista de VPCs a serem criadas"
  type = list(object({
    name       = string
    cidr_block = string
  }))
  default = []
}

variable "subnets" {
  description = "Lista de sub-redes a serem criadas, associadas a uma VPC pelo nome"
  type = list(object({
    vpc_name   = string # Nome da VPC onde a sub-rede será criada
    cidr_block = string
    az         = string
    is_public  = bool
  }))
  default = []
}
