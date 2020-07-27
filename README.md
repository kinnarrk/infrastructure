# Infrastructure
This is the infrastructure as a code repo


Tools used:
- [AWS CLI](https://aws.amazon.com/cli/)
- [Hashicorp Terraform](https://www.terraform.io/)


## Installation

### AWS CLI version 2 on Linux
Follow instruction provided here: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install

### Terraform
- Download binary from: https://www.terraform.io/downloads.html
- Extract zip archive
- move `terraform` binary to `usr/bin/local` so that commands can be executed with `terraform ...`

## Configuration
### AWS CLI
```
aws configure --profile dev 
```
(provide key, secret and default region)
Use dev profile in aws cli
```
export AWS_PROFILE=dev
```
Use prod profile in aws cli
```
export AWS_PROFILE=prod
```
Reference: https://docs.aws.amazon.com/cli/latest/index.html

Example:
```
aws ec2 describe-vpcs
```

## Terraform commands
To initialize terraform in a dir
```
terraform init
```
Check for any possible mistake (validation before execution)
```
terraform plan
```
Execute the instructions in `main.tf` file
```
terraform apply
```
Destroy the resources in AWS from `main.tf` file
```
terraform destroy
```
Using params:
```
terraform apply -var="newtag=NewSubnet2"
```
Using `.tfvars` file:
```
terraform apply -var-file="testing.tfvars"
```
## Specific to this repo
Define all the variables in the `.tfvars` file like this:
```
region = "us-east-1"
cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.0.0/24"
vpc_name = "csye6225-vpc"
vpc_tag = "csye6225-vpc-dev"    # Change this according to env
subnet_name = "csye6225-subnet"
zonecount = 3   # On need basis
startindex = 0
gateway_name = "csye6225-gateway"
route_table_name = "csye6225-route-table"
route_table_cidr_block = "0.0.0.0/0"
application_security_group_name = "app_sec_group"
database_security_group_name = "db_sec_group"
s3_bucket_name = "kinnarkansara-dev-s3-bucket"  # Change this according to env
subnet_group_name = "csye6225-subnet-rds-group"
db_identifier = "csye6225su2020"
db_username = "csye6225su2020"
db_password = "some_strong_random_password"
db_name = "csye6225"
ec2_instance_name = "my-ec2-instance"
ami_id = "ami-05d193c841abababab"    # Modify this
ec2_instance_type = "t2.micro"
pub_key = "ssh-rsa AAAAB... user@ubuntu"    # Change this according to env (entire public key string)
ec2_instance_tag = "EC2BookStore"
s3_iam_profile_name = "s3-iam"
s3_iam_role_name = "EC2-CSYE6225"
s3_iam_policy_name = "WebAppS3"
s3_code_deploy_role_name = "CodeDeployEC2ServiceRole"
s3_code_deploy_policy_name = "CodeDeploy-EC2-S3"
s3_code_deploy_bucket_name = "codedeploy.dev.kinnarkansara.me"  # Change this according to env
circleci_user_name = "cicd"
circleci_upload_to_s3_policy_name = "CircleCI-Upload-To-S3"
circleci_codedeploy_policy_name = "CircleCI-Code-Deploy"
aws_account_id = "000000000000" # Change this according to env
codedeploy_application_name = "bookstore"
codedeploy_application_topic = "bookstore-topic"
codedeploy_application_group = "bookstore-deploy-group"
circleci_ec2_ami_policy_name = "CircleCI-EC2-Ami"
route53_zone_id = "XXXXX"   # Change this according to env
route53_domain_name = "dev.kinnarkansara.me"   # Change this according to env
cloudwatch_iam_policy_name = "WebAppCloudwatch"
cloudwatch_log_group_name = "BookstoreCSYE6225"
log_retention_days = 7
route53_root_domain_name = "kinnarkansara.me"
route53_root_zone_id = "XXXXX"  # For adding DNS record in root account
aws_launch_configuration_name = "asg_launch_config"
asg_name = "asg_launch_config"
asg_min_size = 2
asg_max_size = 5
asg_desired_capacity = 2
asg_default_cooldown = 60
asg_health_check_grace_period = 300
asg_health_check_type = "ELB"
asg_policyup_adjustment = 1
asg_policyup_adjustment_type = "ChangeInCapacity"
asg_policyup_cooldown = 60
asg_policydown_adjustment = -1
asg_policydown_adjustment_type = "ChangeInCapacity"
asg_policydown_cooldown = 60
asg_cpu_alarm_high_period = "60"
asg_cpu_alarm_high_evaluation_periods = "2"
asg_cpu_alarm_high_threshold = "5"
asg_cpu_alarm_low_period = "60"
asg_cpu_alarm_low_evaluation_periods = "2"
asg_cpu_alarm_low_threshold = "3"
alb_name = "application-load-balancer"
alb_port = 80
alb_server_port = 3000
alb_priority = 100
alb_path = "dev.kinnarkansara.me"   # Change this according to env
alb_target_group_name = "alb-target-group"
alb_healthcheck_path = "/healthcheck"
alb_healthcheck_healthy_threshold = 3
alb_healthcheck_unhealthy_threshold = 5
alb_healthcheck_timeout = 5
alb_healthcheck_interval = 10
lambda_source_file = "/path/to/lambda/function.js"
lambda_output_path = "/path/to/lambda/function.zip"
sns_iam_policy_name = "EC2-publish-SNS-Policy"
ses_lambda_iam_policy_name = "Lambda-SES-Policy"
dynamodb_lambda_iam_policy_name = "Lambda-DynamoDB-Policy"
circleci_lambda_iam_policy_name = "Lambda-Codedeploy-Policy"
alb_ssl_cirtificate_arn = "arn:aws:acm:us-east-1:**********:certificate/**************************"
```

## Creating multiple VPCs from same `.tf` file(s)
There are two ways to achieve this
### Workspace 
Ref: https://www.terraform.io/docs/state/workspaces.html
```
$ terraform workspace
Usage: terraform workspace

  new, list, show, select and delete Terraform workspaces.
```
Terraform uses `default` workspace when we initialize project with `terraform init`

Create new workspace using:
```
$ terraform workspace new bar
Created and switched to workspace "bar"!
```

Switch to different workspace:
```
$ terraform workspace select foo
Switched to workspace "foo"!
```

### Modules
Ref: https://www.terraform.io/docs/modules/index.html

Minimal module structure is sufficient for this use case.
```
$ tree minimal-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

## Important
Make sure to export `AWS_PROFILE` with following before executing `terraform` command:
```
export AWS_PROFILE=dev
```

## Import certificate to ACM to use for load balancer

### Dev

Requesting ACM public certificate [AWS DOC](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)

```
aws acm request-certificate \
--domain-name dev.kinnarkansara.me \
--validation-method DNS \
--idempotency-token 12345 \
--tags Key=Website,Value=dev.kinnarkansara.me \
--options CertificateTransparencyLoggingPreference=DISABLED
```

This will output the ARN of the certificate. Keep this in `tfvar` file with variable name `alb_ssl_cirtificate_arn`.
You can see this certificate in ACM from AWS console.

### Prod

Use CA like Namecheap to get SSL certificate.
Follow the steps below to Request the certificate

1. Purchase certificate from CA

1. Request certificate with CSR. Refer this [Namecheap Documentation](https://www.namecheap.com/support/knowledgebase/article.aspx/9592/14/generating-a-csr-on-amazon-web-services-aws/)

1. Once certificate is issued, you have two options: Import certificate to ACM or Upload the certificate. `AWS_PROFILE` environment variable needs to be exported first

1. Import certificate to ACM (Recommended):

    Follow this [instruction](https://docs.aws.amazon.com/acm/latest/userguide/import-certificate-api-cli.html#import-certificate-cli) to import to ACM. This is better approach because once certificate is imported, it can be seen in ACM of AWS Console.

    ```
    aws acm import-certificate --certificate fileb://prod_kinnarkansara_me.crt \
		--certificate-chain fileb://prod_kinnarkansara_me_CertificateBundle.pem \
		--private-key fileb://prod_private.key.pem
    ```

    Important: Make sure to use `fileb://` to refer `crt` or `pem` files. [Reference](https://github.com/aws/aws-cli/issues/5041#issuecomment-621515626).

1. Upload certificate to IAM (Alternate approach):

    This uploads certificate to IAM role:

    ```
    aws iam upload-server-certificate --server-certificate-name ProdKinnarKansaraMe \
        --certificate-body file://prod_kinnarkansara_me.pem \
        --certificate-chain file://prod_kinnarkansara_me.ca-bundle \
        --private-key file://prod_private.key.pem
    ```


This commands will output the ARN of the certificate. Keep this in `tfvar` file with variable name `alb_ssl_cirtificate_arn`.
You can see this certificate in ACM from AWS console.
