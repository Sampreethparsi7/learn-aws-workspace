terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-09256c524fab91d36"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Security group for example application"
  vpc_id      = "vpc-0e8508b42b8b9410e"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- S3 bucket with versioning enabled ---
resource "aws_s3_bucket" "example" {
  # Using bucket_prefix lets AWS generate a unique bucket name for you
  bucket_prefix = "example-tf-bucket-"

  tags = {
    Name = "ExampleBucket"
  }
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}