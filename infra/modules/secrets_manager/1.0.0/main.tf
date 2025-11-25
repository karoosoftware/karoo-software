# Create an empty secret container (no value in state)
resource "aws_secretsmanager_secret" "postmark" {
  name       = "postmark/karoosoftware-email-token-${var.environment}"
}