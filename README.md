# KevinTerraform - Multi-Environment AWS Infrastructure

A comprehensive Terraform project for deploying and managing multi-environment AWS infrastructure with a focus on networking, security, and scalability.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Deployment Instructions](#deployment-instructions)
- [Environment Configuration](#environment-configuration)
- [Remote State Management](#remote-state-management)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## 🏗️ Architecture Overview

This project implements a multi-environment AWS infrastructure with separate production and non-production environments. The architecture includes:

- **VPC Networking**: Isolated VPCs for production and non-production environments
- **Subnet Organization**: Public and private subnets across multiple availability zones
- **Security**: Bastion host for secure SSH access to private instances
- **Connectivity**: VPC Peering for inter-environment communication
- **Internet Access**: NAT Gateways for outbound internet access from private subnets
- **Load Balancing**: Application Load Balancer for distributing web traffic

## ✨ Features

- **Environment Isolation**: Separate VPCs for production and non-production environments
- **High Availability**: Resources distributed across multiple availability zones
- **Secure Access**: Bastion host for SSH access to private instances
- **Web Hosting**: Apache web servers with load balancing
- **Remote State Management**: S3 backend with DynamoDB locking
- **Infrastructure as Code**: Complete infrastructure defined in Terraform

## 🔧 Prerequisites

- AWS Account
- Terraform v1.0.0 or newer
- AWS CLI configured with appropriate credentials
- S3 buckets for Terraform state:
  - `kevinhust-a1-prod`
  - `kevinhust-a1-nonprod`
- DynamoDB tables for state locking:
  - `terraform-locks-prod`
  - `terraform-locks-nonprod`

## 📁 Project Structure

```
KevinTerraform/
├── README.md                  # Project documentation
├── install_apache.sh          # Apache installation script
├── environments/              # Environment-specific configurations
│   ├── non-prod/              # Non-production environment
│   │   ├── network/           # Network resources
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── config.tf
│   │   └── webserver/         # Web server resources
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── terraform.tfvars
│   │       └── config.tf
│   └── prod/                  # Production environment
│       ├── network/           # Network resources
│       │   ├── main.tf
│       │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── config.tf
│       └── webserver/         # Web server resources
│           ├── main.tf
│           ├── variables.tf
│           ├── terraform.tfvars
│           └── config.tf
└── modules/                   # Reusable modules
    ├── vpc/                   # VPC module
    ├── subnet/                # Subnet module
    ├── internet_gateway/      # Internet Gateway module
    ├── nat_gateway/           # NAT Gateway module
    ├── vpc_peering/           # VPC Peering module
    ├── vm/                    # Virtual Machine module
    └── load_balancer/         # Load Balancer module
```

## 🚀 Deployment Instructions

### Initial Setup

1. Ensure S3 buckets and DynamoDB tables exist:
   ```bash
   # Create S3 buckets
   aws s3 mb s3://kevinhust-a1-prod
   aws s3 mb s3://kevinhust-a1-nonprod
   
   # Create DynamoDB tables
   aws dynamodb create-table \
     --table-name terraform-locks-prod \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST
   
   aws dynamodb create-table \
     --table-name terraform-locks-nonprod \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST
   ```

### Deployment Order

1. **Deploy Non-Prod Network**:
   ```bash
   cd environments/non-prod/network
   terraform init
   terraform apply
   ```

2. **Deploy Non-Prod Webserver**:
   ```bash
   cd environments/non-prod/webserver
   terraform init
   terraform apply
   ```

3. **Deploy Prod Network**:
   ```bash
   cd environments/prod/network
   terraform init
   terraform apply
   ```

4. **Deploy Prod Webserver**:
   ```bash
   cd environments/prod/webserver
   terraform init
   terraform apply
   ```

## ⚙️ Environment Configuration

### Non-Prod Environment

- **VPC CIDR**: 10.1.0.0/16
- **Public Subnets**: 10.1.1.0/24, 10.1.2.0/24
- **Private Subnets**: 10.1.3.0/24, 10.1.4.0/24
- **Components**: 
  - Internet Gateway
  - NAT Gateway
  - Bastion Host
  - Application Load Balancer
  - Web Servers in private subnets

### Prod Environment

- **VPC CIDR**: 10.10.0.0/16
- **Private Subnets**: 10.10.1.0/24, 10.10.2.0/24
- **Components**:
  - VPC Peering to Non-Prod
  - NAT Gateway
  - Web Servers in private subnets

## 💾 Remote State Management

This project uses Terraform remote state with the following configuration:

- **Non-Prod Network**:
  - Bucket: `kevinhust-a1-nonprod`
  - Key: `non-prod/networking/terraform.tfstate`
  - DynamoDB Table: `terraform-locks-nonprod`

- **Non-Prod Webserver**:
  - Bucket: `kevinhust-a1-nonprod`
  - Key: `non-prod/webserver/terraform.tfstate`
  - DynamoDB Table: `terraform-locks-nonprod`

- **Prod Network**:
  - Bucket: `kevinhust-a1-prod`
  - Key: `prod/networking/terraform.tfstate`
  - DynamoDB Table: `terraform-locks-prod`

- **Prod Webserver**:
  - Bucket: `kevinhust-a1-prod`
  - Key: `prod/webserver/terraform.tfstate`
  - DynamoDB Table: `terraform-locks-prod`

## 🔒 Security Considerations

- **SSH Access**: All SSH access to instances is through the Bastion host
- **Network Isolation**: Production environment has no direct internet access
- **Security Groups**: Strict security group rules limit traffic between components
- **VPC Peering**: Controlled communication between environments

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📞 Support

For questions or issues, please contact:
- Email: kevinhust@gmail.com
- Or open an issue in the GitHub repository
