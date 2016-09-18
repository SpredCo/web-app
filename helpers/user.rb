module User
  PRIVATE_FIELDS = [:public_id]

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
    response[:error][:password] = 'Password does not match' unless password == confirm_password
    response[:error][:email] = 'Email already in use' unless is_email_available?(email)
    response.empty? ? nil : response
  end

  def self.is_email_available?(email)
    req = GetRequest.new(session, :login, ApiEndPoint::CHECK_EMAIL, email)
    response = req.send
    !response.is_a?(APIError)
  end

  def self.is_pseudo_available?(pseudo)
    req = GetRequest.new(session, :login, ApiEndPoint::CHECK_PSEUDO, pseudo)
    response = req.send
    !response.is_a?(APIError)
  end
end