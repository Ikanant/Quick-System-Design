resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"
}

resource "aws_sqs_queue" "queue" {
  name = "my-quick-queue"
}

resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = "arn:aws:lambda:us-east-1:000000000000:function:QuickLambda"
}

resource "aws_sns_topic" "topic" {
  name = "my-quick-topic"
}

resource "aws_sns_topic_subscription" "queue_sub" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue.arn
}