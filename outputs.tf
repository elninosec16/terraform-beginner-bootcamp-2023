# #To display the random_string using TF output command
# #output command for this section could be either id or result 
# output "btcamp_bucket_name" {
#   description = "S3 bucket name from outputs from module terraform_aws"
#   value = module.terraform_aws.btcamp_bucket_name
#   
# }
# 
# output "s3_website_endpoint" {
#   description = "S3 bucket name from outputs from module terraform_aws"
#   value = module.terraform_aws.s3_website_endpoint
#   
# }
# 
# output "cloudfront_distribution_url" {
#   description = "CloudFront distribution static website CLoudFront URL"
#   value = module.terraform_aws.cloudfront_distribution_url
# } 