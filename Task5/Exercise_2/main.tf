provider "aws" {
  region = var.aws_region
  access_key = "ASIAVROHAM24YBGL4VD6"
  secret_key = "Xciv0zR2LyHJSDMjRuo3VINY1LLNOVeMbqInstkz"
  token      = "FwoGZXIvYXdzEOj//////////wEaDBZC3Ok0SYlFFieySSLVAT4eCUj6iUh+xPkLruoYnli+nAlgd6IK9rVxmAe6rnp0oKzdUw4+9Js7wL38Vxi0FHg5WhK44REk4SQUpLmEoQrYCw+9WioVffG0tE3nnS0e3Vwmsa5DaXlNt1LoMZH8+lpXI/TsEJyDJSRYY2cgPjvFgLPft7pMy1jYqI1GMG7wD5r5l1L24C9gJehETKEVAi/BqkOA0v6IsYdkf19KVmumq4ItWgo9UCzhk/V+7xtXnlAF2v7H0XvZh6CZNyFFMxJemPrpFLA/bJN0Y7NzmHq1s1BlxCj0o5OiBjItK51eej/NqOU4YizZM9j1ubOMXGRKLwgqHfNDOAXVFeeJrjQGqRlks8XojFLW"
}


data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = "output.zip"
}


# Lambda role configuration
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# Cloudwatch configuration
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name        = "lambda_logs_policy"
  path        = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}


# Lambda function
resource "aws_lambda_function" "geeting_lambda" {
  function_name = "greet_lambda"
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "greet_lambda.lambda_handler"
  runtime = "python3.9"
  role = aws_iam_role.lambda_exec_role.arn

  environment{
      variables = {
          greeting = "Hello World!, I am Sanh Tuan"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}