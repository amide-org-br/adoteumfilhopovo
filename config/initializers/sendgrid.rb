if Rails.application.credentials.sendgrid.present? && Rails.application.credentials.sendgrid[:sender_api_key].present?
  ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey',
    :password => Rails.application.credentials.sendgrid[:sender_api_key],
    :domain => 'adoteumfilhopovo.org.br',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
else
  Rails.logger.warn "SendGrid credentials not configured. Email sending will be disabled."
  ActionMailer::Base.delivery_method = :test
end