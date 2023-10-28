resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"
}

resource "aws_sqs_queue" "queue" {
  name = "my-quick-queue"
}