#S3 configuration
resource "aws_s3_bucket" "s3-btcamp-tst" {
  #S3 name restriction
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
  bucket = var.s3_bucket_name
  
  tags = {
    UserUUID = var.user_uuid
    Name     = var.s3_bucket_name
  }
}