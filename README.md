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
vpc_tag = "csye6225-vpc-dev"
subnet_name = "csye6225-subnet"
zonecount = 3   # Keep this count on the basis of availability zones in "region"
startindex = 0  # starting index of second octate of subnet cidr_block
gateway_name = "csye6225-gateway"
route_table_name = "csye6225-route-table"
route_table_cidr_block = "0.0.0.0/0"
application_security_group_name = "app_sec_group"
database_security_group_name = "db_sec_group"
s3_bucket_name = "kinnarkansara-s3-bucket"
subnet_group_name = "csye6225-subnet-rds-group"
db_identifier = "csye6225su2020"
db_username = "csye6225su2020"
db_password = "some_random_secure_password"
db_name = "csye6225"
ec2_instance_name = "my-ec2-instance"
ami_id = "ami-0c723e6d53285134d"
pub_key = "ssh-rsa AAAAB... user@ubuntu"
s3_iam_profile_name = "s3-iam"
s3_iam_role_name = "EC2-CSYE6225"
s3_iam_policy_name = "WebAppS3"
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