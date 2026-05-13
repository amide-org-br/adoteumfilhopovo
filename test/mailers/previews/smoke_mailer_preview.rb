class SmokeMailerPreview < ActionMailer::Preview
  def ping
    SmokeMailer.ping
  end
end
