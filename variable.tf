variable ec2_instance_type {
    type = map(object({
      ami = string
      type = string
      user_data = string
    }))
    
    default = {
      "apache-server" = {
        ami = "ami-01a00762f46d584a1"
        type = "t3.micro"
        user_data = "./userdata/apache-install.sh"
      }
      "nginx-server" = {
        ami = "ami-006f82a1d5a27da54"
        type = "t3.large"
        user_data = "./userdata/nginx-install.sh"
      }
    }
}

variable ec2_key_pair_name {
    type = string
    default = "aws-keypair-mumbai"
    description = "This is the name of the key pair for the EC2 instance"
}

variable ec2_instance_count {
    type = number
    default = 1
    description = "This is the count of Instance"
}

variable ec2_instance_name {
    type = string
    default = "terraform-ec2-instance"
    description = "This is the name of the EC2 instance"
}

variable ec2_key_pair_public_key {
    type = string
    default = "aws-keypair-mumbai.pub"
    description = "This is the public key for the key pair"
}

variable ec2_root_volume_size {
    type = number
    default = 30
    description = "This is the size of the root volume in GB"
}

variable ec2_vpc_type {
    type = string
    default = "default"
    description = "This is the default type of VPC to create"
}
variable ec2_vpc_name {
    type = string
    default = "terraform-vpc"
    description = "This is the name of the default VPC created by Terraform"
}

variable ec2_security_group_name {
    type = string
    default = "terraform-sg"
    description = "This is the security group for Terraform VPC"
}

variable ec2_ingress_ssh_port {
    type = number
    default = 22
    description = "The SSH port for the security group"
}
variable ec2_ssh_cidr_blocks {
    type = list(string)
    default = ["103.254.245.70/32"]
}

variable ec2_http_cidr_blocks {
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable ec2_ingress_http_port {
    type = number
    default = 80
    description = "The HTTP port for the security group"
}

variable ec2_https_cidr_blocks {
    type = list(string)
    default = ["0.0.0.0/0"]
}


variable ec2_ingress_https_port {
    type = number
    default = 443
    description = "The HTTPS port for the security group"
}

variable ec2-egress_all_port {
    type = number
    default = 0
    description = "The All port for the security group"
}

variable ec2_egress_all_cidr_blocks {
    type = list(string)
    default = ["0.0.0.0/0"]
}

# variable ec2_instance_nginx_user_data {
#     type = string
#     default = "nginx-install.sh"
#     description = "This is the user data script for the EC2 instance"
# }

# variable "ec2_insatnce_apache2_user_date" {
#     type = string
#     default = "apache-install.sh"
#     description = "This is the apache installation script."
# }   

variable "s3_bucket" {
    type = string
    description = "The name of the S3 bucket"
    default = "artechworld-state-1"
}

variable "s3_versioning" {
    type = string
    description = "Enable versioning for S3 bucket"
    default = "Enabled"
}

variable "s3_block_public_acls" {
    type = string
    description = "S3 Block Public ACLs"
    default = "true"
}

variable "s3_block_public_policy" {
    type = string
    description = "S3 Block Public Policy"
    default = "true"
}

variable "s3_ignore_public_acls" {
    type = string
    description = "S3 Ignore Public ACLs"
    default = "true"
}

variable "s3_restrict_public_buckets" {
    type = string
    description = "S3 Restrict Public Buckets"
    default = "true"
}

variable "sse_algorithm" {
    type = string
    description = "Server-side encryption algorithm"
    default = "AES256"
}

