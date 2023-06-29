variable "vpc_id" {
  type = string
}

variable "route_table_name" {
  type = string
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.route_table_name
  }
}

output "route_table_id" {
  value = aws_route_table.private_route_table.id
}
