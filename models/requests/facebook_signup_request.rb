class FacebookSignupRequest < PostRequest
  def initialize(token)
    req = Api::Request::FACEBOOK_SIGNUP
    super(req[:service], req[:end_point], token)
  end
end