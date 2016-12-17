class GetUserRequest < GetRequest
  def initialize(id)
    req = APIHelper::Request::USER_GET
    super(nil, req[:service], "#{req[:end_point]}/#{id}")
  end
end
