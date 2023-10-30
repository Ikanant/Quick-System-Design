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