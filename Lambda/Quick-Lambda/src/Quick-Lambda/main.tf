terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "./state/terraform.tfstate"
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "dotnet_lambda" {
  filename         = "./bin/Release/net6.0/Quick-Lambda.zip"
  function_name    = "QuickLambda"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "Quick-Lambda::Quick_Lambda.Function::FunctionHandler"  # Update with your actual handler
  runtime          = "dotnet6"  # Update with your Lambda runtime
  source_code_hash = "Quick-Lambda.zip"
}

#resource "aws_s3_bucket_object" "lambda_code" {
#  bucket       = aws_s3_bucket.lambda_code_bucket.id
#  key          = "your-lambda-code.zip"  # Set the desired key name
#  source       = aws_lambda_function.dotnet_lambda.filename
#  etag         = filemd5(aws_lambda_function.dotnet_lambda.filename)
#  content_type = "application/zip"
#}
#
#output "lambda_invoke_arn" {
#  value = aws_lambda_function.dotnet_lambda.invoke_arn
#}

#output "s3_bucket_url" {
#  value = aws_s3_bucket.lambda_code_bucket.website_endpoint
#}