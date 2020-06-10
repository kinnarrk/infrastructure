#!/bin/bash

aws ec2 create-vpc --cidr-block "10.0.0.0/16" --no-amazon-provided-ipv6-cidr-block --instance-tenancy default

aws ec2 delete-vpc --vpc-id vpc-004dd1d884abe3c70

aws ec2 describe-vpcs --filters Name=Name,Values=demo

aws ec2 modify-vpc-attribute --enable-dns-hostnames --enable-dns-support --vpc-id vpc-004dd1d884abe3c70

aws ec2 modify-vpc-attribute --no-enable-dns-hostnames --vpc-id vpc-004dd1d884abe3c70
