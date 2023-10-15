
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
#resource "aws_s3_bucket" "s3-btcamp-tst" {
#  #S3 name restriction
#  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
#  bucket = var.s3_bucket_name
#
#}

#original module config
#module "terrahome_aws" {
#  source = "/workspace/terraform-beginner-bootcamp-2023/modules/terrahome_aws"
#  teacherseat_user_uuid = var.teacherseat_user_uuid
#  terratowns_access_code = var.terratowns_access_code
#  terratowns_endpoint = var.terratowns_endpoint
#  s3_bucket_name      = var.s3_bucket_name
#  terraform           = var.terraform
#  project_name        = var.project_name
#  index_html_filepath = var.index_html_filepath
#  error_html_filepath = var.error_html_filepath
#  content_version     = var.content_version
#  assets_path         = var.assets_path
#
#}

#peques home module
module "home_peques_hosting" {
  source = "/workspace/terraform-beginner-bootcamp-2023/modules/terrahome_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  terratowns_access_code = var.terratowns_access_code
  terratowns_endpoint = var.terratowns_endpoint
  public_path = var.peques.public_path
  content_version = var.peques.content_version
  s3_bucket_name      = var.s3_bucket_name
  terraform           = var.terraform
  project_name        = var.project_name
}

resource "terratowns_home" "home_peques" {
  name = "*** Los Peques ***"
  description = <<DESCRIPTION
Los Peques is a 3D animation trolls cartoons created in 2001 made in the Providence of Neuquen Argentina. 
Los Peques town was created in some place on the Andean Patagonian Montain Range of Neuquen. 
Los Peques' houses are called peque rukas. The main Peques caracters are Nino & Chicho. 
Los Peques is one of the best cartoons created in South America, and really fun to watch. 
DESCRIPTION
  domain_name = module.home_peques_hosting.cloudfront_distribution_domain_name
  #domain_name = "3fdq3g456z.cloudfront.net"
  town = "video-valley"
  content_version = var.peques.content_version
}

#module "home_arepa_hosting" {
#  source = "/workspace/terraform-beginner-bootcamp-2023/modules/terrahome_aws"
#  teacherseat_user_uuid = var.teacherseat_user_uuid
#  terratowns_access_code = var.terratowns_access_code
#  terratowns_endpoint = var.terratowns_endpoint
#  public_path = var.arepa.public_path
#  content_version = var.arepa.content_version
#  s3_bucket_name      = var.s3_bucket_name
#  terraform           = var.terraform
#  project_name        = var.project_name
#}

#arepa home module
#resource "terratowns_home" "home_arepa" {
#  name = "*** Arepa ***"
#  description = <<DESCRIPTION
#  Arepa is a type of food made of ground maize dough stuffed with a filling, 
#  eaten in northern parts of South America since pre-Columbian times, 
#  and notable primarily in the cuisine of Colombia and Venezuela, 
#  but also present in Bolivia, Ecuador, Nicaragua, and Panama.
#DESCRIPTION
#  domain_name = module.home_arepa_hosting.cloudfront_distribution_domain_name
#  #domain_name = "3fdq3g456z.cloudfront.net"
#  town = "cooker-cove"
#  content_version = var.arepa.content_version
#}