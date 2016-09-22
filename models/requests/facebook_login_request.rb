class FacebookLoginRequest < PostRequest
  def initialize(token)
    req = Api::Request::FACEBOOK_LOGIN
    super(req[:service], req[:end_point], token)
  end
end