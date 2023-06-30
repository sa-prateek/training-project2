# Provider
region = "ap-south-1"

# Availability Zones
availability_zone1 = "ap-south-1a"
availability_zone2 = "ap-south-1b"

# Module: vpc
vpc_cidr_block = "10.0.0.0/16"
vpc_name       = "tfvpc"

# Module: tf_igw
igw_name = "tf_igw"

# Module: public_subnet_az1
public_subnet_az1_cidr      = "10.0.1.0/24"
public_subnet_az1_name      = "tf_public_subnet_az1"
public_route_table_az1_name = "tf_public_subnet_route_table_az1"

# Module: public_subnet_az2
public_subnet_az2_cidr      = "10.0.2.0/24"
public_subnet_az2_name      = "tf_public_subnet_az2"
public_route_table_az2_name = "tf_public_subnet_route_table_az2"

# Module: private_subnet_az1
private_subnet_az1_cidr      = "10.0.3.0/24"
private_subnet_az1_name      = "tf_private_subnet_az1"
private_route_table_az1_name = "tf_private_subnet_route_table_az1"

# Module: private_subnet_az2
private_subnet_az2_cidr      = "10.0.4.0/24"
private_subnet_az2_name      = "tf_private_subnet_az2"
private_route_table_az2_name = "tf_private_subnet_route_table_az2"

# Module: lb_security_group
lb_ingress_port        = 80
lb_cidr_blocks         = ["0.0.0.0/0"]
lb_security_group_name = "lb-SG"

# Module: jump_server_security_group
jump_server_ingress_port        = 22
jump_server_cidr_blocks         = ["0.0.0.0/0"]
jump_server_security_group_name = "Jump-Server-SG"

# Module: jump_server
jump_server_instance_name = "jumpServer"
jump_server_ami           = "ami-03b31136fc503b84a"
jump_server_instance_type = "t2.micro"
jump_server_key_name      = "jenkinsAs"

# Module: private_ec2_security_group_az1
private_ec2_az1_ingress_ports       = [22, 80]
private_ec2_az1_security_group_name = "Internal-Traffic-SG1"

# Module: private_ec2_security_group_az2
private_ec2_az2_ingress_ports       = [22, 80]
private_ec2_az2_security_group_name = "Internal-Traffic-SG2"

# Module: private_ec2_instance_az1
private_ec2_az1_instance_name = "tf-PrivateVM1"
private_ec2_az1_ami           = "ami-0cde9c0bc19ae4a39"
private_ec2_az1_instance_type = "t2.micro"
private_ec2_az1_key_name      = "jenkinsAs"

# Module: private_ec2_instance_az2
private_ec2_az2_instance_name = "tf-PrivateVM2"
private_ec2_az2_ami           = "ami-0cde9c0bc19ae4a39"
private_ec2_az2_instance_type = "t2.micro"
private_ec2_az2_key_name      = "jenkinsAs"

# Private Instance: user data
private_ec2_instance_user_data = <<-EOF
  #!/bin/bash
  sudo systemctl start mariadb
  echo "<h1>Hello from Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

# Module: db_private_subnet_az1
db_private_subnet_az1_cidr      = "10.0.5.0/24"
db_private_subnet_az1_name      = "tf_db_private_subnet_az1"
db_private_route_table_az1_name = "tf_db_private_subnet_route_table_az1"

# Module: db_private_subnet_az2
db_private_subnet_az2_cidr      = "10.0.6.0/24"
db_private_subnet_az2_name      = "tf_db_private_subnet_az2"
db_private_route_table_az2_name = "tf_db_private_subnet_route_table_az2"

# Module: db_security_group_az1
db_security_group_az1_ingress_ports = [3306, 3306]
db_security_group_az1_name          = "db-SG"

# Module: db_instance
db_instance_username            = "admin"
db_instance_password            = "admin123"
db_instance_name                = "db-instance"
db_instance_identifier          = "db"
db_instance_class               = "db.t3.micro"
db_instance_engine              = "mariadb"
db_instance_engine_version      = "10.5.18"
db_instance_port                = 3306
db_instance_allocated_storage   = 10
db_instance_storage_type        = "gp2"
db_instance_skip_final_snapshot = true
db_instance_publicly_accessible = false
db_instance_subnet_group_name   = "db_subnet_group"

# Module: lb
lb_name               = "tf-lb"
lb_load_balancer_type = "application"
lb_port               = 80
lb_protocol           = "HTTP"
lb_target_type        = "instance"
lb_target_group_name  = "lb-target-group"
lb_routing_action     = "forward"
