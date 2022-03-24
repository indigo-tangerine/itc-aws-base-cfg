# Account public access block
resource "aws_s3_account_public_access_block" "account" {
  block_public_acls   = true
  block_public_policy = true
}

# TFM State bucket

#tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-encryption
resource "aws_s3_bucket" "tfm_state" {

  bucket = "tfm-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "tfm-state-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_acl" "tfm_state" {
  bucket = aws_s3_bucket.tfm_state.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "tfm_state" {
  bucket = aws_s3_bucket.tfm_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

#tfsec:ignore:aws-s3-ignore-public-acls
resource "aws_s3_bucket_public_access_block" "tfm_state" {
  bucket = aws_s3_bucket.tfm_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "tfm_state" {
  bucket = aws_s3_bucket.tfm_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
