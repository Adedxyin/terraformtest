profile = "default"

region = "us-east-1"

availability_zones = ["us-east-1a", "us-east-1b"]

vpc_name = "The name of vpc"

vpc_cidr = "10.0.0.0/16"

frontend_subnet_cidr = "10.0.1.0/24"

internet_gateway = "public_internet_gateway"

security_group = { name = "security_group", http = "80", https = "443", ssh = "22", outgoing = "0" }

backend_subnet_cidr = "10.0.2.0/24"

instance_type = "t2.micro"

backend_instance_type = "backend"

frontend_instance_type = "frontend"

backend_instance_count = 4

frontend_instance_count = 2

s3_bucket_name = "this4terraformprojectyk"

iam_user_name = "BOB"

iam_policy = {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
ami_type = {
  ami_no = "ami-04b4f1a9cf54c11d0"
}