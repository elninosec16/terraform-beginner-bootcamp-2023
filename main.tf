#random_string to generate random string
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "bucket_name" {
  lower     = true
  upper     = false
  length    = 32
  special   = false
}

#S3 configuration
resource "aws_s3_bucket" "s3-btcamp-tst" {
  #S3 name restriction
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
  bucket = random_string.bucket_name.result

  tags = {
    Name        = "s3-tf-bootcamp-1"
    Environment = "bootcamp-2023"
    Terraform	  = "True"
  }
}
