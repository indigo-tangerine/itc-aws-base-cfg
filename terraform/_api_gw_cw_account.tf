resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cw_account.arn
}

resource "aws_iam_role" "api_gw_cw_account" {
  name = "api-gateway-cloudwatch-global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "api_gw_cw_account" {
  name = "default"
  role = aws_iam_role.api_gw_cw_account.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
