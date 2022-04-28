# Cloudtrail Log Bucket

#tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning tfsec:ignore:aws-s3-enable-bucket-encryption tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "cloudtrail" {

  bucket = "cloudtrail-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "cloudtrail-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_acl" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  acl    = "private"
}

#tfsec:ignore:aws-s3-ignore-public-acls
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.tfm_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }


}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
}
