variable "vpc_id" {
  type = string
}

variable "route_table_name" {
  type = string
}
# variable "nat_id" {
#   type = string
# }

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   network_interface_id = var.nat_id
  # }
  
  tags = {
    Name = var.route_table_name
  }
}

output "route_table_id" {
  value = aws_route_table.private_route_table.id
}