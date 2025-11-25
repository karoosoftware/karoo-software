variable "environment" {
  type        = string
  description = "Environment name (e.g. staging, preprod, prod)"
}

variable "postmark_secrete" {
  type = string
  description = "Postmark secret for used for sending emails"
}