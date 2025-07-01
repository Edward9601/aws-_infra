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

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.recipe_media_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.recipe_media_bucket.arn}/*"
      }
    ]
  })
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

resource "aws_s3_bucket_cors_configuration" "recipe_media_bucket" {
    bucket = aws_s3_bucket.recipe_media_bucket.id

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = var.allowed_origins
        max_age_seconds = 3000
    }
}