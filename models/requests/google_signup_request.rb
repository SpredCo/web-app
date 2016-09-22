class GoogleSignupRequest < PostRequest
  def initialize(token)
    req = Api::Request::GOOGLE_SIGNUP
    super(req[:service], req[:end_point], token)
  end
end