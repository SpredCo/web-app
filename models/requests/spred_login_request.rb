class SpredLoginRequest < PostRequest
  def initialize(email, password)
    req = Api::Request::SPRED_LOGIN
    super(req[:service], req[:end_point], {email: email, password: password})
  end
end