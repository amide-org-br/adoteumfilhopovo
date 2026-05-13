# Email Delivery

## Provider

SendGrid via SMTP. No additional gems — ActionMailer's built-in SMTP delivery method is used directly.

## Credentials shape

The API key is stored in Rails encrypted credentials. To edit:

```bash
mise exec -- bin/rails credentials:edit
```

Expected structure:

```yaml
sendgrid:
  api_key: SG.xxxxxxxxxxxx
```

Read in production config as:

```ruby
Rails.application.credentials.dig(:sendgrid, :api_key)
```

## Environment behavior

| Environment | Delivery method | Notes |
|-------------|-----------------|-------|
| `production` | `:smtp` via SendGrid | `raise_delivery_errors = true` so failures surface in logs |
| `development` | inherited (`:smtp` default but no host key needed) | `raise_delivery_errors = false` — configure Letter Opener or similar if needed |
| `test` | `:test` | Emails accumulate in `ActionMailer::Base.deliveries`; never sent |

## Production SMTP settings

Configured in `config/environments/production.rb`:

- Address: `smtp.sendgrid.net`
- Port: 587
- Authentication: plain
- TLS: STARTTLS (auto)
- User name: `"apikey"` (literal string — SendGrid SMTP convention)
- Password: value from `credentials.dig(:sendgrid, :api_key)`

## Local development previews

ActionMailer previews are available at `http://localhost:3000/rails/mailers` when `bin/dev` is running.

Available previews:
- `SmokeMailerPreview#ping` — minimal smoke test email
- `AdocaoMailerPreview` — prayer card adoption email

## Smoke test

To verify email infrastructure without touching production data:

```ruby
# In rails console (development or production)
SmokeMailer.ping.deliver_now
```

In test suite, `SmokeMailerTest#test_ping_delivers_one_email_with_expected_subject` verifies the mailer produces the correct subject and recipient.

## Troubleshooting

**"SendGrid credentials not configured"** — This message came from the old initializer (`config/initializers/sendgrid.rb`), which has been removed. If you see it in old logs, it is stale.

**Email not arriving in production** — Check:
1. `Rails.application.credentials.dig(:sendgrid, :api_key)` returns a non-nil value on the server.
2. Production logs for ActionMailer delivery errors (`raise_delivery_errors = true` in production).
3. SendGrid dashboard for delivery events and bounce/spam reports.

**Key was renamed from `apii_key` to `api_key`** — The credentials file previously had a typo (`apii_key`). If you see nil from `dig(:sendgrid, :api_key)`, verify the credentials file has the correct key name.

## Sender

Default sender is configured in `ApplicationMailer`:

```ruby
default from: 'contato@adoteumfilhopovo.org.br'
```

The domain `adoteumfilhopovo.org.br` must be verified in the SendGrid dashboard for reliable delivery.
