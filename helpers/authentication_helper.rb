module AuthenticationHelper
    def authenticate!
      redirect '/' unless session[:current_user].is_a? CurrentUser
    end

    def self.login(user)
      req = case user[:grant_type]
              when 'google_token'
                GoogleLoginRequest.new(user[:access_token])
              when 'facebook_token'
                FacebookLoginRequest.new(user[:access_token])
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
      case params['signup-type']
        when 'google_token'
          {request: GoogleSignupRequest, access_token: params[:access_token], signup_type: params['signup-type']}
        when 'facebook_token'
          {request: FacebookSignupRequest, access_token: params[:access_token], signup_type: params['signup-type']}
        when 'password'
          response = UserHelper.check_new_account_validity(params[:email], params[:password], params['confirm-password'])
          if response
            {errors: response}
          else
            {request: SpredSignupRequest, email: params[:email], password: params[:password],
             first_name: params['first-name'], last_name: params['last-name'],
             signup_type: params['signup-type']}
          end
        else
          nil
      end
    end
  end
