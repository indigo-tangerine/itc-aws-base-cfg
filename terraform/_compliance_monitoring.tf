
locals {
  cloudtrail_cloudwatch_metric_filters = {
    no_mfa_console_signin_metric = {
      pattern = "{($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
      # metric_transformation = {
      #   name      = "no_mfa_console_signin_metric"
      #   namespace = "CISBenchmark"
      #   value     = "1"
      # }
    }
    unauthorized_api_calls_metric = {
      pattern = "{($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\")}"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail" {
  for_each = local.cloudtrail_cloudwatch_metric_filters

  name    = "cloudtrail_${each.key}"
  pattern = each.value.pattern
  metric_transformation {
    name      = try(each.value.metric_transformation.name, each.key)
    namespace = try(each.value.metric_transformation.namespace, "CISBenchmark")
    value     = try(each.value.metric_transformation.value, "1")
  }
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail" {
  for_each = local.cloudtrail_cloudwatch_metric_filters

  alarm_name                = "cloudtrail_${each.key}"
  comparison_operator       = try(each.value.alarm.comparison_operator, "GreaterThanOrEqualToThreshold")
  evaluation_periods        = try(each.value.alarm.evaluation_periods, "1")
  metric_name               = try(each.value.metric_transformation.name, each.key)
  namespace                 = try(each.value.metric_transformation.namespace, "CISBenchmark")
  period                    = try(each.value.alarm.period, "120")
  statistic                 = try(each.value.alarm.statistic, "Sum")
  threshold                 = try(each.value.alarm.threshold, "1")
  alarm_description         = try(each.value.alarm.description, "cloudtrail_${each.key}")
  insufficient_data_actions = try(each.value.alarm.insufficient_data_actions, null)
  alarm_actions             = try(each.value.alarm.alarm_actions, null)
}
