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