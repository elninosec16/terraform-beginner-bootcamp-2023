variable "teacherseat_user_uuid" {
  description = "User UUID"
  
}

variable "terratowns_access_code" {
  description = "API access code to terratwons"
  
}

variable "terraform" {
  description = "terraform manage resource"
  type        = string
}

variable "terratowns_endpoint" {
  description = "real URL to terratowns cloud env"
  type = string
}

variable "project_name" {
  description = "Project name definition"
  type        = string
   
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket name"
  type        = string
  
  validation {
    condition = (
      length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.s3_bucket_name))
    )
    
    error_message = "The bucket name must be between 3 and 63 characters"
  }
}

#variable "index_html_filepath" {
#  description = "The file path for index.html"
#  type        = string
#  
#  validation {
#    condition     = fileexists(var.index_html_filepath)
#    error_message = "The provided path for index.html does not exist." 
#  }
#}
#
#variable "error_html_filepath" {
#  description = "The file path for error.html"
#  type        = string
#  
#  validation {
#    condition     = fileexists(var.error_html_filepath)
#    error_message = "The provided path for error.html does not exist." 
#  }
#}

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
   
}

variable "content_version" {
  description = "The content version should be a positive integer starting at 1."
  type = number
  
  validation {
    condition = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The content_version variable must be a positive integer starting at 1."
  }
}

#variable "assets_path" {
#  description = "New assets path variable"
#  type        = string
#}