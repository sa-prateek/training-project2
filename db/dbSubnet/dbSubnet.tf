variable "subnet_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
}

output "db_subnet_group_name" {
    value = aws_db_subnet_group.private_db_subnet_group.name
}