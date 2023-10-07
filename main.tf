#S3 configuration
#resource "aws_s3_bucket" "s3-btcamp-tst" {
#  #S3 name restriction
#  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
#  bucket = var.s3_bucket_name
#
#}

module "terraform_aws" {
  source = "./modules/terrahouse_aws"
  
  
  user_uuid           = var.user_uuid
  s3_bucket_name      = var.s3_bucket_name
  terraform           = var.terraform
  project_name        = var.project_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version

}