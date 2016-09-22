 module Authentication
    def authenticate!
      redirect '/' unless session[:current_user]
    end

    def self.login(login_type, user)
      case login_type
        when 'google_token'
          req = GoogleLoginRequest.new(user[:access_token])
          req.send
        when 'facebook_token'
          req = FacebookLoginRequest.new(user[:access_token])
          req.send
        else
          req = SpredLoginRequest.new(user[:email], user[:password])
          req.send
      end
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
       response[:errors]
     else
       fill_future_user(params)
     end
   end

    def self.signup_step2(request, user)
      if user[:pseudo].empty?
        return APIError.new(403, 2, 2)
      end
      req = request.send(:new, user)
      req.send
      req.parse_response
    end

    def self.fill_future_user(params)
      case params['signup-type']
        when 'google_token'
          {request: GoogleSignupRequest, access_token: params[:access_token], signup_type: params['signup-type']}
        when 'facebook_token'
          {request: FacebookSignupRequest, access_token: params[:access_token], signup_type: params['signup-type']}
        when 'password'
          @errors = User.check_new_account_validity(params[:email], params[:password], params['confirm-password'])
          unless @errors
            {request: SpredSignupRequest, email: params[:email], password: params[:password],
             first_name: params['first-name'], last_name: params['last-name'],
             signup_type: params['signup-type']}
          end
        else
          nil
      end
    end
  end