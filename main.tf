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
  source = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  vpc_name = "tfvpc"
}

module "tf_igw" {
  source = "./ig"
  vpc_id = module.vpc.vpc_id
  igw_name = "tf_igw"
}

module "public_subnet_az1" {
  source = "./publicSubnet"
  vpc_id = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.1.0/24"
  subnet_name = "tf_public_subnet_az1"
  igw_id = module.tf_igw.igw_id
  route_table_name = "tf_public_subnet_route_table_az1"
}

# module "public_subnet_az2" {
#   source = "./publicSubnet"
#   vpc_id = module.vpc.vpc_id
#   availability_zone = "ap-south-1b"
#   cidr_block = "10.0.2.0/24"
#   subnet_name = "tf_public_subnet_az2"
#   igw_id = module.tf_igw.igw_id
#   route_table_name = "tf_public_route_table_az2"
# }

# module "nat_security_group" {
#   source = "./securityGroup"
#   ingress = [22]
#   cidr_block = "0.0.0.0/0"
#   vpc_id = module.vpc.vpc_id
#   security_group_name = "NAT-Sg"
# }

# module "nat_instance" {
#   source = "./ec2Instance"
#   instance_name = ["NATInstance"]
#   ami = "ami-0cba71abc8c8312aa"
#   instance_type ="t2.micro"
#   key_name = "jenkinsAs"
#   subnet_id = module.public_subnet_az1.subnet_id
#   source_dest_check = false
#   security_groups = [ module.nat_security_group.security_group_id ]
# }

module "private_subnet_az1" {
  # depends_on = [ module.nat_instance ]
  source = "./privateSubnet"
  vpc_id = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.3.0/24"
  subnet_name = "tf_private_subnet_az1"
  route_table_name = "tf_private_subnet_route_table_az1"
  # nat_id = module.nat_instance.network_interface_id
}

module "private_ec2_security_group" {
  source = "./securityGroup"
  ingress = [22,80,3306]
  cidr_block = "0.0.0.0/0"
  vpc_id = module.vpc.vpc_id
  security_group_name = "Internal-Traffic-SG"
}

module "private_ec2_instance" {
  # depends_on = [ module.nat_instance ]
  source = "./ec2Instance"
  instance_name = ["tfvm1"]
  ami = "ami-0cde9c0bc19ae4a39"
  instance_type ="t2.micro"
  key_name = "jenkinsAs"
  user_data = <<-EOF
  #!/bin/bash
  sudo systemctl start mariadb
  EOF
  subnet_id = module.private_subnet_az1.subnet_id
  security_groups = [ module.private_ec2_security_group.security_group_id ]
}
 
module "jump_server_security_group" {
  source = "./securityGroup"
  ingress = [22,80]
  cidr_block = "0.0.0.0/0"
  vpc_id = module.vpc.vpc_id
  security_group_name = "Web Traffic"
}

module "jump_server" {
  source = "./ec2Instance"
  instance_name = ["jumpServer"]
  ami = "ami-03b31136fc503b84a"
  instance_type ="t2.micro"
  key_name = "jenkinsAs"
  subnet_id = module.public_subnet_az1.subnet_id
  security_groups = [ module.jump_server_security_group.security_group_id ]
}

module "db_private_subnet_az1" {
  source = "./privateSubnet"
  vpc_id = module.vpc.vpc_id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.5.0/24"
  subnet_name = "tf_db_private_subnet_az1"
  route_table_name = "tf_db_private_subnet_route_table_az1"
}

module "db_private_subnet_az2" {
  source = "./privateSubnet"
  vpc_id = module.vpc.vpc_id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.6.0/24"
  subnet_name = "tf_db_private_subnet_az2"
  route_table_name = "tf_db_private_subnet_route_table_az1"
}

/*
module "lb_security_group" {
  source = "./securityGroup"
  ingress = [80]
  cidr_block =["0.0.0.0/0"]
  vpc_id = module.vpc.vpc_id
}

module "lb" {
  source = "./loadBalancer"
  security_groups = [ module.lb_security_group.security_group_id ]
  load_balancer_type = "application"
  lb_name = "tf-lb"
  subnet_ids = [  module.public_subnet_az1.subnet_id ]
}
*/

# module "db_instance" {
#   source = "./db"
#   username = var.db_username
#   password = var.db_password
#   name = "db-instance"
#   identifier = "db"
#   instance_class = "db.t3.micro"
#   engine = "mariadb"
#   engine_version = "10.5.18"
#   port = 3306
#   allocated_storage = 10
#   storage_type = "gp2"
#   db_subnet_ids = [db_private_subnet_az1.subnet_id, db_private_subnet_az2.subnet_id]
#   security_group_ids = [module.private_ec2_security_group.security_group_id]
# }

# resource "aws_db_instance" "db_instance" {
#   allocated_storage    = 20
#   engine               = "mariadb"
#   engine_version       = "10.5"
#   instance_class       = "db.t2.micro"
#   name                 = "my-db-instance"
#   username             = "admin"
#   password             = "password"
#   db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
# }