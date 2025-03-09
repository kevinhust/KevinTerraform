# [KevinTerraform](https://github.com/kevinhust/KevinTerraform)- Terraform AWS Project

Welcome to the Terraform AWS Infrastructure Project! This repository contains Terraform configurations to deploy a multi-environment AWS infrastructure, including non-production (`non-prod`) and production (`prod`) environments. The setup includes VPCs, subnets, Internet Gateways, NAT Gateways, virtual machines (VMs), and a load balancer, with Apache web servers deployed in the non-prod environment. This project is designed as an experimental setup for the ACS730 course.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Configuration Details](#configuration-details)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

This project uses Terraform to provision AWS resources for two environments:

- **Non-Production (non-prod)**: 
  - 2 public subnets (Public subnet 1, Public subnet 2)
  - 2 private subnets (Private subnet 1, Private subnet 2)
  - NAT Gateway
  - Internet Gateway
  - Bastion Host
  - VMs with Apache web servers
  - Load Balancer in public subnets
  
- **Production (prod)**: 
  - 2 private subnets only (Private subnet 3, Private subnet 4)
  - Internet Gateway attached to VPC
  - No public subnets
  - No NAT Gateway
  - Accessed via non-prod Bastion Host through VPC Peering

The infrastructure is connected via VPC Peering, allowing secure communication between `non-prod` and `prod` environments. Production environment is completely isolated from direct internet access, with all access controlled through the non-prod Bastion Host.

## Features

- Automated deployment of VPCs, subnets, and gateways using Terraform.
- Deployment of EC2 instances with Apache web servers in the non-prod environment.
- Load balancing for non-prod VMs.
- Bastion Host for SSH access to private instances.
- VPC Peering between non-prod and prod environments.
- S3 backend for Terraform state management with optional DynamoDB locking.

## Prerequisites

Before running the project, ensure you have the following:

- **AWS Account**: With appropriate IAM permissions to create EC2 instances, VPCs, and other resources.
- **Terraform**: Version 1.0 or later (install via [Terraform website](https://www.terraform.io/downloads.html)).
- **AWS CLI**: Configured with credentials (`aws configure`).
- **SSH Key Pair**: A public SSH key file (`kevin-terraform-key.pub`) placed in the root directory.
- **S3 Buckets**: `kevinhust-p1-nonprod` and `kevinhust-p1-prod` for Terraform state storage.
- **DynamoDB Tables**: `terraform-locks-nonprod` and `terraform-locks-prod` for state locking.

## Installation

1. Clone the Repository

   ```bash
   git clone git@github.com:kevinhust/KevinTerraform.git 
   cd KevinTerraform
   ```

   

2. Initialize Terraform

   - Navigate to the environment directory (e.g., `environments/non-prod/network`).

   - Run:

     `terraform init`

3. **Verify AWS Credentials**: Ensure your AWS CLI is configured with the correct credentials and region (`us-east-1`).

4. Move the Apache Script

   - Ensure `install_apache.sh` is located in the root directory (`/Terraform/install_apache.sh`) and has executable permissions:

     `chmod +x install_apache.sh`

## Usage

### Deploying Resources

1. Deploy Non-Prod Network

   `cd environments/non-prod/network terraform apply`

   - Follow the prompts to confirm the deployment.

2. Deploy Non-Prod Web Server

   ```bash
   cd ../../environments/non-prod/webserver 
   terraform apply
   ```

3. Deploy Prod Network

   ```bash
   cd ../../environments/prod/network 
   terraform apply`
   ```

   

4. Deploy Prod Web Server

   ```bash
   cd ../../environments/prod/webserver 
   terraform apply
   ```

   

   ### Accessing the Infrastructure

- Bastion Host: SSH into the Bastion Host using `ec2-user`and the private key corresponding to 

  `kevin-terraform-key.pub`

  `ssh -i kevin-terraform-key.pem ec2-user@<bastion-public-ip>`

- **VM Access**: From the Bastion Host, SSH into private VMs (e.g., VM1, VM2) using ec2-user.

- Web Access: Access the Apache web servers in non-prod via the Load Balancer DNS:

  `curl http://<load-balancer-dns>`

### Destroying Resources

To clean up and destroy all resources:

```
terraform destroy
```

Run this command in each environment directory as needed.

## File Structure

```markdown
Terraform/
├── main.tf                    # Root configuration to import SSH key
├── provider.tf                # AWS provider configuration
├── environments/              # Environment-specific configurations
│   ├── non-prod/              # Non-production environment
│   │   ├── network/           # Network resources for non-prod
│   │   │   ├── config.tf      # S3 backend configuration for network
│   │   │   ├── main.tf        # Network resource definitions
│   │   │   ├── outputs.tf     # Output values for network
│   │   │   └── variables.tf   # Input variables for network
│   │   ├── webserver/         # Web server resources for non-prod
│   │   │   ├── config.tf      # S3 backend configuration for webserver
│   │   │   ├── main.tf        # Web server resource definitions
│   │   │   ├── outputs.tf     # Output values for webserver
│   │   │   └── variables.tf   # Input variables for webserver
│   ├── prod/                  # Production environment
│   │   ├── network/           # Network resources for prod
│   │   │   ├── config.tf      # S3 backend configuration for network
│   │   │   ├── main.tf        # Network resource definitions
│   │   │   ├── outputs.tf     # Output values for network
│   │   │   └── variables.tf   # Input variables for network
│   │   ├── webserver/         # Web server resources for prod
│   │   │   ├── config.tf      # S3 backend configuration for webserver
│   │   │   ├── main.tf        # Web server resource definitions
│   │   │   ├── outputs.tf     # Output values for webserver
│   │   │   └── variables.tf   # Input variables for webserver
├── modules/                   # Merged module definitions
│   ├── main.tf                # Consolidated module resources
│   └── variables.tf           # Input variables for modules
└── install_apache.sh          # Script to install Apache on non-prod VMs
```



## Configuration Details

- VPC CIDR:
  - Non-prod: `10.0.0.0/16`
  - Prod: `10.1.0.0/16`
- Subnets:
  - Non-prod: 
    - Public subnet 1 (`10.0.1.0/24`, us-east-1a)
    - Public subnet 2 (`10.0.2.0/24`, us-east-1b)
    - Private subnet 1 (`10.0.3.0/24`, us-east-1a)
    - Private subnet 2 (`10.0.4.0/24`, us-east-1b)
  - Prod: 
    - Private subnet 3 (`10.1.3.0/24`, us-east-1a)
    - Private subnet 4 (`10.1.4.0/24`, us-east-1b)
    - No public subnets
- Instance Types:
  - Non-prod: `t2.micro`
  - Prod: `t2.medium`
- Availability Zones:
  - us-east-1a
  - us-east-1b
- **Tags**: Default tags include `Owner=acs730` and `App=Web`.

## Security Features

- Production Environment:
  - Completely isolated from direct internet access
  - No public subnets
  - Access only through VPC Peering from non-prod Bastion Host
  - Internet Gateway attached but not used (for future flexibility)
  
- Non-Production Environment:
  - Bastion Host in public subnet for secure SSH access
  - NAT Gateway for private subnet internet access
  - Load Balancer in public subnets
  - Apache web servers in private subnets

## Outputs

- Non-Prod Network Outputs:
  - `vpc_id`: VPC ID
  - `public_subnet_ids`: List of public subnet IDs
  - `private_subnet_ids`: List of private subnet IDs
  - `bastion_id`: Bastion Host instance ID
  - `vpc_cidr`: VPC CIDR block
- Non-Prod Webserver Outputs:
  - `public_ip`: Public IPs of VMs
  - `private_ip`: Private IPs of VMs
  - `vm_ids`: VM instance IDs
  - `lb_dns`: Load Balancer DNS name
- Prod Network Outputs:
  - `vpc_id`: VPC ID
  - `public_subnet_ids`: List of public subnet IDs
  - `private_subnet_ids`: List of private subnet IDs
  - `vpc_cidr`: VPC CIDR block
- Prod Webserver Outputs:
  - `public_ip`: Public IPs of VMs
  - `vm_ids`: VM instance IDs

## Contributing

This is an experimental project for educational purposes. Contributions are welcome! Please fork the repository and submit pull requests with improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details (if applicable, create a `LICENSE` file with MIT terms).

## Contact

For questions or support, please contact:

- Name: Kevin Wang
- Email: kevinhust@gmail.com
- GitHub: kevinhust

