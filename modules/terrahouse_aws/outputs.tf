output "btcamp_bucket_name" {
  description = "S3 bucket name from outputs from module terraform_aws"
  value = aws_s3_bucket.s3-btcamp-tst.bucket

}
