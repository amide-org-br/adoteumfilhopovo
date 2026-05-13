# Code Migration

## id

20260513000200_migrate_email_delivery_from_sendgrid_to_brevo

---

## intent

Replace SendGrid email delivery configuration with Brevo SMTP delivery for the Adote um Filho Povo project.

The project currently uses SendGrid and must be migrated safely to Brevo with proper Rails environment configuration.

---

## context

This project uses:

- Rails 8
- ActionMailer
- Kamal deployment
- Rails credentials
- Code Migrations workflow
- XP Team lifecycle

The previous provider was SendGrid.

New provider:

Brevo SMTP

SMTP Server:
smtp-relay.brevo.com

Port:
587

Login:
ab3250001@smtp-brevo.com

Password:
provided separately and must be stored securely

---

## IMPORTANT SECURITY RULE

The provided SMTP password MUST NOT remain inside committed files.

The migration must:

- move credentials to Rails encrypted credentials or Kamal secrets
- remove any hardcoded secrets
- ensure secrets are excluded from git

---

## scope

- replace SendGrid SMTP settings
- configure Brevo SMTP
- validate ActionMailer environments
- update credentials usage
- validate delivery behavior
- update deployment secrets if needed
- update documentation

---

## non_goals

- no email template redesign
- no provider abstraction layer
- no background job changes
- no mailer refactors unless necessary

---

## constraints

- Rails conventions first
- Keep implementation minimal
- Production-ready configuration
- No unnecessary gems

---

## dependencies

- Existing ActionMailer setup
- Existing Kamal deployment
- Existing credentials system

---

## Definition of Done (DoD)

1. Emails send successfully through Brevo
2. No SendGrid configuration remains active
3. SMTP credentials are stored securely
4. Existing tests pass
5. Production configuration works correctly
6. Local previews continue functioning
7. No secrets are committed to git

---

## Additional DoD (Email)

1. TLS works correctly
2. SMTP authentication succeeds
3. Delivery failures are visible in logs
4. Environment configs remain isolated
5. Existing mailers continue functioning

---

## execution_rules

- Prefer Rails defaults
- Keep ActionMailer simple
- Avoid unnecessary abstractions
- Remove obsolete SendGrid configuration cleanly

---

## validation

- Send smoke test email
- Validate ActionMailer config
- Validate production readiness
- Validate credentials access
- Run tests

---

## rollback_plan

- Restore previous SendGrid SMTP configuration
- Revert credential changes
- Revert ActionMailer config changes

---

# Implementation Prompt

You are a senior Rails 8 engineer.

Migrate email delivery from SendGrid to Brevo SMTP.

Follow all instructions carefully.

---

## STEP 1 — Remove SendGrid configuration

Locate and remove:

- SendGrid SMTP settings
- obsolete environment variables
- obsolete documentation
- unused SendGrid references

Do NOT remove unrelated mailer configuration.

---

## STEP 2 — Configure Brevo SMTP

Configure ActionMailer SMTP settings using:

SMTP server:
smtp-relay.brevo.com

Port:
587

Login:
ab3250001@smtp-brevo.com

Use STARTTLS properly.

---

## STEP 3 — Secure credentials handling

Move SMTP password into:

- Rails credentials
OR
- Kamal secrets

Do NOT hardcode secrets anywhere.

Do NOT leave secrets in committed files.

---

## STEP 4 — Environment configuration

Validate:

### development
- safe local behavior
- previews enabled

### production
- real SMTP delivery enabled
- proper host configuration

### test
- test delivery method only

---

## STEP 5 — Validate existing mailers

Ensure existing mailers still work correctly.

Do NOT break current email flows.

---

## STEP 6 — Logging and visibility

Ensure delivery failures appear clearly in logs.

---

## STEP 7 — Documentation

Update:

/docs/EMAIL_DELIVERY.md

Include:

- Brevo configuration
- troubleshooting
- local behavior
- production notes

Remove SendGrid references.

---

## STEP 8 — Validation

Before finishing:

1. Run tests
2. Send smoke test email
3. Validate previews
4. Ensure Definition of Done is satisfied

Do NOT finish if tests fail.

---

## IMPORTANT

- Keep implementation minimal
- Follow Rails conventions
- Avoid unnecessary complexity
- Ensure secrets remain secure
