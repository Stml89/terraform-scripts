resource "aws_cloudwatch_event_rule" "morning_rule" {
  name                = "morning_rule"
  description         = "Rule to trigger Lambda function at 10 AM"
  schedule_expression = "cron(56 15 * * ? *)"

}

resource "aws_cloudwatch_event_rule" "evening_rule" {
  name                = "evening_rule"
  description         = "Rule to trigger Lambda function at 6 PM"
  schedule_expression = "cron(0 16 * * ? *)"

}

resource "aws_cloudwatch_event_target" "morning_lambda_target" {
  rule      = aws_cloudwatch_event_rule.morning_rule.name
  arn       = aws_lambda_function.ec2_start.arn
  target_id = "morning_lambda_target"
}

resource "aws_cloudwatch_event_target" "evening_lambda_target" {
  rule      = aws_cloudwatch_event_rule.evening_rule.name
  arn       = aws_lambda_function.ec2_stop.arn
  target_id = "evening_lambda_target"
}


resource "aws_lambda_permission" "ec2_start_perm" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.morning_rule.arn
}

resource "aws_lambda_permission" "ec2_stop_perm" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evening_rule.arn
}
