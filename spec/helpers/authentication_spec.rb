require 'minitest/autorun'
require_relative '../spec_helper'

describe AuthenticationHelper do
  before do
    BaseRequest.any_instance.stubs(:send).returns(nil)
  end

  describe 'login' do
    it 'should return error on invalid credentials' do
      params = {username: 'test@test.fr', password: 'test', login_type: 'password'}
      SpredLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = AuthenticationHelper.login(params)

      response.must_be_nil
    end

    it 'should return error on invalid google token' do
      params = {username: 'test@test.fr', password: 'test', login_type: 'google_token'}
      GoogleLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = AuthenticationHelper.login(params)

      response.must_be_nil
    end

    it 'should return error on invalid facebook token' do
      params = {username: 'test@test.fr', password: 'test', login_type: 'facebook_token'}
      FacebookLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = AuthenticationHelper.login(params)

      response.must_be_nil
    end

    it 'should return access and refresh tokens on valid credentials' do
      params = {username: 'test@test.fr', password: 'test', login_type: 'password'}
      SpredLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = AuthenticationHelper.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end

    it 'should return access and refresh tokens on valid google_token' do
      params = {access_token: 'google_token', login_type: 'google_token'}
      GoogleLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = AuthenticationHelper.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end

    it 'should return access and refresh tokens on valid facebook_token' do
      params = {access_token: 'google_token', login_type: 'facebook_token'}
      FacebookLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = AuthenticationHelper.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end
  end

  describe 'signup_step1' do
    it 'should returns error if some fields are missing' do
      params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', first_name: '', last_name: ''}
      errors = AuthenticationHelper.signup_step1(params)

      errors[:errors][:first_name].must_be_instance_of String
      errors[:errors][:last_name].must_be_instance_of String
    end

    it 'should returns future_user with token on google_signup' do
      params = {access_token: 'google_token', 'signup-type' => 'google_token'}
      expected_response = 'ok'
      CheckGoogleTokenRequest.any_instance.stubs(:parse_response).returns(expected_response)
      future_user = AuthenticationHelper.signup_step1(params)

      future_user[:request].must_equal GoogleSignupRequest
      future_user[:access_token].must_equal params[:access_token]
      future_user[:signup_type].must_equal params['signup-type']
    end

    it 'should returns future_user with token on facebbok_signup' do
      params = {access_token: 'facebook_token', 'signup-type' => 'facebook_token'}
      expected_response = 'ok'
      CheckFacebookTokenRequest.any_instance.stubs(:parse_response).returns(expected_response)
      future_user = AuthenticationHelper.signup_step1(params)

      future_user[:request].must_equal FacebookSignupRequest
      future_user[:access_token].must_equal params[:access_token]
      future_user[:signup_type].must_equal params['signup-type']
    end

    describe 'Fill future user' do
      it 'should verify and returns error if password and confirmation does not match' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password12', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        CheckEmailRequest.any_instance.stubs(:parse_response).returns({})
        errors = AuthenticationHelper.fill_future_user(params)

        errors[:errors][:password].must_be_instance_of String
      end

      it 'should verify and returns error if email is already used' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        expected_error = APIError.new(403, 2, 1)
        CheckEmailRequest.any_instance.stubs(:parse_response).returns(expected_error)
        errors = AuthenticationHelper.fill_future_user(params)

        errors[:errors][:email].must_equal expected_error.message
      end

      it 'should verify and returns future user if account is valid' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        CheckEmailRequest.any_instance.stubs(:parse_response).returns({})
        future_user = AuthenticationHelper.fill_future_user(params)

        future_user[:request].must_equal SpredSignupRequest
        future_user[:email].must_equal params[:email]
        future_user[:password].must_equal params[:password]
        future_user[:first_name].must_equal params['first-name']
        future_user[:last_name].must_equal params['last-name']
      end
    end
  end
end
