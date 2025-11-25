variable "apigw_name" {
  type = string
  description = "Name of your API gateway"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. staging, preprod, prod)"
}

variable "allow_origins" {
  type = list(string)
  description = "List of origins allowed by CORS for the API"
}