locals {
  default_tags = {
    service_version = var.service_version == "<service-version>" ? "0.0.0" : var.service_version
    stage           = var.stage
    service_group   = var.service_group
    service         = var.service
    iac             = "terraform"
  }

  aws_provider_assume_role_arn = "arn:aws:iam::${var.aws_account_id}:role/${local.cicd_automation_role_name}"

  cicd_automation_role_name    = "${var.client}-cicd-automation"
  cicd_automation_user_name    = "${var.client}-cicd-automation"
  github_actions_role_name     = "${var.client}-github-actions"
  cloudtrail_logging_role_name = "${var.client}-cloudtrail-logs"

  dev_dns_name = "dev.${var.root_dns_domain_name}"

}
