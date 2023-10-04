terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    } 
  }
 
}

provider "aws" {
  
  default_tags {
    tags = {
        Terraform   = "True"
        Project	    = "TF BootCamp Beginner 2003"
    }
  }
}

