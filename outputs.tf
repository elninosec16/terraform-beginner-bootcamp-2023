#To display the random_string using TF output command
#output command for this section could be either id or result 
output "btcamp_bucket_name" {
  description = "S3 bucket name from outputs from module terraform_aws"
  value = module.home_peques_hosting.btcamp_bucket_name
    
}

output "s3_website_endpoint" {
  description = "S3 bucket name from outputs from module terraform_aws"
  value = module.home_peques_hosting.s3_website_endpoint
  
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront distribution static website CLoudFront URL"
  value = module.home_peques_hosting.cloudfront_distribution_domain_name
  
} 