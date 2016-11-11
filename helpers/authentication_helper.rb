module AuthenticationHelper
  def authenticate!
    redirect '/' unless session[:spred_tokens].is_a? TokenBox
  end

  def synchronize_inbox!
    tokens = session[:spred_tokens]
    session[:current_user].inbox(tokens).get_unread_messages(tokens)
  end

  def self.login(user)
    p user
    req = case user[:login_type]
            when 'google_token'
              GoogleLoginRequest.new(user[:token])
            when 'facebook_token'
              FacebookLoginRequest.new(user[:token])
            else
              SpredLoginRequest.new(user[:username], user[:password])
          end
    req.send
    req.parse_response
  end

  def self.signup_step1(params)
    response = {}
    params.each do |k, v|
      if v.empty?
        response[:errors] ||= {}
        response[:errors][k] = "Le champs #{k} ne peut être vide."
      end
    end
    if response[:errors]
      response
    else
      fill_future_user(params)
    end
  end

  def self.signup_step2(request, user)
    if user[:pseudo].empty?
      return APIError.new(403, 2, 2)
    end
    pseudo_validity = UserHelper.check_pseudo_availability(user[:pseudo])
    return pseudo_validity if pseudo_validity.is_a? APIError
    req = request.send(:new, user)
    req.send
    req.parse_response
  end

  def self.fill_future_user(params)
    signup_type = params['signup-type']
    if  signup_type == 'password'
      response = UserHelper.check_new_account_validity(params[:email], params[:password], params['confirm-password'])
      if response
        {errors: response}
      else
        puts 'ok'
        {request: SpredSignupRequest, email: params[:email], password: params[:password],
         first_name: params['first-name'], last_name: params['last-name'],
         signup_type: params['signup-type']}
      end
    else
      validate_token(signup_type, params)
    end
  end

  def self.validate_token(token_type, params)
    token = params[:access_token]
    if token_type == 'google_token'
      validate_token = verify_google_token(token)
      if validate_token.is_a? APIError
        {errors: {google_token: validate_token.message}}
      else
        {request: GoogleSignupRequest, access_token: token, signup_type: params['signup-type']}
      end
    elsif token_type == 'facebook_token'
      validate_token = verify_facebook_token(token)
      if validate_token.is_a? APIError
        {errors: {facebook_token: validate_token.message}}
      else
        {request: FacebookSignupRequest, access_token: token, signup_type: params['signup-type']}
      end
    end
  end

  def self.verify_google_token(token)
    req = CheckGoogleTokenRequest.new(token)
    req.send
    req.parse_response
  end

  def self.verify_facebook_token(token)
    req = CheckFacebookTokenRequest.new(token)
    req.send
    req.parse_response
  end
end
