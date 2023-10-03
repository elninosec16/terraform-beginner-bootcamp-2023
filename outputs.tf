#To display the random_string using TF output command
#output command for this section could be either id or result 
output "btcamp_bucket_name" {
  value = aws_s3_bucket.s3-btcamp-tst.bucket
}