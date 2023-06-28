variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

resource "aws_vpc" "tfvpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
    value = aws_vpc.tfvpc.id
}