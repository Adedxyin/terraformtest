variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
    description = "List of availability zones"
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "frontend_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "backend_subnet_cidr" {
  default = "10.0.2.0/24"
}

#variable "subnet_cidr" {
  #description = "CIDR block for the public subnet"
  #type        = string
 # default     = "10.0.1.0/24"
#}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "backend_instance_count" {
  description = "Number of backend servers"
  type        = number
  default     = 4
}

variable "frontend_instance_count" {
  description = "Number of frontend servers"
  type        = number
  default     = 2
}

variable "s3_bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "iam_user_name" {
  description = "IAM user to be created"
  type        = string
  default     = "BOB"
}
