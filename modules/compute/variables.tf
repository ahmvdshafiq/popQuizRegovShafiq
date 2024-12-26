#Declares input variables required by the compute module.

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, qa, uat, prod)"
  type        = string
}

