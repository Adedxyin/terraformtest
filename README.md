# Terraform AWS Infrastructure Setup

## Overview
This Terraform configuration provisions an AWS infrastructure that includes:
- A VPC with public subnets.
- An internet gateway.
- Security group rules for HTTP, HTTPS, SSH, and outbound traffic.
- EC2 instances for backend and frontend servers.
- An S3 bucket.
- An IAM user with Administrator access.

## Prerequisites
Before using this Terraform configuration, ensure you have:
- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/downloads))
- AWS CLI installed and configured ([AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- AWS credentials set up (`~/.aws/credentials` or environment variables)

## Files Structure
```
.
├── main.tf                # Defines AWS resources
├── variables.tf           # Declares input variables
├── terraform.tfvars       # Specifies variable values
├── output.t               # Specifies output values
├── README.md              # Documentation
```

## Configuration Details

### Provider
The configuration uses the AWS provider and requires version `~> 5.0`.

### VPC and Subnets
- **VPC Name**: `public_vpc`
- **CIDR Block**: `10.0.0.0/16`
- **The Frontend and backened Subnets**:
  - `az1_subnet` (10.0.1.0/24)
  - `az2_subnet` (10.0.2.0/24)
- **Internet Gateway**: `public_internet_gateway`

### Security Group
- **Name**: `security_group`
- **Rules**:
  - Allow HTTP (Port 80)
  - Allow HTTPS (Port 443)
  - Allow SSH (Port 22)
  - Allow all outbound traffic

### EC2 Instances
- **Backend Servers**:
  - Type: `t2.micro`
  - Count: 2
  - AMI: `ami-04b4f1a9cf54c11d0`
- **Frontend Servers**:
  - Type: `t2.micro`
  - Count: 3
  - AMI: `ami-04b4f1a9cf54c11d0`

### S3 Bucket
- **Bucket Name**: `this4terraformprojectyk`

### IAM User
- **Name**: `BOB`
- **Role**: `AdministratorAccess`
- **Description**: `CTO`

## How to Use

### Initialize Terraform
```sh
terraform init
```

### Plan the Deployment
```sh
terraform plan
```

### Apply the Configuration
```sh
terraform apply -auto-approve
```

### Destroy the Resources
If you need to remove all created resources:
```sh
terraform destroy -auto-approve
```

## Notes
- Modify `terraform.tfvars` to customize instance types, counts, or other configurations.
- Ensure your AWS credentials have sufficient permissions to create and manage resources.
