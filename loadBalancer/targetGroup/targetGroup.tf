variable "target_group_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "target_group_protocol" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "target_type" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_ids[count.index]
  port             = var.target_group_port
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn
}
