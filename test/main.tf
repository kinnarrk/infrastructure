provider "aws" {
  region = "us-east-1"
}

variable "newtag" {
  type = string
  default = "demo_subnet"
}

variable "zonecount" {
  type = number
  default = 3
  description = "Number of subnet zones to be created"
  # validation {
  #   condition     = var.zonecount < 1 && var.zonecount > 6
  #   error_message = "Please enter value between 1 to 6."
  # }
}

# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}

resource "aws_vpc" "csye6225_demo_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink_dns_support = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "csye6225_demo_vpc"
  }
  
}

resource "aws_subnet" "subnet" {
  count = var.zonecount
  cidr_block = "10.0.${10+count.index}.0/24"
  vpc_id = aws_vpc.csye6225_demo_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "csye6225_demo_subnet",
    tag2 = var.newtag
  }
  
}
