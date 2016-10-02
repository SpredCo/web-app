class CheckEmailRequest < GetRequest
  def initialize(email)
    req = APIHelper::Request::CHECK_EMAIL
    super(nil, req[:service], "#{req[:end_point]}/#{email}")
  end
end