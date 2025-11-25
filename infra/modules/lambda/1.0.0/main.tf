# ---- Trust policy: Lambda can assume this role ----
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "${var.name}-role-${var.environment}"
  path               = "/karoosoftware/${var.environment}/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.function_handler
  runtime       = "python3.13"
  filename      = var.filename
  source_code_hash = var.source_code_hash
  publish            = true
  timeout = 5

  environment {
    variables = merge(
      { ENVIRONMENT = var.environment },
      { for k, v in var.env_vars : k => tostring(v) } # ensure strings
    )
  }

}

resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.policies)
  role       = aws_iam_role.lambda_exec.name
  policy_arn = each.value
}

# --- CloudWatch logs ---
data "aws_iam_policy_document" "cloudWatch_publish" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:eu-west-2:992468223519:log-group:/aws/lambda/${var.function_name}:*"
    ]
  }
}

resource "aws_iam_policy" "cloudWatch_publish_policy" {
  name        = "karoosoftware-lambda-cloudwatch-${var.function_name}-${var.environment}"
  description = "Publish to CloudWatch logs for Lambda ${var.function_name}"
  path        = "/karoosoftware/${var.environment}/policies/"
  policy      = data.aws_iam_policy_document.cloudWatch_publish.json

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.cloudWatch_publish_policy.arn
}

output "arn"       { value = aws_lambda_function.this.arn }
output "invoke_arn"{ value = aws_lambda_function.this.invoke_arn }