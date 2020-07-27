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

variable "ec2_instance_type" { # required
  type = string
}

variable "pub_key" { # required
  type = string
}

variable "ec2_instance_tag" { # required
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

variable "s3_code_deploy_role_name" { # required
  type = string
}

variable "s3_code_deploy_policy_name" { # required
  type = string
}

variable "s3_code_deploy_bucket_name" { # required
  type = string
}

variable "circleci_user_name" { # required
  type = string
}

variable "circleci_upload_to_s3_policy_name" { # required
  type = string
}

variable "circleci_codedeploy_policy_name" { # required
  type = string
}

variable "aws_account_id" { # required
  type = string
}

variable "codedeploy_application_name" { # required
  type = string
}

variable "codedeploy_application_topic" { # required
  type = string
}

variable "codedeploy_application_group" { # required
  type = string
}

variable "circleci_ec2_ami_policy_name" { # required
  type = string
}

variable "route53_zone_id" { # required
  type = string
}

variable "route53_domain_name" { # required
  type = string
}

variable "cloudwatch_iam_policy_name" { # required
  type = string
}

variable "cloudwatch_log_group_name" { # required
  type = string
}

variable "log_retention_days" { # required
  type = number
}

variable "route53_root_domain_name" { # required
  type = string
}

variable "route53_root_zone_id" { # required
  type = string
}

variable "aws_launch_configuration_name" { # required
  type = string
}

variable "asg_name" { # required
  type = string
}

variable "asg_min_size" { # required
  type = number
}

variable "asg_max_size" { # required
  type = number
}

variable "asg_desired_capacity" { # required
  type = number
}

variable "asg_default_cooldown" { # required
  type = number
}

variable "asg_health_check_grace_period" { # required
  type = number
}

variable "asg_health_check_type" { # required
  type = string
}

variable "asg_policyup_adjustment" { # required
  type = number
}

variable "asg_policyup_adjustment_type" { # required
  type = string
}

variable "asg_policyup_cooldown" { # required
  type = number
}

variable "asg_policydown_adjustment" { # required
  type = number
}

variable "asg_policydown_adjustment_type" { # required
  type = string
}

variable "asg_policydown_cooldown" { # required
  type = number
}

variable "asg_cpu_alarm_high_period" { # required
  type = string
}

variable "asg_cpu_alarm_high_evaluation_periods" { # required
  type = string
}

variable "asg_cpu_alarm_high_threshold" { # required
  type = string
}

variable "asg_cpu_alarm_low_period" { # required
  type = string
}

variable "asg_cpu_alarm_low_evaluation_periods" { # required
  type = string
}

variable "asg_cpu_alarm_low_threshold" { # required
  type = string
}

variable "alb_name" { # required
  type = string
}

variable "alb_port" { # required
  type = number
}

variable "alb_server_port" { # required
  type = number
}

variable "alb_priority" { # required
  type = number
}

variable "alb_path" { # required
  type = string
}

variable "alb_target_group_name" { # required
  type = string
}

variable "alb_healthcheck_path" { # required
  type = string
}

variable "alb_healthcheck_healthy_threshold" { # required
  type = number
}

variable "alb_healthcheck_unhealthy_threshold" { # required
  type = number
}

variable "alb_healthcheck_timeout" { # required
  type = number
}

variable "alb_healthcheck_interval" { # required
  type = number
}

variable "lambda_source_file" { # required
  type = string
}

variable "lambda_output_path" { # required
  type = string
}

variable "sns_iam_policy_name" { # required
  type = string
}

variable "ses_lambda_iam_policy_name" { # required
  type = string
}

variable "dynamodb_lambda_iam_policy_name" { # required
  type = string
}

variable "circleci_lambda_iam_policy_name" { # required
  type = string
}

variable "alb_ssl_cirtificate_arn" { # required
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

# Below should only be used when launching single EC2 instance
  # ingress {
  #   description = "SSH"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  # }

  # ingress {
  #   description = "HTTP default"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  # }

  # ingress {
  #   description = "TLS from VPC for Node"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  # }

  # ingress {
  #   description = "Node default"
  #   from_port   = 3000
  #   to_port     = 3000
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  # }

  # Ingress only from load balancer
  ingress {
    description = "Node default from load balancer"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_security_group.id,
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

# S3 bucket. Using default AES256 so this is not used for now
resource "aws_kms_key" "mykey" {
  description = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "kinnars_bucket" {
  bucket = var.s3_bucket_name
  acl = "private"
  force_destroy = true

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
        # kms_master_key_id = aws_kms_key.mykey.arn
        # sse_algorithm = "aws:kms"
        sse_algorithm = "AES256"
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

  storage_encrypted = true
  ca_cert_identifier   = "rds-ca-2019"
  # performance insights not supported in t3 and t2 micro and small
  # performance_insights_enabled = true
}

# Pub key for aws key pair
resource "aws_key_pair" "publickey" {
  key_name   = "public-key"
  public_key = var.pub_key
}

# EC2 instance specifying AMI
# resource "aws_instance" "ec2" {
  ## name = var.ec2_instance_name
  # ami = var.ami_id
  # instance_type = var.ec2_instance_type
  # disable_api_termination = false
  # associate_public_ip_address = true

  # subnet_id = aws_subnet.subnet[0].id
  ## count = var.zonecount
  ## availability_zone = data.aws_availability_zones.available.names[count.index]

  # vpc_security_group_ids = [aws_security_group.application.id]

  # key_name = aws_key_pair.publickey.key_name

  # root_block_device {   
  #   volume_type = "gp2"
  #   volume_size = 20
  #   delete_on_termination = true
  # }

  # ebs_block_device {
  #   device_name = "/dev/sdh"
  #   volume_type = "gp2"
  #   volume_size = 20
  #   delete_on_termination = true
  # }

  # user_data = <<-EOF
  #               #!/bin/bash
  #               echo "DBName=${var.db_name}" >> /etc/environment
  #               echo "DBUser=${var.db_username}" >> /etc/environment
  #               echo "DBHost=${aws_db_instance.mysqldb.address}" >> /etc/environment
  #               echo "DBPort=${aws_db_instance.mysqldb.port}" >> /etc/environment
  #               echo "DBPassword=${var.db_password}" >> /etc/environment
  #               echo "DBEndpoint=${aws_db_instance.mysqldb.endpoint}" >> /etc/environment
  #               echo "S3BucketName=${aws_s3_bucket.kinnars_bucket.id}" >> /etc/environment
  #               echo "S3BucketDomain=${aws_s3_bucket.kinnars_bucket.bucket_domain_name}" >> /etc/environment
  #               echo "S3BucketARN=${aws_s3_bucket.kinnars_bucket.arn}" >> /etc/environment
  #               echo "IAMInstanceProfileName=${aws_iam_instance_profile.s3_profile.name}" >> /etc/environment
  #               echo "IAMInstanceProfileARN=${aws_iam_instance_profile.s3_profile.arn}" >> /etc/environment
  #               echo "IAMInstanceProfileID=${aws_iam_instance_profile.s3_profile.id}" >> /etc/environment
  #               echo "DEPLOYMENT_GROUP_NAME=production" >> /etc/environment
  #               echo "NODE_ENV=production" >> /etc/environment
  #               echo "DEPLOYMENT_REGION=${var.region}" >> /etc/environment
  #               echo "LOG_GROUP_NAME=${var.cloudwatch_log_group_name}" >> /etc/environment
  #               echo "SNS_TOPIC_ARN=${aws_sns_topic.sns_email.arn}" >> /etc/environment
  #               EOF

  # iam_instance_profile = aws_iam_instance_profile.s3_profile.name

  # tags = {
  #   Name = var.ec2_instance_tag
  # }
# }

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
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name = var.s3_iam_policy_name
  description = "IAM policy for EC2 to access S3 bucket (upload/download images for application)"

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

resource "aws_iam_policy" "policy_cloudwatch" {
  name = var.cloudwatch_iam_policy_name
  description = "IAM policy for EC2 to access Cloudwatch (for log and metricss)"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:PutParameter"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-policy-attach-cloudwatch" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy_cloudwatch.arn
}

resource "aws_iam_role" "code_deploy_role" {
  name = var.s3_code_deploy_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "code_deploy_policy" {
  name = var.s3_code_deploy_policy_name
  description = "IAM policy for EC2 to download application from code deploy S3 bucket and deploy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": 
  [
    {
        "Effect": "Allow",
        "Action": [
            "s3:Get*",
            "s3:List*"
        ],
        "Resource": [
          "arn:aws:s3:::${var.s3_code_deploy_bucket_name}/*",
          "arn:aws:s3:::aws-codedeploy-${var.region}/*"
        ]
        
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-policy-attach-code-deploy" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.code_deploy_policy.arn
}

resource "aws_iam_role_policy_attachment" "role-code-deploy-policy-attach" {
  role = aws_iam_role.code_deploy_role.name
  # this specific policy can also be used for limited access
  # policy_arn = aws_iam_policy.code_deploy_policy.arn
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "bookstore" {
  name = var.codedeploy_application_name
}

resource "aws_codedeploy_deployment_group" "bookstore_group" {
  app_name              = aws_codedeploy_app.bookstore.name
  deployment_group_name = var.codedeploy_application_group
  service_role_arn      = aws_iam_role.code_deploy_role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  autoscaling_groups = [aws_autoscaling_group.autoscaling_group.name]

  # This is for individual EC2 deployment
  # ec2_tag_set {
  #   ec2_tag_filter {
  #     key   = "Name"
  #     type  = "KEY_AND_VALUE"
  #     value = var.ec2_instance_tag
  #   }
  # }

  # this deployment style is default so not actually needed for now
  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

# circleci roles and policies
resource "aws_iam_policy" "circleci_upload_to_s3" {
  name = var.circleci_upload_to_s3_policy_name
  description = "IAM policy for CircleCI to upload application to S3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
              "arn:aws:s3:::${var.s3_code_deploy_bucket_name}",
              "arn:aws:s3:::${var.s3_code_deploy_bucket_name}/*"
            ]
            
        }
    ]
}
EOF
}

resource "aws_iam_policy" "circleci_codedeploy" {
  name = var.circleci_codedeploy_policy_name
  description = "IAM policy for CircleCI to call CodeDeploy APIs to initiate application deployment on EC2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.region}:${var.aws_account_id}:application:${var.codedeploy_application_name}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.region}:${var.aws_account_id}:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:${var.region}:${var.aws_account_id}:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:${var.region}:${var.aws_account_id}:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "circleci_ec2_ami" {
  name = var.circleci_ec2_ami_policy_name
  description = "IAM policy for CircleCI to deploy on EC2 instances"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "circleci_upload_se_user_policy_attach" {
  user       = var.circleci_user_name
  policy_arn = aws_iam_policy.circleci_upload_to_s3.arn
}

resource "aws_iam_user_policy_attachment" "circleci_codedeploy_policy_attach" {
  user       = var.circleci_user_name
  policy_arn = aws_iam_policy.circleci_codedeploy.arn
}

resource "aws_iam_user_policy_attachment" "circleci_ec2_ami_policy_attach" {
  user       = var.circleci_user_name
  policy_arn = aws_iam_policy.circleci_ec2_ami.arn
}

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name = "csye6225"
  billing_mode = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key = "email"
  # range_key = "timestamp"

  attribute {
    name = "email"
    type = "S"
  }

  # attribute {
  #   name = "timestamp"
  #   type = "S"
  # }

  # attribute {
  #   name = "email"
  #   type = "S"
  # }

  # attribute {
  #   name = "timetoexist"
  #   type = "N"
  # }

  ttl {
    attribute_name = "timetoexist"
    enabled        = true
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = var.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days
  tags = {
    Environment = "production"
    Application = "bookstore"
  }
}

# This creates A record in sub domain.
# create route53 record so that we don't need to manually update in DNS zone
resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = var.route53_domain_name
  type    = "A"
  
  # for single ec2
  # ttl     = "60"
  # records = ["${aws_instance.ec2.public_ip}"]

  # for load balancer
  alias {
    name                   = aws_alb.application_load_balancer.dns_name
    zone_id                = aws_alb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

# As per assignment discussion on Canvas, we have to create A record in subdomain only. Not in root domain
# Uncomment below two resources if A record needs to be added to root account (main domain)
# provider "aws" {
#   profile = "root"
#   alias = "dns"
#   region = var.region
# }

# create route53 record in root account so main domain points to newly created ec2
# resource "aws_route53_record" "www_root" {
#   provider = aws.dns
#   zone_id = var.route53_root_zone_id
#   name = var.route53_root_domain_name
#   type    = "A"

  # for single ec2
  # ttl     = "60"
  # records = ["${aws_instance.ec2.public_ip}"]

  # for load balancer
#   alias {
#     name                   = aws_alb.application_load_balancer.dns_name
#     zone_id                = aws_alb.application_load_balancer.zone_id
#     evaluate_target_health = true
#   }
# }

## We don't need this since we already have Zone created
## data "aws_route53_zone" "selected" {
##   provider     = aws.dns
##   name         = var.route53_root_domain_name
## }

# resource "aws_launch_template" "webapp_launch_template" {
#   name_prefix   = "webapp"
#   image_id      = var.ami_id
#   instance_type = var.ec2_instance_type
# }

resource "aws_launch_configuration" "launch_conf" {
  name = var.aws_launch_configuration_name
  image_id = var.ami_id
  instance_type = var.ec2_instance_type
  security_groups = [aws_security_group.application.id]
  key_name = aws_key_pair.publickey.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

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
                echo "IAMInstanceProfileName=${aws_iam_instance_profile.s3_profile.name}" >> /etc/environment
                echo "IAMInstanceProfileARN=${aws_iam_instance_profile.s3_profile.arn}" >> /etc/environment
                echo "IAMInstanceProfileID=${aws_iam_instance_profile.s3_profile.id}" >> /etc/environment
                echo "DEPLOYMENT_GROUP_NAME=production" >> /etc/environment
                echo "NODE_ENV=production" >> /etc/environment
                echo "DEPLOYMENT_REGION=${var.region}" >> /etc/environment
                echo "LOG_GROUP_NAME=${var.cloudwatch_log_group_name}" >> /etc/environment
                echo "SNS_TOPIC_ARN=${aws_sns_topic.sns_email.arn}" >> /etc/environment
                EOF
              
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = var.asg_name
  launch_configuration = aws_launch_configuration.launch_conf.name
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  default_cooldown = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type = var.asg_health_check_type
  vpc_zone_identifier = [aws_subnet.subnet[0].id]

  tag {
    key = "Name"
    value = "terraform-asg-webapp"
    propagate_at_launch = true
  }

  # target_group_arns = [aws_alb_target_group.alb_target_group.arn]

  # depends_on = [aws_alb.application_load_balancer]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "autoscaling_policy_up" {
  name = "WebServerScaleUpPolicy"
  scaling_adjustment = var.asg_policyup_adjustment
  adjustment_type = var.asg_policyup_adjustment_type
  cooldown = var.asg_policyup_cooldown
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_autoscaling_policy" "autoscaling_policy_down" {
  name = "WebServerScaleDownPolicy"
  scaling_adjustment = var.asg_policydown_adjustment
  adjustment_type = var.asg_policydown_adjustment_type
  cooldown = var.asg_policydown_cooldown
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high" {
  alarm_name = "CPUAlarmHigh"
  alarm_description = "Scale-up if CPU > 5% for 1 minute/s"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  statistic = "Average"
  period = var.asg_cpu_alarm_high_period
  evaluation_periods = var.asg_cpu_alarm_high_evaluation_periods
  threshold = var.asg_cpu_alarm_high_threshold

  alarm_actions = [aws_autoscaling_policy.autoscaling_policy_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }
  comparison_operator = "GreaterThanThreshold"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_low" {
  alarm_name = "CPUAlarmLow"
  alarm_description = "Scale-down if CPU < 3% for 1 minute/s"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  statistic = "Average"
  period = var.asg_cpu_alarm_low_period
  evaluation_periods = var.asg_cpu_alarm_low_evaluation_periods
  threshold = var.asg_cpu_alarm_low_threshold

  alarm_actions = [aws_autoscaling_policy.autoscaling_policy_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }
  comparison_operator = "LessThanThreshold"
}

resource "aws_security_group" "alb_security_group" {
  name = "elb-security-group"
  description = "Allow load balancer inbound traffic"
  vpc_id = aws_vpc.vpc.id  
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # Inbound HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere in the world
  }
}

resource "aws_alb" "application_load_balancer" {
  name = var.alb_name
  internal = false
  # load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = aws_subnet.subnet.*.id
  
  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  # listener {
  #   lb_port           = var.alb_port
  #   lb_protocol       = "http"
  #   instance_port     = var.alb_server_port
  #   instance_protocol = "http"
  # }

  tags = {
    Name = var.alb_name
  }
}

resource "aws_alb_listener" "webapp_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = var.alb_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_ssl_cirtificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on = [aws_alb_target_group.alb_target_group]
  listener_arn = aws_alb_listener.webapp_listener.arn
  priority = var.alb_priority
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
  condition {
    field  = "path-pattern"
    values = [var.alb_path]
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = var.alb_target_group_name
  port     = var.alb_server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }   
  health_check {
    healthy_threshold   = var.alb_healthcheck_healthy_threshold    
    unhealthy_threshold = var.alb_healthcheck_unhealthy_threshold
    timeout             = var.alb_healthcheck_timeout    
    interval            = var.alb_healthcheck_interval 
    path                = var.alb_healthcheck_path
    port                = var.alb_server_port
    matcher = "200"  # has to be HTTP 200 or fails
  }
  tags = {
    name = var.alb_target_group_name
  }
}

resource "aws_autoscaling_attachment" "alb_asg_attach" {
  alb_target_group_arn   = aws_alb_target_group.alb_target_group.arn
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.id
}

# Assignment 9
resource "aws_sns_topic" "sns_email" {
    name = "send-email-topic"
}

resource "aws_sns_topic_subscription" "email_sns_target" {
    topic_arn = aws_sns_topic.sns_email.arn
    protocol = "lambda"
    endpoint  = aws_lambda_function.email_lambda.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.lambda_source_file
  output_path = var.lambda_output_path
}

resource "aws_lambda_function" "email_lambda" {
  filename         = var.lambda_output_path
  function_name    = "send_email"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"

  environment {
    variables = {
      NODE_ENV = "production",
      DOMAIN = var.route53_domain_name,
      DEPLOYMENT_REGION = var.region,
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.basic_dynamodb_table.id
    }
  }
}

resource "aws_lambda_permission" "with_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.email_lambda.arn
    principal = "sns.amazonaws.com"
    source_arn = aws_sns_topic.sns_email.arn
}

resource "aws_iam_role" "lambda_role" {
  name = "iam_for_lambda_with_sns"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_logs_policy" {
    name = "LambdaRolePolicy"
    role = aws_iam_role.lambda_role.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "sns_instance_policy" {
  name = var.sns_iam_policy_name
  description = "IAM policy for EC2 to publish SNS Topic"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[
    {  
      "Action": [
        "SNS:Publish"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.sns_email.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role-policy-attach-ec2-sns" {
  role = aws_iam_role.role.name
  policy_arn = aws_iam_policy.sns_instance_policy.arn
}

resource "aws_iam_role_policy" "ses_lambda_role_policy" {
    name = var.ses_lambda_iam_policy_name
    role = aws_iam_role.lambda_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb_lambda_role_policy" {
    name = var.dynamodb_lambda_iam_policy_name
    role = aws_iam_role.lambda_role.id
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": "${aws_dynamodb_table.basic_dynamodb_table.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "codedeploy_lambda_policy" {
  name = var.circleci_lambda_iam_policy_name
  description = "IAM policy for CircleCI to deploy lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:DescribeAlarms",
                "lambda:UpdateAlias",
                "lambda:GetAlias",
                "lambda:CreateFunction",
                "lambda:UpdateFunctionConfiguration",
                "lambda:UpdateFunctionCode",
                "lambda:GetProvisionedConcurrencyConfig",
                "sns:Publish"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": "arn:aws:lambda:*:*:function:CodeDeployHook_*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:UpdateFunctionCode"
            ],
            "Resource": "${aws_lambda_function.email_lambda.arn}",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "circleci_codedeploy_lambda_policy_attach" {
  user       = var.circleci_user_name
  policy_arn = aws_iam_policy.codedeploy_lambda_policy.arn
}

# resource "aws_iam_policy" "ses_lambda_policy" {
#   name = var.ses_lambda_iam_policy_name
#   description = "IAM policy for Lambda to Send Email"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ses:SendEmail",
#                 "ses:SendRawEmail"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "role-policy-attach-ec2-sns" {
#   role = aws_iam_role.lambda_role.id
#   policy_arn = aws_iam_policy.ses_lambda_policy.arn
# }