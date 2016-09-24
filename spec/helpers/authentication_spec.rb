require 'minitest/autorun'
require_relative '../spec_helper'

describe Authentication do
  before do
    BaseRequest.any_instance.stubs(:send).returns(nil)
  end

  describe 'login' do
    it 'should return error on invalid credentials' do
      params = {email: 'test@test.fr', password: 'test', grant_type: 'password'}
      SpredLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = Authentication.login(params)

      response.must_be_nil
    end

    it 'should return error on invalid google token' do
      params = {email: 'test@test.fr', password: 'test', grant_type: 'google_token'}
      GoogleLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = Authentication.login(params)

      response.must_be_nil
    end

    it 'should return error on invalid facebook token' do
      params = {email: 'test@test.fr', password: 'test', grant_type: 'facebook_token'}
      FacebookLoginRequest.any_instance.stubs(:parse_response).returns(nil)
      response = Authentication.login(params)

      response.must_be_nil
    end

    it 'should return access and refresh tokens on valid credentials' do
      params = {email: 'test@test.fr', password: 'test', grant_type: 'password'}
      SpredLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = Authentication.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end

    it 'should return access and refresh tokens on valid google_token' do
      params = {access_token: 'google_token', grant_type: 'google_token'}
      GoogleLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = Authentication.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end

    it 'should return access and refresh tokens on valid facebook_token' do
      params = {access_token: 'google_token', grant_type: 'facebook_token'}
      FacebookLoginRequest.any_instance.stubs(:parse_response).returns({access_token: 'access_token', refresh_token: 'refresh_token'})
      response = Authentication.login(params)

      response[:access_token].must_be_instance_of String
      response[:refresh_token].must_be_instance_of String
    end
  end

  describe 'signup_step1' do
    it 'should returns error if some fields are missing' do
      params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', first_name: '', last_name: ''}
      errors = Authentication.signup_step1(params)

      errors[:first_name].must_be_instance_of String
      errors[:last_name].must_be_instance_of String
    end

    it 'should returns future_user with token on google_signup' do
      params = {access_token: 'google_token', 'signup-type' => 'google_token'}
      future_user = Authentication.signup_step1(params)

      future_user[:request].must_equal GoogleSignupRequest
      future_user[:access_token].must_equal params[:access_token]
      future_user[:signup_type].must_equal params['signup-type']
    end

    it 'should returns future_user with token on facebbok_signup' do
      params = {access_token: 'facebook_token', 'signup-type' => 'facebook_token'}
      future_user = Authentication.signup_step1(params)

      future_user[:request].must_equal FacebookSignupRequest
      future_user[:access_token].must_equal params[:access_token]
      future_user[:signup_type].must_equal params['signup-type']
    end

    describe 'Signup step 2' do
      it 'should returns error in blank pseudo' do
        params = {pseudo: ''}
        expected_error = APIError.new(403, 2, 2)
        error = Authentication.signup_step2(GoogleSignupRequest, params)

        error.message.must_equal expected_error.message
      end

      it 'should returns error in already user pseudo' do
        params = {pseudo: 'toto', access_token: 'google_token'}
        expected_error = APIError.new(403, 2, 2)
        CheckPseudoRequest.any_instance.stubs(:parse_response).returns(APIError.new(403, 2, 2))
        error = Authentication.signup_step2(GoogleSignupRequest, params)

        error.message.must_equal expected_error.message
      end
    end

    describe 'Fill future user' do
      it 'should verify and returns error if password and confirmation does not match' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password12', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        CheckEmailRequest.any_instance.stubs(:parse_response).returns({})
        errors = Authentication.fill_future_user(params)

        errors[:password].must_be_instance_of String
      end

      it 'should verify and returns error if email is already used' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        expected_error = APIError.new(403, 2, 1)
        CheckEmailRequest.any_instance.stubs(:parse_response).returns(expected_error)
        errors = Authentication.fill_future_user(params)

        errors[:email].must_equal expected_error.message
      end

      it 'should verify and returns future user if account is valid' do
        params = {email: 'toto@titi.fr', password: 'password', 'confirm-password' => 'password', 'first-name' => 'test', 'last-name' => 'test', 'signup-type' => 'password'}
        CheckEmailRequest.any_instance.stubs(:parse_response).returns({})
        future_user = Authentication.fill_future_user(params)

        future_user[:request].must_equal SpredSignupRequest
        future_user[:email].must_equal params[:email]
        future_user[:password].must_equal params[:password]
        future_user[:first_name].must_equal params['first-name']
        future_user[:last_name].must_equal params['last-name']
      end
    end
  end
end