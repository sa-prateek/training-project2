provider "aws" {
  region = "ap-south-1"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

module "vpc" {
  source         = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "tfvpc"
}

module "tf_igw" {
  source   = "./igw"
  vpc_id   = module.vpc.vpc_id
  igw_name = "tf_igw"
}

module "public_subnet_az1" {
  source            = "./publicSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.0.1.0/24"
  subnet_name       = "tf_public_subnet_az1"
  igw_id            = module.tf_igw.igw_id
  route_table_name  = "tf_public_subnet_route_table_az1"
}

module "public_subnet_az2" {
  source            = "./publicSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1b"
  cidr_block        = "10.0.2.0/24"
  subnet_name       = "tf_public_subnet_az2"
  igw_id            = module.tf_igw.igw_id
  route_table_name  = "tf_public_route_table_az2"
}

module "private_subnet_az1" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.0.3.0/24"
  subnet_name       = "tf_private_subnet_az1"
  route_table_name  = "tf_private_subnet_route_table_az1"
}

module "private_subnet_az2" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1b"
  cidr_block        = "10.0.4.0/24"
  subnet_name       = "tf_private_subnet_az2"
  route_table_name  = "tf_private_subnet_route_table_az2"
}

module "lb_security_group" {
  source              = "./securityGroup"
  ingress             = [80]
  cidr_block          = ["0.0.0.0/0"]
  vpc_id              = module.vpc.vpc_id
  security_group_name = "lb-SG"
}

module "jump_server_security_group" {
  source              = "./securityGroup"
  ingress             = [22]
  cidr_block          = ["0.0.0.0/0"]
  vpc_id              = module.vpc.vpc_id
  security_group_name = "Jump-Server-SG"
}

module "jump_server" {
  source          = "./ec2Instance"
  instance_name   = "jumpServer"
  ami             = "ami-03b31136fc503b84a"
  instance_type   = "t2.micro"
  key_name        = "jenkinsAs"
  subnet_id       = module.public_subnet_az1.subnet_id
  security_groups = [module.jump_server_security_group.security_group_id]
}

module "private_ec2_security_group_az1" {
  source              = "./securityGroup"
  ingress             = [22, 80]
  security_groups     = [module.jump_server_security_group.security_group_id, module.lb_security_group.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = "Internal-Traffic-SG1"
}

module "private_ec2_security_group_az2" {
  source              = "./securityGroup"
  ingress             = [22, 80]
  security_groups     = [module.jump_server_security_group.security_group_id, module.lb_security_group.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = "Internal-Traffic-SG2"
}

module "private_ec2_instance_az1" {
  source          = "./ec2Instance"
  instance_name   = "tfvm1"
  ami             = "ami-0cde9c0bc19ae4a39"
  instance_type   = "t2.micro"
  key_name        = "jenkinsAs"
  user_data       = <<-EOF
  #!/bin/bash
  sudo systemctl start mariadb
  echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF
  subnet_id       = module.private_subnet_az1.subnet_id
  security_groups = [module.private_ec2_security_group_az1.security_group_id]
}

module "private_ec2_instance_az2" {
  source          = "./ec2Instance"
  instance_name   = "tfvm2"
  ami             = "ami-0cde9c0bc19ae4a39"
  instance_type   = "t2.micro"
  key_name        = "jenkinsAs"
  user_data       = <<-EOF
  #!/bin/bash
  sudo systemctl start mariadb
  echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF
  subnet_id       = module.private_subnet_az2.subnet_id
  security_groups = [module.private_ec2_security_group_az2.security_group_id]
}

module "db_private_subnet_az1" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.0.5.0/24"
  subnet_name       = "tf_db_private_subnet_az1"
  route_table_name  = "tf_db_private_subnet_route_table_az1"
}

module "db_private_subnet_az2" {
  source            = "./privateSubnet"
  vpc_id            = module.vpc.vpc_id
  availability_zone = "ap-south-1b"
  cidr_block        = "10.0.6.0/24"
  subnet_name       = "tf_db_private_subnet_az2"
  route_table_name  = "tf_db_private_subnet_route_table_az2"
}

module "db_security_group_az1" {
  source              = "./securityGroup"
  ingress             = [3306, 3306]
  security_groups     = [module.private_ec2_security_group_az1.security_group_id, module.private_ec2_security_group_az2.security_group_id]
  vpc_id              = module.vpc.vpc_id
  security_group_name = "db-SG"
}

module "db_instance" {
  source               = "./db"
  username             = var.db_username
  password             = var.db_password
  name                 = "db-instance"
  identifier           = "db"
  instance_class       = "db.t3.micro"
  engine               = "mariadb"
  engine_version       = "10.5.18"
  port                 = 3306
  allocated_storage    = 10
  storage_type         = "gp2"
  db_subnet_group_name = "db_subnet_group"
  db_subnet_ids        = [module.db_private_subnet_az1.subnet_id, module.db_private_subnet_az2.subnet_id]
  security_group_ids   = [module.db_security_group_az1.security_group_id]
}

module "lb" {
  source             = "./loadBalancer"
  lb_name            = "tf-lb"
  security_groups    = [module.lb_security_group.security_group_id]
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = [module.public_subnet_az1.subnet_id, module.public_subnet_az2.subnet_id]
  load_balancer_type = "application"
  instance_ids       = [module.private_ec2_instance_az1.instance_id, module.private_ec2_instance_az2.instance_id]
  port               = 80
  protocol           = "HTTP"
  target_type        = "instance"
  target_group_name  = "lb-target-group"
  routing_action     = "forward"
}
