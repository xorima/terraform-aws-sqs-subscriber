output "sqs_arn" {
  value       = aws_sqs_queue.this.arn
  description = "ARN for the SQS Queue"
}
