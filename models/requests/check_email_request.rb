class CheckEmailRequest < GetRequest
  def initialize(email)
    req = Api::Request::CHECK_EMAIL
    super(nil, req[:service], "#{req[:end_point]}/#{email}")
  end
end