class GoogleLoginRequest < PostRequest
  def initialize(token)
    req = Api::Request::GOOGLE_LOGIN
    super(req[:service], req[:end_point], token)
  end
end