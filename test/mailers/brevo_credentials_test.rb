require "test_helper"

class BrevoCredentialsTest < ActiveSupport::TestCase
  REQUIRED_BREVO_KEYS = %i[smtp_key login port smtp_server].freeze

  REQUIRED_BREVO_KEYS.each do |key|
    test "credentials expose brevo #{key}" do
      value = Rails.application.credentials.dig(:brevo, key)
      assert value.present?,
        "Expected credentials.brevo.#{key} to be present — run bin/rails credentials:edit"
    end
  end

  test "credentials brevo port is an Integer" do
    port = Rails.application.credentials.dig(:brevo, :port)
    assert_kind_of Integer, port,
      "Expected credentials.brevo.port to be an Integer (got #{port.class}) — SMTP libs require numeric port"
  end
end
