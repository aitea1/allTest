provider "aws" {
  alias  = "bedrock_us-east-1"
  region = "us-east-1"
}

resource "aws_s3_bucket" "trial_bedrock_batchstart" {
  provider = aws.bedrock_us-east-1
  bucket   = var.bucket_name
}