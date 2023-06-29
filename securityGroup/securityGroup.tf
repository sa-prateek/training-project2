variable "security_group_name" {
  type = string
}

variable "ingress" {
  type = list(number)
}

variable "security_groups" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type = string
}

variable "cidr_block" {
  type    = list(string)
  default = []
}

resource "aws_security_group" "security_group" {
  name = var.security_group_name

  vpc_id = var.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress
    content {
      from_port       = port.value
      to_port         = port.value
      protocol        = "TCP"
      cidr_blocks     = var.cidr_block
      security_groups = length(var.security_groups) > 0 ? [var.security_groups[port.key]] : []
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.security_group.id
}
