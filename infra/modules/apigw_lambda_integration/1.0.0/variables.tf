variable "environment" {
  type        = string
  description = "Environment name (e.g. staging, preprod, prod)"
}

variable "routes" {
  description = "Map of routes -> { lambda_arn, method, path }"
  type = map(object({
    lambda_arn = string
    method     = string # GET, POST, ANY
    path       = string # /hello, /items/{id}
    authorize  = bool
  }))
}

variable "api_id" {
  type = string
  description = "API id"
}

variable "execution_arn" {
  type = string
  description = "API Gateway execution ARN for the API (e.g., arn:aws:execute-api:eu-west-2:123456789012:abc123def4)."
}

variable "authorizer_id" {
  type        = string
  description = "Authorizer ID to attach to protected routes (JWT/Lambda)."
}