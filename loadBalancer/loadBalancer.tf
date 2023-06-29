variable "security_groups" {
  type = list(string)
}

variable "lb_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "load_balancer_type" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}

variable "port" {
  type = string
}

variable "protocol" {
  type = string
}

variable "target_type" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "routing_action" {
  type = string
}

module "target_group" {
  source                = "./targetGroup"
  vpc_id                = var.vpc_id
  target_type           = var.target_type
  target_group_name     = var.target_group_name
  target_group_port     = var.port
  target_group_protocol = var.protocol
  instance_ids          = var.instance_ids
}

resource "aws_lb" "lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnet_ids
  security_groups    = var.security_groups
  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = var.routing_action
    target_group_arn = module.target_group.target_group_arn
  }
}
