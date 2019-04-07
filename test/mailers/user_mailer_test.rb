require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "password_reset" do
    user = users(:one)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Seems You've Forgotten Your Password (Again)",    mail.subject
    assert_equal [user.email],                                      mail.to
    assert_equal ["noreply@saturnstreams.tv"],	                    mail.from
    assert_match user.reset_token,                                  mail.body.encoded
    assert_match CGI.escape(user.email),                            mail.body.encoded
  end
end
