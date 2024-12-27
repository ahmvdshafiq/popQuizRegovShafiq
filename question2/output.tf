output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "s3_input_bucket_name" {
  value = aws_s3_bucket.batch_data.bucket
}

output "s3_output_bucket_name" {
  value = aws_s3_bucket.batch_output.bucket
}
