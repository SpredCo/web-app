class CheckFacebookTokenRequest < GetRequest
  def initialize(token)
    req = APIHelper::Request::CHECK_FACEBOOK_TOKEN
    super(nil, req[:service], req[:end_point] + "/#{token}")
  end
end