#S3 configuration
resource "aws_s3_bucket" "s3-btcamp-tst" {
  #S3 name restriction
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketRestrictions.html
  bucket = var.s3_bucket_name
  
  tags = {
    UserUUID = var.user_uuid
    Name     = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.s3-btcamp-tst

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 #routing rule is not required for this config
 # routing_rule {
 #   condition {
 #     key_prefix_equals = "docs/"
 #   }
 #   redirect {
 #     replace_key_prefix_with = "documents/"
 #   }
 # }
}

resource "aws_s3_object" "index_object" {
  bucket = var.s3_bucket_name
  key    = "index.html"
  source = var.index_html_filepath

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.index_html_filepath)
}

resource "aws_s3_object" "error_object" {
  bucket = var.s3_bucket_name
  key    = "error.html"
  source = var.error_html_filepath

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.error_html_filepath)
}