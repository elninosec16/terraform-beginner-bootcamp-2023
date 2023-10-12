
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

terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023"
  description = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with alot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "3fdq3gz.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}