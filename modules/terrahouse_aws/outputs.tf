output "btcamp_bucket_name" {
  description = "S3 bucket name from outputs from module terraform_aws"
  value = aws_s3_bucket.s3-btcamp-tst.bucket

}

output "s3_website_endpoint" {
  description = "S3 bucket name from outputs from module terraform_aws"
  value = aws_s3_bucket_website_configuration.website_config

}

output "cloudfront_distribution_url" {
  description = "CloudFront distribution static website CLoudFront URL"
  value = aws_cloudfront_distribution.s3_bucket_distribution.domain_name
} 