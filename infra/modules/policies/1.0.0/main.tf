locals {
  policy_path = "/karoosoftware/${var.environment}/policies/"
}

# --- SES send email ---
data "aws_iam_policy_document" "ses_send_email" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
      "ses:SendBulkEmail"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ses:FromAddress"
      values   = [
        "*@karoosoftware.co.uk"
      ]
    }
  }
}

resource "aws_iam_policy" "ses_send_email_policy" {
  name        = "karoosoftware-ses-send-email-${var.environment}"
  description = "Send email via SES"
  path        = local.policy_path
  policy      = data.aws_iam_policy_document.ses_send_email.json

  lifecycle { create_before_destroy = true }
}

# Allow your Lambda role to read the secret
data "aws_iam_policy_document" "lambda_read_secret" {
  statement {
    effect = "Allow"
    actions   = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [var.postmark_secrete]
  }
}

resource "aws_iam_policy" "lambda_read_secret" {
  name   = "karoosoftware-read-postmark-secret-${var.environment}"
  description = "Read PostMark token for email sending"
  path        = local.policy_path
  policy = data.aws_iam_policy_document.lambda_read_secret.json
}