# Email Delivery

## Provider

Brevo via SMTP. No additional gems — ActionMailer's built-in SMTP delivery method is used directly.

## Credentials shape

All four values are stored in Rails encrypted credentials. To edit:

```bash
mise exec -- bin/rails credentials:edit
```

Expected structure:

```yaml
brevo:
  smtp_key: <SMTP key from Brevo dashboard>
  login: ab3250001@smtp-brevo.com
  port: 587
  smtp_server: smtp-relay.brevo.com
```

Read in production config as:

```ruby
Rails.application.credentials.dig(:brevo, :smtp_server)
Rails.application.credentials.dig(:brevo, :port)
Rails.application.credentials.dig(:brevo, :login)
Rails.application.credentials.dig(:brevo, :smtp_key)
```

## Environment behavior

| Environment | Delivery method | Notes |
|-------------|-----------------|-------|
| `production` | `:smtp` via Brevo | `raise_delivery_errors = true` so failures surface in logs |
| `development` | inherited (`:smtp` default but no host key needed) | `raise_delivery_errors = false` — configure Letter Opener or similar if needed |
| `test` | `:test` | Emails accumulate in `ActionMailer::Base.deliveries`; never sent |

## Production SMTP settings

Configured in `config/environments/production.rb`:

- Address: `smtp-relay.brevo.com` (from `credentials.dig(:brevo, :smtp_server)`)
- Port: 587 (from `credentials.dig(:brevo, :port)`)
- Authentication: plain
- TLS: STARTTLS (auto)
- User name: Brevo SMTP login (from `credentials.dig(:brevo, :login)`)
- Password: Brevo SMTP key (from `credentials.dig(:brevo, :smtp_key)`)

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

To send a live smoke test against production SMTP after deploy:

```bash
bin/kamal app exec --reuse -- bin/rails runner "SmokeMailer.ping.deliver_now"
```

## Troubleshooting

**"451 Authentication failed: Maximum credits exceeded"** — This is a sender-side quota or billing issue on the provider's end, not a credentials problem. We hit this on the prior provider (SendGrid free tier) before migrating to Brevo. If you see it on Brevo, check the Brevo dashboard for plan limits and sending quota.

**Email not arriving in production** — Check:
1. `Rails.application.credentials.dig(:brevo, :smtp_key)` returns a non-nil value on the server.
2. Production logs for ActionMailer delivery errors (`raise_delivery_errors = true` in production).
3. Brevo dashboard for delivery events, bounce reports, and sending quota.

## Sender

Default sender is configured in `ApplicationMailer`:

```ruby
default from: 'contato@adoteumfilhopovo.org.br'
```

The domain `adoteumfilhopovo.org.br` must be verified in the Brevo dashboard (Senders & Domains) for reliable delivery.
