resource "aws_iam_service_linked_role" "cloudtrail" {
  aws_service_name = "cloudtrail.amazonaws.com"
}

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
