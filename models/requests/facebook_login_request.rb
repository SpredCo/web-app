class FacebookLoginRequest < PostRequest
  def initialize(token)
    req = APIHelper::Request::FACEBOOK_LOGIN
    super(nil, req[:service], req[:end_point], {access_token: token})
  end
end