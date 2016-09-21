class Spred
  module User
    PRIVATE_FIELDS = [:public_id]
    PASSWORD_DOES_NOT_MATCH = 'Les mots de passes ne correspondent pas'
    EMAIL_ALREADY_USED = 'L\'adresse email est déjà utilisée'

    def self.build_profile_picture_url(path)
      pic_url = path.split('/')
      pic_url.shift
      pic_url.join('/')
    end

    def self.save_profile_picture(path, file)
      File.open(path, 'w') do |f|
        f.write(file.read)
      end
    end


    def self.check_new_account_validity(session, email, password, confirm_password)
      response = {}
      response[:password] = PASSWORD_DOES_NOT_MATCH if password != confirm_password
      response[:email] = EMAIL_ALREADY_USED unless is_email_available?(session, email)
      response.empty? ? nil : response
    end

    def self.is_email_available?(session, email)
      req = GetRequest.new(session, :login, ApiEndPoint::CHECK_EMAIL + "/#{email}")
      response = req.send
      !response.is_a?(APIError)
    end

    def self.is_pseudo_available?(session, pseudo)
      req = GetRequest.new(session, :login, ApiEndPoint::CHECK_PSEUDO + "/#{pseudo}")
      response = req.send
      !response.is_a?(APIError)
    end

    def self.login(session, login_type, user)
      case login_type
        when 'google_token'
          req = PostRequest.new(session, :login, ApiEndPoint::GOOGLE_LOGIN, {access_token: user[:access_token]})
          req.send
        when 'facebook_token'
          req = PostRequest.new(session, :login, ApiEndPoint::FACEBOOK_LOGIN, {access_token: user[:access_token]})
          req.send
        when 'password'
          verified_params = {'grant_type' => 'password'}.merge!(user.select {|k,_| [:username, :password, :first_name, :last_name].include?(k.to_sym) })
          req = PostRequest.new(session, :login, ApiEndPoint::LOGIN, verified_params)
          req.send
      end
    end
  end
end
