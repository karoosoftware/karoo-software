variable "name" {
  type = string
  description = "Name of the CDN distribution"
}

variable "origin_domain" {
  type        = string
  description = "Domain name of the origin S3 bucket website endpoint"
}

variable "acm_certificate_arn" {
  type = string
  description = "Certificate that you wish to use with this distribution"
}

variable "alias_name" {
  type = string
  description = "Alias name for your CDN"
}