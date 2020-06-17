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

variable "subnet_group_name" { # required
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

variable "ec2_instance_name" { # required
  type = string
}

variable "ami_id" { # required
  type = string
}

variable "pub_key" { # required
  type = string
}

variable "s3_iam_profile_name" { # required
  type = string
}

variable "s3_iam_role_name" { # required
  type = string
}

variable "s3_iam_policy_name" { # required
  type = string
}
# variables end

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

resource "aws_s3_bucket" "kinnars_bucket" {
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
resource "aws_db_subnet_group" "db_subnet_group" {
  name = var.subnet_group_name
  subnet_ids  = aws_subnet.subnet.*.id
}

resource "aws_db_instance" "mysqldb" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  multi_az = false
  identifier = var.db_identifier
  username = var.db_username
  password = var.db_password
  port = 3306
  db_subnet_group_name =  aws_db_subnet_group.db_subnet_group.name
  publicly_accessible = false
  name = var.db_name

  vpc_security_group_ids = [aws_security_group.database.id]

  allocated_storage    = 20
  storage_type         = "gp2"
  parameter_group_name = "default.mysql5.7"

  skip_final_snapshot = true
}

# Pub key for aws key pair
resource "aws_key_pair" "publickey" {
  key_name   = "public-key"
  public_key = var.pub_key
}

# EC2 instance specifying AMI
resource "aws_instance" "ec2" {
  # name = var.ec2_instance_name
  ami = var.ami_id
  instance_type = "t2.micro"
  disable_api_termination = false
  associate_public_ip_address = true

  subnet_id = aws_subnet.subnet[0].id
  # count = var.zonecount
  # availability_zone = data.aws_availability_zones.available.names[count.index]

  vpc_security_group_ids = [aws_security_group.application.id]

  key_name = aws_key_pair.publickey.key_name

  root_block_device {   
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = true
  }

  user_data = <<-EOF
                #!/bin/bash
                echo "DBName=${var.db_name}" >> /etc/environment
                echo "DBUser=${var.db_username}" >> /etc/environment
                echo "DBHost=${aws_db_instance.mysqldb.address}" >> /etc/environment
                echo "DBPort=${aws_db_instance.mysqldb.port}" >> /etc/environment
                echo "DBPassword=${var.db_password}" >> /etc/environment
                echo "DBEndpoint=${aws_db_instance.mysqldb.endpoint}" >> /etc/environment
                echo "S3BucketName=${aws_s3_bucket.kinnars_bucket.id}" >> /etc/environment
                echo "S3BucketDomain=${aws_s3_bucket.kinnars_bucket.bucket_domain_name}" >> /etc/environment
                echo "S3BucketARN=${aws_s3_bucket.kinnars_bucket.arn}" >> /etc/environment
                EOF

  iam_instance_profile = aws_iam_instance_profile.s3_profile.name
}

# instance profile role policy and role-policy attachment
resource "aws_iam_instance_profile" "s3_profile" {
  name = var.s3_iam_profile_name
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = var.s3_iam_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name = var.s3_iam_policy_name
  description = "IAM policy for EC2 to access S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": 
  [
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListAllMyBuckets"
        ],
        "Resource": "arn:aws:s3:::*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ],
        "Resource": "arn:aws:s3:::${var.s3_bucket_name}"
    },
    {
        "Effect": "Allow",
        "Action": [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:GetObjectVersion",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion"
        ],
        "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-policy-attach" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name = "csye6225"
  hash_key = "id"
  billing_mode = "PAY_PER_REQUEST"
  read_capacity  = 5
  write_capacity = 5
  range_key = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}
