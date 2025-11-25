import json
import logging, os
import boto3
import urllib.request
import urllib.error

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SES = boto3.client("ses", region_name="eu-west-2")
sm = boto3.client("secretsmanager")

def require_env(name: str) -> str:
    v = os.getenv(name)
    if v is None or v.strip() == "":
        raise RuntimeError(f"Missing required environment variable: {name}")
    return v.strip()

TO_EMAILS = ["paul@karoosoftware.co.uk"]
FROM_EMAIL = "paul@karoosoftware.co.uk"  # must also be a verified sender in Postmark
POSTMARK_SERVER_TOKEN = require_env("POSTMARK_SERVER_TOKEN")


def get_postmark_token():
    resp = sm.get_secret_value(SecretId=POSTMARK_SERVER_TOKEN)
    # secret can be plain string or JSON; handle both:
    if "SecretString" in resp:
        s = resp["SecretString"]
        try:
            return json.loads(s)["POSTMARK_SERVER_TOKEN"]
        except Exception:
            return s
    raise RuntimeError("Secret value missing")


def notify_company(form_data: dict) -> None:
    """Send an email to the company with the form details via SES."""
    if not (TO_EMAILS and FROM_EMAIL):
        logger.warning("SES disabled (missing TO_EMAILS or FROM_EMAIL)")
        return

    # Safely pull values from the form
    first_name = form_data.get("firstName", "")
    surname = form_data.get("surname", "")
    email = form_data.get("email", "")
    age_range = form_data.get("ageRange", "")
    frequency = form_data.get("frequency", "")
    referrer = form_data.get("referrer", "")

    subject = "Margana early adoption request"
    body = (
        "A new request to join Margana's early adoption team.\n\n"
        "User details:\n"
        f"Name: {first_name} {surname}\n"
        f"Email: {email}\n"
        f"Age range: {age_range}\n"
        f"How often they play word games: {frequency}\n"
        f"Where they heard about us: {referrer}\n\n"
    )

    try:
        SES.send_email(
            Source=FROM_EMAIL,
            Destination={"ToAddresses": TO_EMAILS},
            Message={
                "Subject": {"Data": subject},
                "Body": {"Text": {"Data": body}},
            },
        )
        logger.info("SES email sent to company")
    except Exception as e:
        logger.exception("SES send_email failed: %s", e)


def notify_user(form_data: dict) -> None:
    """Send a confirmation email to the user via Postmark."""
    user_email = form_data.get("email")
    first_name = form_data.get("firstName", "")
    surname = form_data.get("surname", "")

    if not user_email:
        logger.warning("No user email in form_data; skipping Postmark notify_user")
        return

    try:
        token = get_postmark_token()
    except Exception as e:
        logger.exception("Failed to get Postmark token: %s", e)
        return

    payload = {
        "From": FROM_EMAIL,      # must match a verified sender in Postmark
        "To": user_email,
        "TemplateAlias": "margana-adopters-request",
        "TemplateModel": {},
        "MessageStream": "outbound",  # or your custom stream name
    }

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        "https://api.postmarkapp.com/email/withTemplate",
        data=data,
        method="POST",
        headers={
            "Accept": "application/json",
            "Content-Type": "application/json",
            "X-Postmark-Server-Token": token,
        },
    )

    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            resp_body = resp.read().decode("utf-8")
            logger.info(
                "Postmark email sent to user %s (status=%s, body=%s)",
                user_email,
                resp.status,
                resp_body,
            )
    except urllib.error.HTTPError as e:
        logger.error(
            "Postmark HTTPError: status=%s, body=%s",
            e.code,
            e.read().decode("utf-8", errors="ignore"),
        )
    except Exception as e:
        logger.exception("Postmark request failed: %s", e)


def lambda_handler(event, context):
    # Parse body from API Gateway
    try:
        body = json.loads(event.get("body") or "{}")
    except json.JSONDecodeError as e:
        logger.error("Failed to parse body as JSON: %s", e)
        body = {}

    # Log only the form payload
    logger.info("Form submission: %s", json.dumps(body))

    # Email the company via SES
    notify_company(body)

    # Email the user via Postmark
    notify_user(body)

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",  # CORS
        },
        "body": json.dumps(
            {
                "message": "Form received",
                "received": body,
            }
        ),
    }
