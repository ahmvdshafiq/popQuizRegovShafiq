# variables.tf
variable "github_repo" {
  description = "URL of the GitHub repository for source code"
  type        = string
}

variable "s3_input_bucket_name" {
  description = "Name of the input data S3 bucket"
  type        = string
}

variable "s3_output_bucket_name" {
  description = "Name of the output data S3 bucket"
  type        = string
}

variable "batch_schedule_expression" {
  description = "Schedule expression for batch job execution"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}


variable "vpc_id" {
  description = "ID of the VPC for Fargate"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Fargate networking"
  type        = list(string)
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  default     = "batch-job-repo"
}

