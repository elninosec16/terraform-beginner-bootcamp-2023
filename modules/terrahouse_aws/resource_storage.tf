#S3 buckets `data source` configuration:
#description = "data source to get current aws account id"
data "aws_caller_identity" "s3_bucket_current_dsource" {}

#Terraform feature to define content version
resource "terraform_data" "content_version" {
  input = var.content_version
}

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
  bucket = aws_s3_bucket.s3-btcamp-tst.bucket

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
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.index_html_filepath)
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "error_object" {
  bucket = var.s3_bucket_name
  key    = "error.html"
  source = var.error_html_filepath
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.error_html_filepath)
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "upload_assets" {
  for_each      = fileset(var.assets_path,"*.{jpg,png,gif}")
  bucket        = aws_s3_bucket.s3-btcamp-tst.bucket
  key           = "assets/${each.key}" 
  source        = "${var.assets_path}/${each.key}"
  #content_type = "text.html"
  etag          = filemd5("${var.assets_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes       = [etag]
  }
}

#S3 local origin ID configuration:
locals {
  s3_origin_id = "myS3Origin"
}

#S3 bucket policies configuration
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "${var.s3_bucket_name}-policy"
  description = "TerraHouse S3 bucket policy"

  policy = jsonencode({
  "Version" =  "2012-10-17",
  "Statement" = {
      "Sid": "AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": {
         "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.s3-btcamp-tst.id}/*",
      "Condition": {
      "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.s3_bucket_current_dsource.account_id}:distribution/${aws_cloudfront_distribution.s3_bucket_distribution.id}"
        }
      },
    }
})
}