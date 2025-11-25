
resource "aws_apigatewayv2_api" "this" {
  name          = var.apigw_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.allow_origins
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["content-type"]
    expose_headers = ["x-request-id"]
    max_age        = 86400
    allow_credentials = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.environment
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 5   # burst tokens
    throttling_rate_limit = 1   # steady RPS
  }

  # Optional: tighten a single route: POST /early_adoption_form.py
  route_settings {
    route_key               = "POST /early_adoption_form"
    throttling_burst_limit  = 1
    throttling_rate_limit   = 1
  }

}

output "api_id"  { value = aws_apigatewayv2_api.this.id }
output "api_arn" { value = aws_apigatewayv2_api.this.arn }
output "execution_arn" { value = aws_apigatewayv2_api.this.execution_arn }