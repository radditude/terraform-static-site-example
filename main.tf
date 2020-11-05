terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token = var.aws_session_token
}

# Create the S3 bucket and configure it for static site hosting
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  acl    = "public-read"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  force_destroy = true
}

# Create the index page in our teeny static site
resource "aws_s3_bucket_object" "site" {
  bucket = aws_s3_bucket.s3_bucket.id
  key = var.index_document
  source = "www/${var.index_document}"
  content_type = "text/html"
}

# Create the error page to be served for 404s.
resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.s3_bucket.id
  key = var.error_document
  source = "www/${var.error_document}"
  content_type = "text/html"
}

# Output the address of our new static site
output "website_endpoint" {
  description = "Domain name of the bucket"
  value       = aws_s3_bucket.s3_bucket.website_endpoint
}
