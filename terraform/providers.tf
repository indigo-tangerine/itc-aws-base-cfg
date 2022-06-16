provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
  assume_role {
    role_arn     = local.aws_provider_assume_role_arn
    session_name = "${var.github_actions_session_name}Terraform"
    external_id  = var.aws_role_external_id
  }
  default_tags {
    tags = local.default_tags
  }
}

