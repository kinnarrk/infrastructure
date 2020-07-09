region = "us-east-1"
cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.0.0/24"
vpc_name = "csye6225-vpc"
vpc_tag = "csye6225-vpc-prod"    # Change this according to env
subnet_name = "csye6225-subnet"
zonecount = 3   # for assignment 4
startindex = 0
gateway_name = "csye6225-gateway"
route_table_name = "csye6225-route-table"
route_table_cidr_block = "0.0.0.0/0"
application_security_group_name = "app_sec_group"
database_security_group_name = "db_sec_group"
s3_bucket_name = "kinnarkansara-prod-s3-bucket"    # Change this according to env
subnet_group_name = "csye6225-subnet-rds-group"
db_identifier = "csye6225su2020"
db_username = "csye6225su2020"
db_password = "bXsdRTnY7MWMAhw2fA7k"
db_name = "csye6225"
ec2_instance_name = "my-ec2-instance"
ami_id = "ami-0c29db1b042ceb527"    # Modify this
ec2_instance_type = "t2.micro"
pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRJHeOClQBCDTqeuNzAFXhFukLTgrMLcKJKBIkh7K/JZ0M3/xgPj9GxElj4KRVuct7y92WCUDRe0TMhOUOxWBKB5aSQ8SniRMG0FFS363oAqr3t3xmyj+vFZihLFp9iQampLOpmmDnpvu8nwGWoFlOhlOkw7yh4T7j2i+teLmf7rSR8mj4IHYJnH4/xjZeyGJlueh4ulZRr+bEneyXYIwFKViujpcZF4dFKcduK+f9YKHRbD6V6qsXsgrlNQvcCsD4SIf/Oa1835eSjqI0xelAjXZyZqFdbIzJ49cgGMdK6AsKJALF0U1ndXKoUOwL7txAT7y5I/qx5Nc9tqHP/mmd kinnar@ubuntu"
ec2_instance_tag = "EC2BookStore"
s3_iam_profile_name = "s3-iam"
s3_iam_role_name = "EC2-CSYE6225"
s3_iam_policy_name = "WebAppS3"
s3_code_deploy_role_name = "CodeDeployEC2ServiceRole"
s3_code_deploy_policy_name = "CodeDeploy-EC2-S3"
s3_code_deploy_bucket_name = "codedeploy.prod.kinnarkansara.me"  # Change this according to env
circleci_user_name = "cicd"
circleci_upload_to_s3_policy_name = "CircleCI-Upload-To-S3"
circleci_codedeploy_policy_name = "CircleCI-Code-Deploy"
aws_account_id = "440205144781" # Change this according to env
codedeploy_application_name = "bookstore"
codedeploy_application_topic = "bookstore-topic"
codedeploy_application_group = "bookstore-deploy-group"
circleci_ec2_ami_policy_name = "CircleCI-EC2-Ami"
route53_zone_id = "Z05466232A1G13MN5LZN5"   # Change this according to env
route53_domain_name = "prod.kinnarkansara.me"   # Change this according to env
cloudwatch_iam_policy_name = "WebAppCloudwatch"
cloudwatch_log_group_name = "BookstoreCSYE6225"
log_retention_days = 7
