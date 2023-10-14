
terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid 
  token     = var.terratowns_access_code
}


#S3 configuration
resource "aws_s3_bucket" "s3-btcamp-tst" {
  #S3 name restriction
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
  bucket = var.s3_bucket_name

}

module "terrahouse_aws" {
  source = "/workspace/terraform-beginner-bootcamp-2023/modules/terrahouse_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  terratowns_access_code = var.terratowns_access_code
  terratowns_endpoint = var.terratowns_endpoint
  s3_bucket_name      = var.s3_bucket_name
  terraform           = var.terraform
  project_name        = var.project_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_path         = var.assets_path

}

resource "terratowns_home" "home" {
  name = "Los Peques"
  description = <<DESCRIPTION
Los Peques is a 3D animation trolls cartoons created in 2001 made in the Providence of Neuquen Argentina. 
Los Peques town was created in some place on the Andean Patagonian Montain Range of Neuquen. 
Los Peques' houses are called peque rukas. The main Peques caracters are Nino & Chicho. 
Los Peques is one of the best cartoons created in South America, and really fun to watch. 
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_distribution_url
  #domain_name = "3fdq3g456z.cloudfront.net"
  town = "missingo"
  content_version = var.content_version
}