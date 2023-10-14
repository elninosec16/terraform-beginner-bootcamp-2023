variable "teacherseat_user_uuid" {
  description = "User UUID"
  type        = string
  
}

variable "terratowns_access_code" {
  description = "API access code to terratwons"
  type        = string

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
  
}

variable "arepa" {
  description = "public_path for area home"
  type = object ({
    public_path = string
    content_version = number
  })
  
}

variable "peques" {
  description = "public_path for peques home"
  type = object ({
    public_path = string
    content_version = number
  })
  
}

#variable "index_html_filepath" {
#  description = "The file path for index.html"
#  type        = string
#  
#}
#
#variable "error_html_filepath" {
#  description = "The file path for error.html"
#  type        = string
#  
#}
#
#variable "content_version" {
#  description = "The content version should be a positive integer starting at 1."
#  type = number
#
#}

variable "assets_path" {
  description = "New assets path variable"
  type        = string
}