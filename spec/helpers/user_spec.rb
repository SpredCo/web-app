require_relative '../spec_helper.rb'

class UserHelperTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @session = {}
    @session[:current_user] = {access_token: 'a', refresh_token: '1'}
  end

  def test_is_pseudo_available_should_return_false_if_api_return_an_error
    GetRequest.any_instance.stubs(:send).returns(APIError.new(404, 2, 2))
    return_value = Spred::User.is_pseudo_available?(@session, 'pseudo_already_used')

    assert_equal false, return_value
  end

  def test_is_email_available_should_return_false_if_api_return_an_error
    GetRequest.any_instance.stubs(:send).returns(APIError.new(404, 2, 2))
    return_value = Spred::User.is_email_available?(@session, 'pseudo_already_used')

    assert_equal false, return_value
  end

  def test_validate_future_account_return_error_if_password_does_not_match_password_confirmation
    return_value = Spred::User.check_new_account_validity(@session, 'fake@email.com', 'password', 'password_confirmation')

    assert return_value
    assert_equal Spred::User::PASSWORD_DOES_NOT_MATCH, return_value[:password]
  end

  def test_validate_future_account_return_error_if_email_is_already_used
    GetRequest.any_instance.stubs(:send).returns(APIError.new(404, 2, 2))
    return_value = Spred::User.check_new_account_validity(@session, 'fake@email.com', 'password', 'password')

    assert return_value
    assert_equal Spred::User::EMAIL_ALREADY_USED, return_value[:email]
  end

  def test_validate_future_account_return_nil_if_account_is_valid
    GetRequest.any_instance.stubs(:send).returns(true)
    return_value = Spred::User.check_new_account_validity(@session, 'fake@email.com', 'password', 'password')

    assert_nil return_value
  end
end