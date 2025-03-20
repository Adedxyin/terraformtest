variable "profile" {
  description = "AWS profile to use"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "availability_zones" {
    description = "List of availability zones"
    type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of vpc"
  type        = string
}

variable "internet_gateway" {
  description = "Name of Internet gateway"
  type        = string
}

variable "frontend_subnet_cidr" {
  description = "CIDR block for the frontend subnet"
  type        = string
}

variable "backend_subnet_cidr" {
  description = "CIDR block for the backend subnet"
  type        = string
}

#variable "subnet_cidr" {
  #description = "CIDR block for the public subnet"
  #type        = string
 # default     = "10.0.1.0/24"
#}

variable "security_group" {
  description = "Allow HTTP/HTTPS traffic for frontend servers and SSH access for backend servers"
  type = object({
    name     = string # Name of the security group
    http     = string # Enable inbound HTTP traffic for IPv4
    https    = string # Enable inbound HTTPS traffic for IPv4
    ssh      = string # Enable backend access through SSH
    outgoing = string # Enable outgoing traffic
  })
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "backend_instance_type" {
  description = "backend ec2 instance name"
  type = string
}

variable "frontend_instance_type" {
  description = "frontend ec2 instance name"
  type = string
}

variable "backend_instance_count" {
  description = "Number of backend servers"
  type        = number
}

variable "frontend_instance_count" {
  description = "Number of frontend servers"
  type        = number
}

variable "s3_bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "iam_user_name" {
  description = "IAM user to be created"
  type        = string
}

variable "iam_policy" {
  type = object({
    policy_arn = string
  })
}

variable "ami_type" {
  type = object({
    ami_no = string
  })
}