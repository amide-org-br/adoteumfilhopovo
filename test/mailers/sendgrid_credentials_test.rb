require "test_helper"

class SendgridCredentialsTest < ActiveSupport::TestCase
  test "credentials expose sendgrid api_key (not apii_key)" do
    api_key = Rails.application.credentials.dig(:sendgrid, :api_key)
    assert api_key.present?, "Expected credentials.sendgrid.api_key to be present — check credentials (key may still be 'apii_key')"
  end
end
