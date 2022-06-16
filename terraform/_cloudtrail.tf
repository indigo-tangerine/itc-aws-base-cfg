#tfsec:ignore:aws-cloudtrail-enable-all-regions tfsec:ignore:aws-cloudtrail-enable-at-rest-encryption tfsec:ignore:aws-cloudtrail-enable-log-validation
resource "aws_cloudtrail" "main" {
  name                          = "${var.client}-default-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_logging.arn
  is_multi_region_trail         = false
  is_organization_trail         = true
  enable_log_file_validation    = true
  event_selector {
    exclude_management_event_sources = ["kms.amazonaws.com", "rdsdata.amazonaws.com"]
    include_management_events        = true
    read_write_type                  = "WriteOnly" # "ReadOnly", "All"
  }

}

## Cloudwatch Logs

#tfsec:ignore:aws-cloudwatch-log-group-customer-key 
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.client}-cloudtrail-default"
  retention_in_days = 3
}

## IAM Service Linked Role

resource "aws_iam_service_linked_role" "cloudtrail" {
  aws_service_name = "cloudtrail.amazonaws.com"
}

## IAM Role - Logging

resource "aws_iam_role" "cloudtrail_logging" {
  name               = local.cloudtrail_logging_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_logging_assume_role_policy.json
}

data "aws_iam_policy_document" "cloudtrail_logging_assume_role_policy" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "cloudtrail_logging" {
  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail_logging" {
  name = "cicd-automation"
  role = aws_iam_role.cloudtrail_logging.name

  policy = data.aws_iam_policy_document.cloudtrail_logging.json
}
