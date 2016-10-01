class SpredSignupRequest < PostRequest
  def initialize(user)
    req = Api::Request::SPRED_SIGNUP
    super(nil, req[:service], req[:end_point], user)
  end
end