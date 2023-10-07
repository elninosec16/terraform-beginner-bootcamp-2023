variable "user_uuid" {
  description  = "The UUID of the uer"
  type        = string
}

variable "terraform" {
  description = "terraform manage resource"
  type        = string
}

variable "project_name" {
  description = "Project name definition"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket name"
  type        = string
  
}

variable "index_html_filepath" {
  description = "The file path for index.html"
  type        = string
  
}

variable "error_html_filepath" {
  description = "The file path for error.html"
  type        = string
  
}

variable "content_version" {
  description = "The content version should be a positive integer starting at 1."
  type = number

}