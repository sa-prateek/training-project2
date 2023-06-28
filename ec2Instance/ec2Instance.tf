variable "instance_name" {
    type = list(string)
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
  type        = string
  default = ""
}

variable "source_dest_check" {
  type = bool
  default = true
}

resource "aws_instance" "ec2" {
  count = length(var.instance_name) 
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  security_groups = var.security_groups
  user_data = var.user_data
  tags = {
    Name = var.instance_name[count.index]
  }
  source_dest_check = var.source_dest_check
}

output instance_id {
  value = aws_instance.ec2[0].id
}

output private_ip {
  value = aws_instance.ec2[0].private_ip
}

output "network_interface_id" {
  value = aws_instance.ec2[0].primary_network_interface_id
}