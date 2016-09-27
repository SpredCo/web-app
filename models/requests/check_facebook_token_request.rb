class CheckFacebookTokenRequest < GetRequest
  def initialize(token)
    req = Api::Request::CHECK_FACEBOOK_TOKEN
    super(req[:service], req[:end_point] + "/#{token}")
  end
end