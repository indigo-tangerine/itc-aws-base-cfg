## Cloudwatch Logs

#tfsec:ignore:aws-cloudwatch-log-group-customer-key 
resource "aws_cloudwatch_log_group" "ecs_fargate" {
  name              = "${var.client}-ecs-fargate-cluster"
  retention_in_days = 3
}

#tfsec:ignore:aws-ecs-enable-container-insight
resource "aws_ecs_cluster" "main" {
  name = "${var.client}-fargate"

  configuration {
    execute_command_configuration {

      logging = "OVERRIDE" # must be override if log_configuration specified

      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_fargate.name
      }
    }
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
