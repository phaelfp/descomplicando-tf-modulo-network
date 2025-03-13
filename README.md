# Projeto de Conclusão de Curso do Descomplicando Terraform

## Modulo de Redes (networks)

Este módulo é responsável por criar uma VPC e pelo menos 1 sub rede.

A documentação do módulo gerada pelo terraform-docs se encontra [aqui](README.TF.md)

## Exemplo de uso

Tem um exemplo completo do uso no diretório exemple caso queira ir logo para a parte prática.

Precisamos da seguinte estrutura de arquivos.

```css
│── main.tf
│── provider.tf
│── variables.tf
│── outputs.tf
```

### provider.tf

```tf
terraform {
  backend "s3" {
    bucket         = "meu-terraform-backend"
    key            = "terraform-network-example/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-network-example-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

```

Não se esqueça que o bucket s3 e o dynamodb tem que existir para funcionar.

### variavles.tf

```tf
variable "aws_region" {
  default = "us-east-1"
}

variable "vpcs" {
  default = [
    { name = "Producao", cidr_block = "10.0.0.0/16" },
    { name = "Staging", cidr_block = "10.1.0.0/16" }
  ]
}

variable "subnets" {
  default = [
    { vpc_name = "Producao", cidr_block = "10.0.1.0/24", az = "us-east-1a", is_public = true },
    { vpc_name = "Producao", cidr_block = "10.0.2.0/24", az = "us-east-1b", is_public = false },
    { vpc_name = "Staging", cidr_block = "10.1.1.0/24", az = "us-east-1a", is_public = false }
  ]
}
```

Temos aqui 3 variáveis uma para idendificar a região que a VPC será criada.

Uma lista de VPCs, onde a VPC é um objeto com duas propriedades, uma nome e outra bloco da rede.

Uma lista de sub redes onde a sub rede é um objeto com 4 propriedades,

- nome da vpc que ela será criada
- bloco de rede da sub rede
- az
- se a subrede é publica ou não

### main.tf

```tf
module "networks" {
  source   = "../"
  aws_region = var.aws_region
  vpcs       = var.vpcs
  subnets    = var.subnets
}


output "subnet_ids" {
  value = module.networks.subnet_ids
}

```

Este main.tf o source está apontando para a pasta raiz, mas se você estiver já utilizando o módulo em outro utilize o código abaixo que está apontando para o repositório git

```tf
module "networks" {
  source   = "github.com/phaelfp/descomplicando-tf-modulo-network?ref=v1.0.0"

  aws_region = var.aws_region
  vpcs       = var.vpcs
  subnets    = var.subnets
}


output "subnet_ids" {
  value = module.networks.subnet_ids
}

```

### output.tf

```tf
output "vpc_ids" {
  description = "IDs das VPCs criadas"
  value       = module.networks.vpc_ids
}

output "subnet_ids" {
  description = "IDs das sub-redes criadas, organizadas por VPC"
  value       = module.networks.subnet_ids
}

```

### Execução

Tendo as chaves de acesso a AWS configuradas no terminal corretamente é só executar os comando abaixo.

```sh
terraform init
terraform plan -out tfplan
terraform apply "tfplan"
```

A saida do Output da execução do terraform será mais ou menos assim.

```sh
Outputs:

vpc_ids = {
  "Producao" = "vpc-0a1b2c3d4e5f6g7h"
  "Staging" = "vpc-1a2b3c4d5e6f7g8h"
}

subnet_ids = {
  "Subnet-Producao-0" = "subnet-1234567890abcdef0"
  "Subnet-Producao-1" = "subnet-0987654321abcdef1"
  "Subnet-Staging-0" = "subnet-567890abcdef1234"
}

```

Se for necessário, por exemplo, de criar uma sub rede publica em staging será necessário somente modificar o variables.tf.

```tf
variable "subnets" {
  default = [
    { vpc_name = "Producao", cidr_block = "10.0.1.0/24", az = "us-east-1a", is_public = true },
    { vpc_name = "Producao", cidr_block = "10.0.2.0/24", az = "us-east-1b", is_public = false },
    { vpc_name = "Staging", cidr_block = "10.1.1.0/24", az = "us-east-1a", is_public = false },
    { vpc_name = "Staging", cidr_block = "10.1.2.0/24", az = "us-east-1b", is_public = true }  # NOVA SUB-REDE
  ]
}

```

```sh
terraform init
terraform plan -out tfplan
terraform apply "tfplan"
```

A saida do Output da execução do terraform será mais ou menos assim.

```sh
Outputs:

vpc_ids = {
  "Producao" = "vpc-0a1b2c3d4e5f6g7h"
  "Staging" = "vpc-1a2b3c4d5e6f7g8h"
}

subnet_ids = {
  "Subnet-Producao-0" = "subnet-1234567890abcdef0"
  "Subnet-Producao-1" = "subnet-0987654321abcdef1"
  "Subnet-Staging-0" = "subnet-567890abcdef1234"
  "Subnet-Staging-1" = "subnet-abcdef1234567890"
}

```

