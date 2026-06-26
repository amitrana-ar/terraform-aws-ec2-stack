# Terraform AWS EC2 Stack

This project provisions EC2 instances with web servers (Apache & Nginx) on AWS using Terraform. Remote state is stored securely in S3 using native S3 locking (no DynamoDB required).

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                  AWS (ap-south-1)                   │
│                                                     │
│  ┌──────────────────────────────────────────────┐   │
│  │              Default VPC                     │   │
│  │                                              │   │
│  │   ┌─────────────────┐  ┌─────────────────┐   │   │
│  │   │  apache-server  │  │  nginx-server   │   │   │
│  │   │  (t3.micro)     │  │  (t3.large)     │   │   │
│  │   │  Apache2        │  │  Nginx          │   │   │
│  │   └────────┬────────┘  └────────┬────────┘   │   │
│  │            └──────────┬─────────┘            │   │
│  │                       │                      │   │
│  │            ┌──────────▼─────────┐            │   │
│  │            │   Security Group   │            │   │
│  │            │   Port 22  (SSH)   │            │   │
│  │            │   Port 80  (HTTP)  │            │   │
│  │            │   Port 443 (HTTPS) │            │   │
│  │            └────────────────────┘            │   │
│  └──────────────────────────────────────────────┘   │
│                                                     │
│  ┌──────────────────────────────────────────────┐   │
│  │                                              │   │
│  │                                              │   │
│  │   S3 Bucket: terraform-state-1               │   │
│  │   Key:       dev/terraform.tfstate           │   │
│  │   Locking:   S3 native (use_lockfile=true)   │   │
│  └──────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Resources Created

| Resource | Name | Description |
|---|---|---|
| `aws_instance` | apache-server | EC2 with Apache2 (t3.micro) |
| `aws_instance` | nginx-server | EC2 with Nginx (t3.large) |
| `aws_security_group` | terraform-sg | Allows SSH, HTTP, HTTPS |
| `aws_default_vpc` | terraform-vpc | Default VPC |
| `aws_key_pair` | keypair_name | SSH Key Pair |

## Security Group Rules

| Type | Port | Protocol | Source |
|---|---|---|---|
| Ingress | 22 | TCP | Your IP only |
| Ingress | 80 | TCP | 0.0.0.0/0 |
| Ingress | 443 | TCP | 0.0.0.0/0 |
| Egress | All | All | 0.0.0.0/0 |

## Remote State Backend

State is managed by the `remote-infra` project. This project only consumes the backend:

```hcl
backend "s3" {
  bucket       = "terraform-state-1"
  key          = "dev/terraform.tfstate"
  region       = "ap-south-1"
  use_lockfile = true    # S3 native locking, no DynamoDB needed (Terraform >= 1.10)
  encrypt      = true
}
```

> The S3 bucket is created and managed separately in the `remote-infra` project and should never be destroyed.

## Prerequisites

- Terraform >= 1.10
- AWS CLI configured with appropriate permissions
- SSH public key at `keypair_name.pub`
- S3 bucket (`terraform-state-1`) already created via `remote-infra` project

## Project Structure

```
terraform-aws-ec2-stack/
├── main.tf           # EC2, VPC, SG, KeyPair resources
├── variable.tf       # Input variables
├── output.tf         # Output values
├── terraform.tf      # Provider and backend config
├── keypair_name.pub
└── userdata/
    ├── apache-install.sh
    └── nginx-install.sh
```

## Usage

```bash
# Step 1 - Create remote state backend first (only once)
cd ../remote-infra
terraform apply

# Step 2 - Initialize and deploy this project
cd ../terraform-aws-ec2-stack
terraform init
terraform plan
terraform apply

# Destroy only EC2 infra (never destroy remote-infra)
terraform destroy
```

## Outputs

| Output | Description |
|---|---|
| `ec2_public_ip` | Public IPs of all EC2 instances |
| `ec2_private_ip` | Private IPs of all EC2 instances |
| `ec2_tags` | Tags assigned to each instance |
| `ec2_instance_type` | Instance types of each EC2 |

## Variables

| Variable | Default | Description |
|---|---|---|
| `ec2_instance_type` | apache/nginx map | EC2 instance definitions (ami, type, userdata) |
| `ec2_key_pair_name` | `keypair_name` | SSH key pair name |
| `ec2_root_volume_size` | `30` | Root EBS volume size in GB |
| `ec2_security_group_name` | `terraform-sg` | Security group name |
| `ec2_vpc_name` | `terraform-vpc` | VPC name tag |
