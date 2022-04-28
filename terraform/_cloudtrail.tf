#tfsec:ignore:aws-cloudtrail-enable-all-regions tfsec:ignore:aws-cloudtrail-enable-at-rest-encryption tfsec:ignore:aws-cloudtrail-enable-log-validation
resource "aws_cloudtrail" "main" {
  name                          = "${var.client}-default-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = false
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_logging.arn
  is_multi_region_trail         = false
  is_organization_trail         = true
  enable_log_file_validation    = false
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key 
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.client}-cloudtrail-default"
  retention_in_days = 3
}

