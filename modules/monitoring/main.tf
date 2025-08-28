resource "aws_sns_topic" "alerts" {
  name = "${var.project}-${var.environment}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Example: ALB 5xx errors alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project}-${var.environment}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  dimensions = {
    LoadBalancer = replace(var.alb_arn, "arn:aws:elasticloadbalancing:${var.region}:", "")
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}
