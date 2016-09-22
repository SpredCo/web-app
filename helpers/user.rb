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


    def self.check_new_account_validity(email, password, confirm_password)
      response = {}
      response[:password] = PASSWORD_DOES_NOT_MATCH if password != confirm_password
      response[:email] = EMAIL_ALREADY_USED unless is_email_available?(email)
      response.empty? ? nil : response
    end

    def self.is_email_available?(email)
      req = CheckEmailRequest.new(email)
      req.send
      !req.parse_response.is_a?(APIError)
    end

    def self.is_pseudo_available?(pseudo)
      req = CheckPseudoRequest.new(pseudo)
      req.send
      !req.parse_response.is_a?(APIError)
    end
  end
