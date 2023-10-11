# #how to use random provider
# terraform {
#     cloud {
#     organization = "ElninoSec16"
# 
#     workspaces {
#       name = "tf-beginner-bootcamp-wkspce"
#     }
#   }
# }  
# 
# provider "aws" {
#     
#   default_tags {
#     tags = {
#         user_uuid   = var.user_uuid
#         Terraform   = "True"
#         Project	    = "TF BootCamp Beginner 2003"
#     }
#   }
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
  endpoint  = "http://localhost:4567"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token     = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}


