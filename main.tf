# Variables
#############################################################

variable "region" {
  type = string
}

variable "availability_zone1" {
  type = string
}

variable "availability_zone2" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "public_subnet_az1_cidr" {
  type = string
}

variable "public_subnet_az1_name" {
  type = string
}

variable "public_route_table_az1_name" {
  type = string
}

variable "public_subnet_az2_cidr" {
  type = string
}

variable "public_subnet_az2_name" {
  type = string
}

variable "public_route_table_az2_name" {
  type = string
}

variable "private_subnet_az1_cidr" {
  type = string
}

variable "private_subnet_az1_name" {
  type = string
}

variable "private_route_table_az1_name" {
  type = string
}

variable "private_subnet_az2_cidr" {
  type = string
}

variable "private_subnet_az2_name" {
  type = string
}

variable "private_route_table_az2_name" {
  type = string
}

variable "lb_ingress_port" {
  type = number
}

variable "lb_cidr_blocks" {
  type = list(string)
}

variable "lb_security_group_name" {
  type = string
}

variable "jump_server_ingress_port" {
  type = number
}

variable "jump_server_cidr_blocks" {
  type = list(string)
}

variable "jump_server_security_group_name" {
  type = string
}

variable "jump_server_instance_name" {
  type = string
}

variable "jump_server_ami" {
  type = string
}

variable "jump_server_instance_type" {
  type = string
}

variable "jump_server_key_name" {
  type = string
}

variable "private_ec2_az1_ingress_ports" {
  type = list(number)
}

variable "private_ec2_az1_security_group_name" {
  type = string
}

variable "private_ec2_az2_ingress_ports" {
  type = list(number)
}

variable "private_ec2_az2_security_group_name" {
  type = string
}

variable "private_ec2_az1_instance_name" {
  type = string
}

variable "private_ec2_az1_ami" {
  type = string
}

variable "private_ec2_az1_instance_type" {
  type = string
}

variable "private_ec2_az1_key_name" {
  type = string
}

variable "private_ec2_az2_instance_name" {
  type = string
}

variable "private_ec2_az2_ami" {
  type = string
}

variable "private_ec2_az2_instance_type" {
  type = string
}

variable "private_ec2_az2_key_name" {
  type = string
}

variable "private_ec2_instance_user_data" {
  type = string
}

variable "db_private_subnet_az1_cidr" {
  type = string
}

variable "db_private_subnet_az1_name" {
  type = string
}

variable "db_private_route_table_az1_name" {
  type = string
}

variable "db_private_subnet_az2_cidr" {
  type = string
}

variable "db_private_subnet_az2_name" {
  type = string
}

variable "db_private_route_table_az2_name" {
  type = string
}

variable "db_security_group_az1_ingress_ports" {
  type = list(number)
}

variable "db_security_group_az1_name" {
  type = string
}

variable "db_instance_username" {
  type = string
}

variable "db_instance_password" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_instance_identifier" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_instance_engine" {
  type = string
}

variable "db_instance_engine_version" {
  type = string
}

variable "db_instance_port" {
  type = number
}

variable "db_instance_allocated_storage" {
  type = number
}

variable "db_instance_storage_type" {
  type = string
}

variable "db_instance_skip_final_snapshot" {
  type = bool
}

variable "db_instance_publicly_accessible" {
  type = bool
}

variable "db_instance_subnet_group_name" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "lb_load_balancer_type" {
  type = string
}

variable "lb_port" {
  type = number
}

variable "lb_protocol" {
  type = string
}

variable "lb_target_type" {
  type = string
}

variable "lb_target_group_name" {
  type = string
}

variable "lb_routing_action" {
  type = string
}

# Resources
#############################################################

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
}

module "tf_igw" {
  source   = "./igw"
  vpc_id   = module.vpc.vpc_id
  igw_name = var.igw_name
}

module "public_subnet_az1" {
  source            = "./publicSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone1
  cidr_block        = var.public_subnet_az1_cidr
  subnet_name       = var.public_subnet_az1_name
  igw_id            = module.tf_igw.igw_id
  route_table_name  = var.public_route_table_az1_name
}

module "public_subnet_az2" {
  source            = "./publicSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone2
  cidr_block        = var.public_subnet_az2_cidr
  subnet_name       = var.public_subnet_az2_name
  igw_id            = module.tf_igw.igw_id
  route_table_name  = var.public_route_table_az2_name
}

module "private_subnet_az1" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone1
  cidr_block        = var.private_subnet_az1_cidr
  subnet_name       = var.private_subnet_az1_name
  route_table_name  = var.private_route_table_az1_name
}

