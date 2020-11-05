variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type = string
}

variable "aws_access_key" {
  description = "AWS access key ID"
  type = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type = string
}

variable "aws_session_token" {
  description = "AWS session token"
  type = string
}

variable "index_document" {
  description = "Key of the object that will be the root of the static site."
  type = string
  default = "index.html"
}

variable "error_document" {
  description = "Key of the object that will be rendered for errors."
  type = string
  default = "error.html"
}
