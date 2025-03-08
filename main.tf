provider "aws" {
  region = var.region
  profile = "default"
    #access_key = var.aws_access_key
    #secret_key = var.aws_secret_key
}

data "aws_caller_identity" "current" {}


## IAM user & Permissions
## IAM User
resource "aws_iam_user" "bob" {
  name        = var.iam_user_name
  path        = "/"
}

## IAM User Policy
resource "aws_iam_policy" "bob_policy" {
  name        = "bob-access-policy"
  description = "Policy for Bob to access EC2 and S3"
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

# IAM Policy Attachment
resource "aws_iam_user_policy_attachment" "attach_bob_policy" {
  user       = aws_iam_user.bob.name
  policy_arn = aws_iam_policy.bob_policy.arn
}


## S3 bucket policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.iam_user_name}"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}",
        "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/*"
      ]
    }
  ]
}
POLICY
}

## Network
## VPC, Subnet, and Internet Gateway
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MainVPC"
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
    Name = "InternetGateway"
  }
}

## Security group for web servers
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebSecurityGroup"
  }
}

resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.main_vpc.id

  # Allow HTTP (80) and HTTPS (443) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.main_vpc.id

  # Allow SSH only from YOUR IP (Replace "YOUR_IP/32" with your actual IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //YOUR_IP/32
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = "MyBucket"
  }
}

## EC2 instances
## Backend instances
resource "aws_instance" "backend" {
  count         = var.backend_instance_count
  ami           = "ami-04b4f1a9cf54c11d0" # Ubuntu 18.04
  instance_type = var.instance_type
  subnet_id     = aws_subnet.backend_subnet.id
  security_groups = [aws_security_group.backend_sg.id]

  tags = {
    Name = "Backend-${count.index}"
  }
}

## Frontend instances
resource "aws_instance" "frontend" {
  count         = var.frontend_instance_count
  ami           = "ami-04b4f1a9cf54c11d0" # Ubuntu 18.04
  instance_type = var.instance_type
  subnet_id     = aws_subnet.frontend_subnet.id
  security_groups = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "Frontend-${count.index}"
  }
}




