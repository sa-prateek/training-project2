variable "vpc_id" {
  type = string
}

variable "igw_name" {
  type = string
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.igw_name
  }
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
