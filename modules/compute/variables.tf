#Declares input variables required by the compute module.

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod, qa, uat)"
  type        = string
}
