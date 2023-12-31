variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}

variable "name" {
  type = string
}

variable "identifier" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "port" {
  type = number
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}

variable "publicly_accessible" {
  type = bool
}

variable "security_group_ids" {
  type = list(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_subnet_group_name" {
  type = string
}

module "db_subnet_group" {
  source               = "./dbSubnet"
  subnet_ids           = var.db_subnet_ids
  db_subnet_group_name = var.db_subnet_group_name
}

resource "aws_db_instance" "database" {
  identifier             = var.identifier
  instance_class         = var.instance_class
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.username
  password               = var.password
  port                   = var.port
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = module.db_subnet_group.db_subnet_group_name
  tags = {
    Name = var.name
  }
}
