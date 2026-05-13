require "test_helper"

class SmokeMailerTest < ActionMailer::TestCase
  test "ping delivers one email with expected subject" do
    email = SmokeMailer.ping
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal "[smoke] adoteumfilhopovo", email.subject
    assert_equal [ "contato@adoteumfilhopovo.org.br" ], email.to
  end
end
