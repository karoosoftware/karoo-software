terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-2"
}

module "s3_static_website" {
  source      = "../../modules/static-website/1.0.0"
  bucket_name = "www.karoosoftware.co.uk"
}

locals {
  build_dir = "${path.module}/build"

  # If you need a API route, then add details to the API route as well
  lambdas = {
    early_adoption_form = {
      function_name    = "early-adoption-form"
      function_handler = "early_adoption_form.lambda_handler"
      src_rel          = "early_adoption_form.py"
      name             = "early_adoption_form"
      policies = [
        "arn:aws:iam::992468223519:policy/karoosoftware/${var.environment}/policies/karoosoftware-ses-send-email-${var.environment}",
        "arn:aws:iam::992468223519:policy/karoosoftware/${var.environment}/policies/karoosoftware-read-postmark-secret-${var.environment}",
      ]
      env_vars = {
        POSTMARK_SERVER_TOKEN = module.secrets_manager.postmark_secrete
      }
    }
  }
}

# Ensure build dir exists (archive_file needs it)
resource "null_resource" "mkdir_build" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.build_dir}"
  }
}

# Zip each single-file Lambda from ../../../python
data "archive_file" "zip" {
  for_each    = local.lambdas
  type        = "zip"
  source_file = abspath("${path.module}/../../../python/${each.value.src_rel}")
  output_path = abspath("${local.build_dir}/${each.value.name}.zip")
  depends_on  = [null_resource.mkdir_build]
}


module "cloudfront_dist" {
  source              = "../../modules/cloudfront-dist/1.0.0"
  name                = "karoosoftware-${var.environment}"
  origin_domain       = module.s3_static_website.website_endpoint
  alias_name          = module.s3_static_website.bucket_name
  acm_certificate_arn = "arn:aws:acm:us-east-1:992468223519:certificate/e1d5fb8d-adb2-44e0-b0fc-634dcc06c50f"
}

module "route53" {
  source         = "../../modules/route53/1.0.0"
  zone_id        = "Z09113681C7TM2UX7F2CQ"
  domain_name    = module.cloudfront_dist.dns_domain_name
  hosted_zone_id = module.cloudfront_dist.hosted_zone_id
  record_name    = "www.karoosoftware.co.uk"
}

module "secrets_manager" {
  source      = "../../modules/secrets_manager/1.0.0"
  environment = var.environment
}

module "policies" {
  source           = "../../modules/policies/1.0.0"
  environment      = var.environment
  postmark_secrete = module.secrets_manager.postmark_secrete
}

module "lambda" {
  for_each         = local.lambdas
  source           = "../../modules/lambda/1.0.0"
  environment      = var.environment
  function_name    = "${each.value.function_name}-${var.environment}"
  function_handler = each.value.function_handler
  filename         = data.archive_file.zip[each.key].output_path
  name             = each.value.name
  policies         = each.value.policies
  env_vars         = each.value.env_vars
  source_code_hash = data.archive_file.zip[each.key].output_base64sha256
}

module "api" {
  source      = "../../modules/apigw_http/1.0.0"
  environment = var.environment
  apigw_name  = "karoosoftware-apigw-${var.environment}"
  allow_origins = [
    "https://www.karoosoftware.co.uk",
    "http://localhost:5173"
  ]
}

module "api_routes" {
  source        = "../../modules/apigw_lambda_integration/1.0.0"
  environment   = var.environment
  api_id        = module.api.api_id
  execution_arn = module.api.execution_arn
  authorizer_id = ""

  routes = {
    validate_word_post = {
      lambda_arn = module.lambda["early_adoption_form"].arn
      method     = "POST"
      path       = "/early_adoption_form"
      authorize  = false
    }
  }
}