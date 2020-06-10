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
- Use dev profile in aws cli
```
export AWS_PROFILE=dev
```
- Use prod profile in aws cli
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
zonecount = 3
startindex = 0
gateway_name = "csye6225-gateway"
route_table_name = "csye6225-route-table"
```

## Important
Make sure to export `AWS_PROFILE` with following before executing `terraform` command:
```
export AWS_PROFILE=dev
```