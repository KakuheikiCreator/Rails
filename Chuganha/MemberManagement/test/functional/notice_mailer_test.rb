require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "registration_confirmation" do
    mail = NoticeMailer.registration_confirmation
    assert_equal "Registration confirmation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
