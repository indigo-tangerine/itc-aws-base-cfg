# GitHub Actions Role
resource "aws_iam_role" "github_actions" {
  name = local.github_actions_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = ["repo:${var.github_org}/*"]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_actions" {
  name = "cicd-automation"
  role = aws_iam_role.github_actions.name

  policy = data.aws_iam_policy_document.cicd_automation.json
}

# CICD Automation Role
resource "aws_iam_role" "cicd_automation" {
  name = local.cicd_automation_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.cicd_automation_role_name}",
            "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${local.github_actions_role_name}/${var.github_actions_session_name}"
          ]
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.aws_role_external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cicd_automation" {
  role       = aws_iam_role.cicd_automation.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# CICD User
resource "aws_iam_user" "cicd_automation" {
  name = "${var.client}-cicd-automation"
  path = "/"
}

resource "aws_iam_access_key" "cicd_automation" {
  user = aws_iam_user.cicd_automation.name
}

resource "aws_iam_user_policy" "cicd_automation" {
  name   = "cicd-automation"
  user   = aws_iam_user.cicd_automation.name
  policy = data.aws_iam_policy_document.cicd_automation.json
}

# Github OIDC Provider

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "cicd_automation" {
  statement {
    sid    = "TfmStateS3Access"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.tfm_state.arn,
      "${aws_s3_bucket.tfm_state.arn}/*"
    ]
  }
  statement {
    sid    = "AllowAssumeCicdRole1"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:GetFederationToken"
    ]
    resources = [aws_iam_role.cicd_automation.arn]
  }
  statement {
    sid    = "AllowAssumeCicdRole2"
    effect = "Allow"
    actions = [
      "sts:GetSessionToken",
      "sts:GetAccessKeyInfo",
      "sts:GetCallerIdentity",
      "sts:GetServiceBearerToken"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowAccessStateLockTable"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.tfm_state_lock.arn]
  }
}

