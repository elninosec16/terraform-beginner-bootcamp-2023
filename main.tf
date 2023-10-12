#S3 configuration
#resource "aws_s3_bucket" "s3-btcamp-tst" {
#  #S3 name restriction
#  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
#  bucket = var.s3_bucket_name
#
#}

# module "terraform_aws" {
#   source = "./modules/terrahouse_aws"
#   
#   
#   user_uuid           = var.user_uuid
#   s3_bucket_name      = var.s3_bucket_name
#   terraform           = var.terraform
#   project_name        = var.project_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version     = var.content_version
#   assets_path         = var.assets_path
# 
# }

resource "terratowns_home" "home" {
  name            = "How to play Arcanum in 2023"
  description     = "Arcanum is a game from 2001 that shipped with a lot of bugs."
  #domain_name     = module.terrahouse_aws.cloudfront_url
  domain_name     = "3xf332sdfs.cloudfront.net"
  town            = "gamers-grotto"
  content_version = 1
}