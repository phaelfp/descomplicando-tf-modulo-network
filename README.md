# Projeto de Conclusão de Curso do Descomplicando Terraform

## Modulo de Redes (networks)

Este módulo é responsável por criar uma VPC e pelo menos 1 sub rede.

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

terraform init

terraform apply -auto-approve
#   d e s c o m p l i c a n d o - t f - m o d u l o - n e t w o r k  
 