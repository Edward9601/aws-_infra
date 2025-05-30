terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0.0"
      }
    }
}

provider "aws" {
  region = "us-east-1"
  profile= "terraform-user"
}


resource "aws_s3_bucket" "recipe_media_bucket" {
    bucket = "recipe-project-media-bucket-dev"

    tags = {
        Name        = "recipe-app "
        Environment = "dev"
    }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "recipe_media_bucket" {
    bucket = aws_s3_bucket.recipe_media_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "recipe_media_bucket" {
    bucket = aws_s3_bucket.recipe_media_bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}