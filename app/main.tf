variable "region" {
  type = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {  # this is not being used right now
  type = string
  default = "10.0.0.0/24"
}

variable "vpc_name" { # required
  type = string
}

variable "vpc_tag" { # required
  type = string
}

variable "subnet_name" { # required
  type = string
}

variable "zonecount" {
  type = number
  default = 3
  description = "Number of subnet zones to be created"
  # validation {
  #   condition = var.zonecount < 1 && var.zonecount > 4
  #   error_message = "Please enter value between 1 to 4."
  # }
}

variable "startindex" {
  type = number
  default = 0
  description = "Start index of second octet in subnet cidr block"
}

# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}

variable "gateway_name" { # required
  type = string
}

variable "route_table_name" { # required
  type = string
}

variable "route_table_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "application_security_group_name" { # required
  type = string
}

variable "database_security_group_name" { # required
  type = string
}

variable "s3_bucket_name" { # required
  type = string
}

variable "db_identifier" { # required
  type = string
}

variable "db_username" { # required
  type = string
}

variable "db_password" { # required
  type = string
}

variable "db_name" { # required
  type = string
}

# VPC
resource "aws_vpc" "vpc" {  # vpc here is the reference for further usage in this file
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink_dns_support = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = var.vpc_name # vpc would be created with this name
    vpc_tag = var.vpc_tag
  }
}

# Subnets
resource "aws_subnet" "subnet" {
  count = var.zonecount
  # cidr_block = var.subnet_cidr_block
  cidr_block = "10.${var.startindex}.${10+count.index}.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.gateway_name # gateway would be created with this name
  }
}

# Routing table for public subnets
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table_cidr_block  #keeping this static according to assignment
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = var.route_table_name # route_table would be created with this name
  }
}

resource "aws_route_table_association" "route" {
  count = var.zonecount
  subnet_id = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.route_table.id
}

# Security groups: application and db
resource "aws_security_group" "application" {
  name        = var.application_security_group_name
  description = "Allow Node app inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  }

  ingress {
    description = "HTTP default"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  }

  ingress {
    description = "TLS from VPC for Node"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  }

  ingress {
    description = "Node default"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  }

  # allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "node_app_security_rule"
  }
}

resource "aws_security_group" "database" {
  name        = var.database_security_group_name
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    
    # cidr_blocks = [aws_vpc.vpc.cidr_block]
    # Ref: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#SecurityGroupRule
    security_groups = [
      aws_security_group.application.id,
    ]
  }

  # allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql_security_rule"
  }
}

# S3 bucket
resource "aws_kms_key" "mykey" {
  description = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "s3b" {
  bucket = var.s3_bucket_name
  acl = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    # expiration {
    #   days = 90
    # }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = {
    Name = "S3 bucket"
    # Environment = "dev"
  }
}

# RDS instance
resource "aws_db_instance" "db" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  multi_az = false
  identifier = var.db_identifier
  username = var.db_username
  password = var.db_password
  count = var.zonecount
  db_subnet_group_name = aws_subnet.subnet[count.index].id
  publicly_accessible = false
  name = var.db_name

  vpc_security_group_ids = [aws_security_group.database.id]

  allocated_storage    = 20
  storage_type         = "gp2"
  parameter_group_name = "default.mysql5.7"
}

# EC2 instance specifying AMI
resource "aws_instance" "ec2" {
  name = var.ec2_instance_name
  ami = var.ami_id
  instance_type = "t2.micro"
  disable_api_termination = false
  associate_public_ip_address = true

  count = var.zonecount
  # subnet_id = aws_subnet.subnet[count.index].id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  vpc_security_group_ids = [aws_security_group.application.id]


  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
      delete_on_termination = true
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdh"
      volume_type = "gp2"
      volume_size = 20
      delete_on_termination = true
    }
  ]

  # user_data = "${file("../../tmp/aws/userdata.sh")}"

  

  # tags = {
  #   "Env"      = "Private"
  #   "Location" = "Secret"
  # }

  # network_interface {
  #   network_interface_id = "${aws_network_interface.foo.id}"
  #   device_index         = 0
  # }

  # credit_specification {
  #   cpu_credits = "unlimited"
  # }
}

# resource "aws_ebs_volume" "ec2_ebs" {
#   count = var.zonecount
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   size = 20
# }

# resource "aws_volume_attachment" "ec2_ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.ec2_ebs.id
#   instance_id = aws_instance.ec2.id
#   type = "gp2" # (Default: "gp2")
# }