variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
  sensitive   = true
}

# AWS region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Environment details
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "environment_config" {
  description = "Configuration for multiple environments"
  type = map(object({
    cidr_block         = string
    public_subnet_cidr = string
    ami_id             = string
    instance_type      = string
  }))
  default = {
    dev = {
      cidr_block         = "10.0.0.0/16"
      public_subnet_cidr = "10.0.1.0/24"
      ami_id             = "ami-0c02fb55956c7d316" # Free Tier AMI
      instance_type      = "t2.micro"
    }
    staging = {
      cidr_block         = "10.1.0.0/16"
      public_subnet_cidr = "10.1.1.0/24"
      ami_id             = "ami-0c02fb55956c7d316" # Free Tier AMI
      instance_type      = "t2.micro"
    }
    prod = {
      cidr_block         = "10.2.0.0/16"
      public_subnet_cidr = "10.2.1.0/24"
      ami_id             = "ami-0c02fb55956c7d316" # Free Tier AMI
      instance_type      = "t2.micro"
    }
  }
}
