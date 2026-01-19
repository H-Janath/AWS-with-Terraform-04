terraform {

  backend "s3" {
    bucket = "techtutorialwithjanath-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# create s3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "techtutorialwithjanth01-buckert-12345"
  
  tags = {
    Name        = "My bucket-2.0"
    Environment = "Dev"
  }
}
#VPC
resource "aws_vpc" "sample" {
  cidr_block="10.0.0.0/16"

  tags ={
    Environment = "dev"
     Name       = "dev-vpc"
  }
}
#Subnet
resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.sample.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Environment = "dev"
    Name = "dev-public-subnet"
  }
}
# EC2 Instance
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags ={
    Environment = "dev"
    Name        = "dev-EC2-Instance"
  }
  
}