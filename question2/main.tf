# main.tf

# Input Data S3 Bucket
resource "aws_s3_bucket" "batch_data" {
  bucket = "batch-input-bucket-${random_string.unique_id.result}"  # Updated Line 4
  acl    = "private"
}

# output Data S3 Bucket
resource "aws_s3_bucket" "batch_output" {
  bucket = "batch-output-bucket-${random_string.unique_id.result}"  # Updated Line 13
  acl    = "private"
}

resource "random_string" "unique_id" {
  length  = 6
  special = false
  upper   = false
}


# ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name = "simple-docker-app"
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "codebuild.amazonaws.com" },
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# S3 Bucket for CodeBuild artifacts
resource "aws_s3_bucket" "build_artifacts" {
  bucket = "build-artifacts-${random_id.bucket_id.hex}"

  tags = {
    Name = "BuildArtifactsBucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# CodeBuild Project
resource "aws_codebuild_project" "build_project" {
  name         = "SimpleDockerBuild"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "GITHUB"
    location  = var.github_repo
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.app_repo.repository_url
    }
  }
}

# IAM Role for Fargate
resource "aws_iam_role" "fargate_role" {
  name = "FargateBatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "ecs-tasks.amazonaws.com" },
        Action   = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_policy" {
  role       = aws_iam_role.fargate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ECS Cluster
resource "aws_ecs_cluster" "batch_cluster" {
  name = "BatchJobCluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "batch_task" {
  family                   = "batch-job"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.fargate_role.arn
  container_definitions    = jsonencode([
    {
      name       = "batch-container"
      image      = aws_ecr_repository.app_repo.repository_url
      essential  = true
      environment = [
        {
          name  = "INPUT_BUCKET"
          value = aws_s3_bucket.batch_data.bucket
        },
        {
          name  = "OUTPUT_BUCKET"
          value = aws_s3_bucket.batch_output.bucket
        }
      ]
    }
  ])
}

# CloudWatch Event Rule for Scheduling
resource "aws_cloudwatch_event_rule" "batch_schedule" {
  name                = "BatchJobSchedule"
  schedule_expression = var.batch_schedule_expression
}


# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "batch_target" {
  rule = aws_cloudwatch_event_rule.batch_schedule.name
  arn  = aws_ecs_cluster.batch_cluster.arn  # Corrected to use the ECS cluster ARN

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.batch_task.arn
    task_count          = 1
    network_configuration {
      subnets         = var.subnet_ids
      assign_public_ip = true
    }
  }

  role_arn = aws_iam_role.cloudwatch_event_role.arn
}





# Permissions for CloudWatch to Invoke ECS
resource "aws_iam_role_policy" "cloudwatch_invoke_policy" {
  role = aws_iam_role.fargate_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecs:RunTask"],
        Resource = [aws_ecs_task_definition.batch_task.arn]
      }
    ]
  })
}

# IAM Role for CloudWatch to Invoke ECS
resource "aws_iam_role" "cloudwatch_event_role" {
  name = "CloudWatchEventInvokeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_event_role_policy" {
  role = aws_iam_role.cloudwatch_event_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecs:RunTask"],
        Resource = [
          aws_ecs_task_definition.batch_task.arn
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["iam:PassRole"],
        Resource = [
          aws_iam_role.fargate_role.arn
        ]
      }
    ]
  })
}

