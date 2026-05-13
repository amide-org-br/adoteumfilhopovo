# Code Migration

## id

20260513000100_configure_sendgrid_email_delivery

---

## intent

Configure transactional email delivery using SendGrid for the Rails application.

The SendGrid API key already exists inside Rails credentials.

This migration must prepare the application for reliable production email delivery and local development testing.

---

## context

This project uses:

- Rails 8
- Code Migrations workflow
- XP Team execution lifecycle
- Kamal deployment
- Credentials-based secret management

The project already contains the SendGrid API key inside credentials.

The goal is to properly wire ActionMailer and establish a clean email delivery foundation.

---

## scope

- configure ActionMailer for SendGrid SMTP
- use credentials for secret access
- configure environments properly
- create base mailer setup
- create email preview support
- create health validation
- create basic smoke test mailer
- document email setup

---

## non_goals

- no marketing email flows
- no background job system
- no inbound email processing
- no template engine migration
- no external email gems unless truly necessary

---

## constraints

- Rails conventions first
- Keep implementation minimal
- No overengineering
- Production-ready configuration
- Safe local development behavior

---

## dependencies

- Kamal deployment configured
- Rails credentials configured
- SendGrid API key already available

---

## Definition of Done (DoD)

1. Emails can be delivered successfully in production
2. Local development does not accidentally send real emails
3. ActionMailer is configured correctly in all environments
4. Existing tests pass
5. Email previews work locally
6. A smoke test email can be sent successfully
7. No secrets are hardcoded

---

## Additional DoD (Email)

1. SMTP settings use credentials
2. TLS is enabled properly
3. Default sender is configured
4. Delivery errors are visible in logs
5. Configuration is documented

---

## execution_rules

- Prefer Rails defaults
- Avoid unnecessary abstractions
- Keep mailer structure simple
- Use environment-specific configuration carefully

---

## validation

- Send test email locally
- Validate production configuration
- Validate preview rendering
- Verify credentials access
- Run test suite

---

## rollback_plan

- Revert ActionMailer configuration changes
- Disable SMTP delivery method
- Restore previous environment configs if necessary

---

# Implementation Prompt

You are a senior Rails 8 engineer.

Configure SendGrid email delivery for this application.

The SendGrid API key already exists inside Rails credentials.

Follow all instructions carefully.

---

## STEP 1 — Validate credentials usage

Use Rails credentials for:

- SendGrid API key
- default sender email if available

Do NOT hardcode secrets anywhere.

---

## STEP 2 — Configure ActionMailer

Configure SMTP delivery using SendGrid.

Requirements:

- secure TLS
- proper authentication
- production-ready defaults
- environment-aware configuration

---

## STEP 3 — Environment configuration

Configure:

### development

- safe local behavior
- previews enabled
- delivery errors visible

### production

- real SMTP delivery enabled
- proper host configuration
- logging enabled

### test

- test delivery method only

---

## STEP 4 — Base mailer

Create or improve ApplicationMailer.

Requirements:

- default sender
- shared layout support
- Rails conventions

---

## STEP 5 — Email previews

Enable previews for local development.

Create at least one preview example.

---

## STEP 6 — Smoke test mailer

Create a minimal mailer capable of sending:

- simple subject
- plain text body

Purpose:
Validate infrastructure quickly.

---

## STEP 7 — Logging and observability

Ensure email delivery failures appear clearly in logs.

Do NOT silently swallow errors.

---

## STEP 8 — Documentation

Create:

/docs/EMAIL_DELIVERY.md

Include:

- provider
- environment behavior
- local testing
- troubleshooting
- production notes

---

## STEP 9 — Validation

Before finishing:

1. Run tests
2. Validate mail previews
3. Validate configuration
4. Ensure Definition of Done is satisfied

Do NOT finish if tests fail.

---

## IMPORTANT

- Keep implementation simple
- Follow Rails conventions
- Avoid unnecessary gems
- Do not introduce complex abstractions
