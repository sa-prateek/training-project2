variable "vpc_id" {
    type = string
}

variable "availability_zone" {
    type = string
}

variable "subnet_name" {
    type = string
}

variable "cidr_block" {
    type = string
}

variable "igw_id" {
    type = string
}

variable "route_table_name" {
    type = string
}

module "route_table" {
  source = "./routetable"
  vpc_id = var.vpc_id
  igw_id = var.igw_id
  route_table_name = var.route_table_name
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = module.route_table.route_table_id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}