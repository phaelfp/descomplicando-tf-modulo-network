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
