variable "security_groups" {
    type = list(string)
}

variable "lb_name" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "load_balancer_type" {
    type = string
}

resource "aws_lb" "load_balancer" {
  name = var.lb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnet_ids
  security_groups = var.security_groups

  tags = {
    Name = var.lb_name
  }
}