module "private_subnet_az2" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone2
  cidr_block        = var.private_subnet_az2_cidr
  subnet_name       = var.private_subnet_az2_name
  route_table_name  = var.private_route_table_az2_name
}

module "lb_security_group" {
  source              = "./securityGroup"
  ingress             = [var.lb_ingress_port]
  cidr_block          = var.lb_cidr_blocks
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.lb_security_group_name
}

module "jump_server_security_group" {
  source              = "./securityGroup"
  ingress             = [var.jump_server_ingress_port]
  cidr_block          = var.jump_server_cidr_blocks
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.jump_server_security_group_name
}

module "private_ec2_security_group_az1" {
  source              = "./securityGroup"
  ingress             = var.private_ec2_az1_ingress_ports
  security_groups     = [module.jump_server_security_group.security_group_id, module.lb_security_group.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.private_ec2_az1_security_group_name
}

module "private_ec2_security_group_az2" {
  source              = "./securityGroup"
  ingress             = var.private_ec2_az2_ingress_ports
  security_groups     = [module.jump_server_security_group.security_group_id, module.lb_security_group.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.private_ec2_az2_security_group_name
}

module "jump_server" {
  source          = "./ec2Instance"
  instance_name   = var.jump_server_instance_name
  ami             = var.jump_server_ami
  instance_type   = var.jump_server_instance_type
  key_name        = var.jump_server_key_name
  subnet_id       = module.public_subnet_az1.subnet_id
  security_groups = [module.jump_server_security_group.security_group_id]
}

module "private_ec2_instance_az1" {
  source          = "./ec2Instance"
  instance_name   = var.private_ec2_az1_instance_name
  ami             = var.private_ec2_az1_ami
  instance_type   = var.private_ec2_az1_instance_type
  key_name        = var.private_ec2_az1_key_name
  user_data       = var.private_ec2_instance_user_data
  subnet_id       = module.private_subnet_az1.subnet_id
  security_groups = [module.private_ec2_security_group_az1.security_group_id]
}

module "private_ec2_instance_az2" {
  source          = "./ec2Instance"
  instance_name   = var.private_ec2_az2_instance_name
  ami             = var.private_ec2_az2_ami
  instance_type   = var.private_ec2_az2_instance_type
  key_name        = var.private_ec2_az2_key_name
  user_data       = var.private_ec2_instance_user_data
  subnet_id       = module.private_subnet_az2.subnet_id
  security_groups = [module.private_ec2_security_group_az2.security_group_id]
}

module "db_private_subnet_az1" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone1
  cidr_block        = var.db_private_subnet_az1_cidr
  subnet_name       = var.db_private_subnet_az1_name
  route_table_name  = var.db_private_route_table_az1_name
}

module "db_private_subnet_az2" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = var.availability_zone2
  cidr_block        = var.db_private_subnet_az2_cidr
  subnet_name       = var.db_private_subnet_az2_name
  route_table_name  = var.db_private_route_table_az2_name
}

module "db_security_group_az1" {
  source              = "./securityGroup"
  ingress             = var.db_security_group_az1_ingress_ports
  security_groups     = [module.private_ec2_security_group_az1.security_group_id, module.private_ec2_security_group_az2.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = var.db_security_group_az1_name
}

module "db_instance" {
  source               = "./db"
  username             = var.db_instance_username
  password             = var.db_instance_password
  name                 = var.db_instance_name
  identifier           = var.db_instance_identifier
  instance_class       = var.db_instance_class
  engine               = var.db_instance_engine
  engine_version       = var.db_instance_engine_version
  port                 = var.db_instance_port
  allocated_storage    = var.db_instance_allocated_storage
  storage_type         = var.db_instance_storage_type
  skip_final_snapshot  = var.db_instance_skip_final_snapshot
  publicly_accessible  = var.db_instance_publicly_accessible
  db_subnet_group_name = var.db_instance_subnet_group_name
  db_subnet_ids        = [module.db_private_subnet_az1.subnet_id, module.db_private_subnet_az2.subnet_id]
  security_group_ids   = [module.db_security_group_az1.security_group_id]
}

module "lb" {
  source             = "./loadBalancer"
  lb_name            = var.lb_name
  security_groups    = [module.lb_security_group.security_group_id]
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [module.public_subnet_az1.subnet_id, module.public_subnet_az2.subnet_id]
  load_balancer_type = var.lb_load_balancer_type
  instance_ids       = [module.private_ec2_instance_az1.instance_id, module.private_ec2_instance_az2.instance_id]
  port               = var.lb_port
  protocol           = var.lb_protocol
  target_type        = var.lb_target_type
  target_group_name  = var.lb_target_group_name
  routing_action     = var.lb_routing_action
}
