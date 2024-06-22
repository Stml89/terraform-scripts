variable "region" {
  description = "Value of the region name"
  type        = string
  default     = "<region>"
}

variable "instance_id" {
  description = "Value of the instance id to start/stop EC2 instance"
  type        = list(string)
  default     = ["<instance_id>"]
}

resource "aws_iam_policy" "policy" {
  name        = "ec2_stop_start_policy"
  path        = "/"
  description = "ec2_stop_start_policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Start*",
          "ec2:Stop*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_auto_attach" {
  name       = "ec2_stop_start_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.lambda_role.name
}

data "archive_file" "souece_ec2_stop" {
  type        = "zip"
  source_file = "ec2_stop.py"
  output_path = "ec2_stop.zip"
}

resource "aws_lambda_function" "ec2_stop" {

  filename      = "ec2_stop.zip"
  function_name = "ec2_stop_auto"
  role          = aws_iam_role.lambda_role.arn
  handler       = "ec2_stop.lambda_handler"
  timeout       = 60

  source_code_hash = data.archive_file.souece_ec2_stop.output_base64sha256

  runtime = "python3.9"

  environment {
    variables = {
      REGION      = var.region
      INSTANCE_ID = join(",", var.instance_id)
    }
  }
}


data "archive_file" "souece_ec2_start" {
  type        = "zip"
  source_file = "ec2_start.py"
  output_path = "ec2_start.zip"
}

resource "aws_lambda_function" "ec2_start" {

  filename      = "ec2_start.zip"
  function_name = "ec2_start_auto"
  role          = aws_iam_role.lambda_role.arn
  handler       = "ec2_start.lambda_handler"
  timeout       = 60

  source_code_hash = data.archive_file.souece_ec2_start.output_base64sha256

  runtime = "python3.9"


  environment {
    variables = {
      REGION      = var.region
      INSTANCE_ID = join(",", var.instance_id)
    }
  }
}
