# This is broken atm due to error: 

# module "sqs-with-dlq" {
#   source  = "damacus/sqs-with-dlq/aws"
#   version = "1.0.2"
#   # insert the 1 required variable here
#   name = local.sqs_name
#   tags = local.tags
# }

resource "aws_sqs_queue" "this" {
  name = local.queue_name
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "${local.queue_arn}/SQSDefaultPolicy",
    Statement = [
      {
        Sid    = "${var.prefix}-AllowSNSAccess-${var.sns_topic_name}-SQS-${local.queue_name}}",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action   = "SQS:SendMessage",
        Resource = local.queue_arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.sns_topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = var.sns_topic_arn
  protocol  = "sqs"
  endpoint  = local.queue_arn
}
