resource "aws_iam_role" "snyk" {
  name = "snyk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::198361731867:user/ecr-integration-user"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "67f01e4c-c55f-4ecc-b949-d4dc836fc39d"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "snyk" {
  name = "AmazonEC2ContainerRegistryReadOnlyForSnyk"
  role = aws_iam_role.snyk.name

  policy = data.aws_iam_policy_document.snyk.json
}
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "snyk" {
  statement {
    sid    = "SnykEcrAccess"
    effect = "Allow"
    actions = [
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:ListTagsForResource",
      "ecr:ListImages",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:GetLifecyclePolicy",
    ]
    resources = [
      "*"
    ]
  }
}
