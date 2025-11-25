#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <environment>"
  echo "  environment: preprod | prod"
  exit 1
}

ENVIRONMENT="${1:-}"
[[ -z "$ENVIRONMENT" ]] && usage

# --- Config: tweak if your prod bucket/name differs ---
PREPROD_BUILD="build:preprod"
PREPROD_BUCKET="s3://preprod.karoosoftware.co.uk/"

PROD_BUILD="build:prod"
PROD_BUCKET="s3://www.karoosoftware.co.uk/"
# ------------------------------------------------------

# Basic deps check
command -v npm >/dev/null 2>&1 || { echo "npm not found in PATH"; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "aws CLI not found in PATH"; exit 1; }

case "$ENVIRONMENT" in
  preprod)
    BUILD_SCRIPT="$PREPROD_BUILD"
    S3_BUCKET="$PREPROD_BUCKET"
    ;;

  prod)
    BUILD_SCRIPT="$PROD_BUILD"
    S3_BUCKET="$PROD_BUCKET"

    echo "⚠️  You are about to DEPLOY TO **PROD**: $S3_BUCKET"
    read -r -p "Type 'prod' to confirm: " CONFIRM
    if [[ "$CONFIRM" != "prod" ]]; then
      echo "Aborted."
      exit 1
    fi
    ;;

  *)
    usage
    ;;
esac

echo "→ Running build: npm run $BUILD_SCRIPT"
npm run "$BUILD_SCRIPT"

# Ensure build output exists
if [[ ! -d "./dist" ]]; then
  echo "Error: ./dist not found after build."
  exit 1
fi

echo "→ Syncing ./dist to $S3_BUCKET"
aws s3 sync ./dist "$S3_BUCKET" --delete

echo "✅ Deploy to $ENVIRONMENT complete."