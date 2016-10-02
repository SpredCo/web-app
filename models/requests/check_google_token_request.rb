class CheckGoogleTokenRequest < GetRequest
  def initialize(token)
    req = APIHelper::Request::CHECK_GOOGLE_TOKEN
    super(nil, req[:service], req[:end_point] + "/#{token}")
  end
end