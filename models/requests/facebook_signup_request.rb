class FacebookSignupRequest < PostRequest
  def initialize(token)
    req = APIHelper::Request::FACEBOOK_SIGNUP
    super(nil, req[:service], req[:end_point], token)
  end
end