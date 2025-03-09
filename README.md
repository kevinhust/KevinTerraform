# AWS Infrastructure with Terraform

This project implements a multi-environment AWS infrastructure using Terraform, featuring a production and non-production environment with secure networking and access controls.

## Architecture Overview

### Non-Production Environment
- VPC (10.1.0.0/16)
  - Public Subnets:
    - 10.1.1.0/24: NAT Gateway
    - 10.1.2.0/24: Bastion Host
  - Private Subnets:
    - 10.1.3.0/24: VM1
    - 10.1.4.0/24: VM2
  - Components:
    - Internet Gateway
    - NAT Gateway
    - Bastion Host
    - Application Load Balancer
    - 2 Web Servers (Apache)

### Production Environment
- VPC (10.10.0.0/16)
  - Private Subnets:
    - 10.10.1.0/24: VM1
    - 10.10.2.0/24: VM2
  - Components:
    - 2 Web Servers (Apache)
    - No public access

### VPC Peering
- Bi-directional connectivity between Production and Non-Production VPCs
- Configured routes in both environments
- Enables internal network communication

## Security Architecture

### Access Control
- All SSH access must go through the Non-Production Bastion Host
- HTTP access is allowed between all internal networks (10.0.0.0/8)
- Production environment has no direct internet access
- NAT Gateway provides outbound internet access for private subnets

### Security Groups
1. Bastion Host (Non-Prod)
   - Inbound: SSH (22) from Internet
   - Outbound: All traffic allowed

2. Web Servers (Both Environments)
   - Inbound:
     - SSH (22) from Bastion only
     - HTTP (80) from internal networks
   - Outbound: All traffic allowed

3. Load Balancer (Non-Prod)
   - Inbound: HTTP (80) from Internet
   - Outbound: All traffic allowed

## Project Structure

```
KevinTerraform/
├── README.md                  # Project documentation
├── install_apache.sh         # Apache installation script
├── environments/            # Environment-specific configurations
│   ├── non-prod/           # Non-production environment
│   │   ├── network/        # Network resources
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── terraform.tfvars
│   │   └── webserver/      # Web server resources
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── terraform.tfvars
│   └── prod/              # Production environment
│       ├── network/       # Network resources
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── terraform.tfvars
│       └── webserver/     # Web server resources
│           ├── main.tf
│           ├── variables.tf
│           └── terraform.tfvars
└── modules/              # Reusable modules
    ├── vpc/
    ├── subnet/
    ├── internet_gateway/
    ├── nat_gateway/
    ├── vpc_peering/
    ├── vm/
    └── load_balancer/
```

## Prerequisites

1. AWS CLI installed and configured
2. Terraform installed (v1.0.0 or newer)
3. SSH key pair named "kevin-terraform-key"

## Deployment Instructions

1. Deploy Non-Production Network:
```bash
cd environments/non-prod/network
terraform init
terraform apply
```

2. Deploy Production Network:
```bash
cd ../../prod/network
terraform init
terraform apply
```

3. Deploy Non-Production Web Servers:
```bash
cd ../../non-prod/webserver
terraform init
terraform apply
```

4. Deploy Production Web Servers:
```bash
cd ../../prod/webserver
terraform init
terraform apply
```

## Access Instructions

### SSH Access
1. Connect to Bastion Host:
```bash
ssh -A ec2-user@<bastion-public-ip>
```

2. From Bastion, connect to any VM:
```bash
# Non-Prod VMs
ssh ec2-user@10.1.3.X  # VM1
ssh ec2-user@10.1.4.X  # VM2

# Prod VMs
ssh ec2-user@10.10.1.X  # VM1
ssh ec2-user@10.10.2.X  # VM2
```

### HTTP Access
- Non-Prod Environment:
  - Via Load Balancer: http://<alb-dns-name>
  - Direct to VMs: http://10.1.3.X or http://10.1.4.X (from internal network)
- Prod Environment:
  - Only accessible from internal network: http://10.10.1.X or http://10.10.2.X

## Security Considerations
1. Production environment is completely private with no direct internet access
2. All SSH access is centralized through the Bastion host
3. Security groups follow the principle of least privilege
4. VPC peering enables secure internal communication

## Maintenance
- Regular updates through NAT Gateway
- SSH key rotation as needed
- Security group rule reviews
- Regular infrastructure code updates

## Troubleshooting
1. SSH Connection Issues:
   - Verify Bastion host security group
   - Check SSH agent forwarding (-A flag)
   - Confirm correct private key

2. HTTP Access Issues:
   - Verify security group rules
   - Check Apache service status
   - Validate VPC peering routes

## Contributing
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License
This project is licensed under the MIT License.

## Author
Kevin Wang
- Email: kevinhust@gmail.com
- GitHub: kevinhust

# Terraform AWS Infrastructure Project

This project uses Terraform to manage AWS infrastructure, including both production and non-production environments.

## Architecture Design

### Non-Production Environment (Non-Prod)

#### Network Configuration
- VPC CIDR: 10.1.0.0/16
- Public Subnets:
  - Subnet 1: 10.1.1.0/24 (NAT Gateway)
  - Subnet 2: 10.1.2.0/24 (Bastion Host)
- Private Subnets:
  - Subnet 1: 10.1.3.0/24 (VM1)
  - Subnet 2: 10.1.4.0/24 (VM2)

#### Component Configuration
- Internet Gateway: Provides internet access for public subnets
- NAT Gateway: Deployed in public subnet 1, provides internet access for private subnets
- Bastion Host: Deployed in public subnet 2, used for SSH access to instances in private subnets
- Application Servers: 
  - Two VMs deployed in private subnets
  - Service provided through load balancer
- Load Balancer:
  - Type: Application Load Balancer (ALB)
  - Deployed in public subnets
  - Public-facing access

### Production Environment (Prod)

#### Network Configuration
- VPC CIDR: 10.10.0.0/16
- Private Subnets:
  - Subnet 1: 10.10.1.0/24 (VM1)
  - Subnet 2: 10.10.2.0/24 (VM2)

#### Component Configuration
- Application Servers:
  - Two VMs deployed in different private subnets
  - Direct service provision, no load balancer
- Security:
  - All instances in private subnets
  - Communication with non-prod environment through VPC peering

### VPC Peering Connection
- VPC peering established between production and non-production environments
- Enables internal network communication between environments

## Deployment Sequence

1. Deploy non-production network:
```bash
cd environments/non-prod/network
terraform init
terraform apply
```

2. Deploy production network:
```bash
cd ../../prod/network
terraform init
terraform apply
```

3. Deploy non-production webserver:
```bash
cd ../../non-prod/webserver
terraform init
terraform apply
```

4. Deploy production webserver:
```bash
cd ../../prod/webserver
terraform init
terraform apply
```

## Access Methods

### Non-Production Environment
- SSH access to instances in private subnets through Bastion Host
- Application access through public ALB

### Production Environment
- SSH access through non-production environment's Bastion Host
- Application supports internal network access only

## Security Considerations
- All production environment resources deployed in private subnets
- Network access controlled through security groups
- SSH key pairs used for instance access control
- Outbound traffic in non-production environment controlled through NAT Gateway

