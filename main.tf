provider "aws" {
  region = var.region
  profile = var.profile
}

## Data current aws account id
data "aws_caller_identity" "current" {}


## IAM user & Permissions
## IAM User
resource "aws_iam_user" "bob" {
  name        = var.iam_user_name
  path        = "/"
}

## IAM User Policy Attachment
resource "aws_iam_policy_attachment" "iam_user_policy" {
  name       = var.iam_user_name
  users      = [aws_iam_user.bob.name]
  policy_arn = var.iam_policy.policy_arn
}

## Network
## VPC, Subnet, and Internet Gateway, Security Groups
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "frontend_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.frontend_subnet_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true  # Allow frontend instances to have public IPs
}

resource "aws_subnet" "backend_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.backend_subnet_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false  # Backend servers will NOT have public IPs
}

## Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.internet_gateway}"
  }
}

## Security group for web servers
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.security_group.name}"
  }
}

## S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = var.s3_bucket_name
  }
}

## EC2 instances
## Backend instances
resource "aws_instance" "backend" {
  count         = var.backend_instance_count
  ami           = var.ami_type.ami_no # Ubuntu 18.04
  instance_type = var.instance_type
  subnet_id     = aws_subnet.backend_subnet.id
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "${var.backend_instance_type}${count.index}"
  }
}

## Frontend instances
resource "aws_instance" "frontend" {
  count         = var.frontend_instance_count
  ami           = var.ami_type.ami_no # Ubuntu 18.04
  instance_type = var.instance_type
  subnet_id     = aws_subnet.frontend_subnet.id
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "${var.frontend_instance_type}${count.index}"
  }
}




