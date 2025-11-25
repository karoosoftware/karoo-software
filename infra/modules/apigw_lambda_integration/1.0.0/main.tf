
resource "aws_apigatewayv2_route" "route" {
  for_each  = var.routes
  api_id    = var.api_id
  route_key = "${upper(each.value.method)} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.intg[each.key].id}"

  authorization_type = each.value.authorize ? "JWT" : "NONE"
  authorizer_id      = each.value.authorize ? var.authorizer_id : null
}

resource "aws_apigatewayv2_integration" "intg" {
  for_each           = var.routes
  api_id             = var.api_id
  integration_type   = "AWS_PROXY"
  integration_uri    = each.value.lambda_arn
  payload_format_version = "2.0"
}

# Allow API Gateway to invoke each Lambda
resource "aws_lambda_permission" "invoke" {
  for_each      = var.routes
  statement_id  = "AllowInvoke-${replace(each.key, "/[^A-Za-z0-9]/", "-")}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.execution_arn}/${var.environment}/${each.value.method}${each.value.path}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}