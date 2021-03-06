class SpredLoginRequest < PostRequest
  def initialize(email, password)
    req = APIHelper::Request::SPRED_LOGIN
    super(nil, req[:service], req[:end_point], {username: email, password: password, grant_type: 'password'})
  end
end