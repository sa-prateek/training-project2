variable "instance_name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "user_data" {
  type    = string
  default = ""
}

resource "aws_instance" "ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = var.key_name
  security_groups = var.security_groups
  user_data       = var.user_data
  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.ec2.id
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}

output "network_interface_id" {
  value = aws_instance.ec2.primary_network_interface_id
}
